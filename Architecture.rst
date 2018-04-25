.. _Architecture:

buildtest Architecture
=======================


.. contents::
   :backlinks: none


This section will explain how the buildtest framework is designed in regards
to

* Software, Toolchain, easyconfig check
* Testing Directory Structure
* CTest configuration
* Source Directory Structure


Software and Toolchain Check
----------------------------

buildtest takes argument to build tests for software that can take argument from 
**--software**. The argument to --software is autopopulated based on the 
software modules found in module tree ``$BUILDTEST_EBROOT``.

Similarly, **--toolchain** is autopopulated based on union of software modules
present in ``$BUILDTEST_EBROOT`` and the toolchain list. Every
toolchain must be a software found in module tree ``$BUILDTEST_EBROOT``.

The buildtest options menu pre-processes this information into a list that is 
supplied as **choice** attribute in ``argparse.arg_argument``. For more detail
on this check out ``framework.tools.menu``

1. ModuleFile Verication
2. Toolchain verfication
3. Easyconfig Verification

Module File Format and Module Naming Scheme
-------------------------------------------

Modulefiles are used in test script to load the software environment to test
the software's functionality. Typically the HPC software stack is installed in
a cluster filesystem in a non-standard Linux path so modules
are used to load the environment properly. 

Names of modulefiles depend on module naming scheme in Easybuild this is 
controlled by ``eb --module-naming-scheme``. The default naming scheme is 
**Easybuild Module Naming Scheme (EasyBuildMNS)** which is a flat naming scheme. 
This naming scheme is simple because it presents the software stack in
one directory and names of module file tend to be long because they take the 
format of ``<app>/<version>-<toolchain>``. 

For instance loading ``OpenMPI-2.0.0`` built with ``GCC-5.4.0-2.27`` will be 

.. code::

   module load OpenMPI/2.0.0-GCC-5.4.0-2.27

Similarly, easybuild supports **Hierarchical Module Naming Scheme (HMNS)** that
categorize software module stack in different trees that are loaded dynamically 
based on your current module list. 

With HMNS, the the module format will be different. You will  be loading the toolchain module (``GCC``) 
followed by the application module (``OpenMPI``). 

.. code::

   module load GCC/5.4.0-2.27
   module load OpenMPI/2.0.0

Modules in EasyBuildMNS will be unique so you will just  use ``buildtest -s`` and
toolchain option ``--toolchain`` will be ignored. If you have a HMNS module tree defined
in BUILDTEST_EBROOT then you will need to use both options ``buildtest -s <app> -t <toolchain>`` 

Easybuild automatically generates modules for all software installed by easybuild
and each module is written in a way to load all dependent modules necessary, 
therefore users don't need to worry about loading every dependent module in their
environment.

How buildtest gets the software module stack 
--------------------------------------------

As mentioned previously, buildtest makes use of environment variable 
``$BUILDTEST_EBROOT`` (i.e root of module tree) to find all the software
modules. Easybuild supports Tcl and Lua modules so buildtest attempts to find
all files that are actual module files.

buildtest ignores ``.version`` or ``.default`` files and accepts all other files
in the module tree. This information is processed further by stripping full
path to extract the module name depending if you specified BUILDTEST_MODULE_NAMING_SCHEME
as Flat Naming Scheme (FNS) or Hierarchical Module Naming Scheme (HMNS). This 
can be specified in the buildtest command line ``buildtest --module-naming-scheme`` or 
environment variable ``$BUILDTEST_MODULE_NAMING_SCHEME`` or in ``config.yaml``

The software module stack is used to populate the choice entries for ``--software``
and ``--toolchain``. buildtest supports TAB completion for ease of use.

To demonstrate this example see what happens when you type **lib** in --software
with TAB completion

.. code:: shell

   [siddis14@amrndhl1157 buildtest-framework]$ buildtest -s lib
   libdrm/.2.4.76                libharu/.2.3.0                libpthread-stubs/.0.3         libX11/.1.6.3                 libXext/.1.3.3                libXrender/.0.9.9
   libffi/.3.2.1                 libICE/.1.0.9                 libreadline/.6.3              libXau/.1.0.8                 libXft/.2.3.2                 libXt/.1.1.5
   libGLU/.9.0.0                 libjpeg-turbo/.1.5.0          libSM/.1.2.2                  libxcb/.1.11.1                libxml2/.2.9.4
   libgtextutils/.0.7            libpng/.1.6.23                libtool/.2.4.6                libXdmcp/.1.1.2               libxml2/.2.9.4-Python-2.7.12


The tab completion works for **--toolchain** to find all software modules that
correspond to easybuild toolchain.

To demonstrate this example, see the available toolchains in the system.

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ buildtest -t
   foss/.2016.03                        GCC/6.2.0-2.27                       gompi/.2016.09                       iimpi/.2017.01-GCC-5.4.0-2.27        iompi/2017.01
   foss/.2016.09                        GCCcore/.5.4.0                       gompi/.2016b                         iimpic/.2017.01
   foss/.2016b                          GCCcore/.6.2.0                       iccifort/.2017.1.132-GCC-5.4.0-2.27  intel/2017.01
   GCC/5.4.0-2.27                       gompi/.2016.03                       iccifortcuda/.2017.01                intelcuda/2017.01

buildtest takes a union of a list of predefined toolchains from ``eb --list-toolchains``
that is defined in module ``framework.tools.easybuild.list_toolchain`` and 
list of software module stack. For details on implementation check out ``framework.tools.software.get_software_stack`` 
and ``framework.tools.software.get_toolchain_stack``

Determine if software is installed with easybuild
---------------------------------------------------------

All easybuild software will have the variable ``local root`` in the modulefile that points 
to the root of the software package. For instance ``Anaconda2-5.0.1`` module file has the following
value 

.. code::

        local root = "/nfs/grid/software/easybuild/commons/software/Anaconda2/5.1.0"

We use this value to check if there is a directory ``easybuild`` which eb should generate
to store log file, patches, easyconfigs, etc... In buildtest we check if there is an
easyconfig file in the ``easybuild`` directory and if it exists then we assume the application
is an easybuild software otherwise it is not.

For more details on implementation see ``framework.tools.easybuild.is_easybuild_app``

If you plan to mix easybuild module trees with non-easybuild module trees by defining 
them in ``BUILDTEST_EBROOT`` then extra care must be taken.

If you are building tests for an application not built with easybuild you may run into the following issue

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ buildtest -s ruby/2.2.4
   Application: ruby/2.2.4  is not built from Easybuild, cannot find easyconfig file in installation directory

By default easybuild will check if the software is an easybuild app and will exit immediately. If you want to
ignore the easybuild check you may use the option ``buildtest --ignore-easybuild`` to bypass this error. This also 
assumes you have the module tree defined in ``MODULEPATH`` so ``module load ruby/2.2.4`` will work for the tests. 
If there are multiple counts of same application version module across module trees you will need to fix that in
your environment or modify which module trees are exposed in ``BUILDTEST_EBROOT``

 
Testing Directory Structure
-------------------------------

buildtest will write the tests in the directory specified by **BUILDTEST_TESTDIR**. This value
can be specified in ``config.yaml``, or environment variable ``$BUILDTEST_TESTDIR`` or command line
``buildtest --testdir <path>``. 



Recall that CTest is the Testing Framework that automatically generates Makefiles necessary 
to build and run the test. CTest will utilize *CMakeLists.txt* that will invoke 
CTest api to run the the test.  

.. include:: Architecture/cmakelist_layout.txt

Whenever you build the test, you must specify the software and version 
and this must match the name of the module you are trying to test, otherwise 
there is no way of knowing what is being tested.  Each test will attempt to 
load the application module along with the toolchain if specified prior to 
anything. Similarly, toolchain must be specified with the exception of dummy 
toolchain. If toolchain is hidden module in your system, you must specify 
your toolchain version accordingly

CMake Configuration
-------------------

CMakeLists.txt for $BUILDTEST_TESTDIR/ebapps/GCC/CMakeLists.txt would like
this for GCC-5.4.0-2.27 and GCC-6.2.0-2.27 test

.. program-output:: cat scripts/Architecture/GCC/CMakeLists.txt

The CMakeLists.txt in your test directory will look something like this

.. program-output:: cat scripts/Architecture/GCC/test/CMakeLists.txt


Testsets
---------

Test sets are meant to reuse YAML configs between different apps. For instance,
we can have all the MPI wrappers (OpenMPI, MPICH, MVAPICH, etc...) use
one set of YAML files. For applications like R, Python, Perl, etc... that comes 
with 100s of subpackages, we only have the scripts and buildtest will automatically
build the testscripts. buildtest will process subdirectories and properly name the 
tests for CTest to avoid name conflict



If you build R without testset it will build not build the tests for R packages 
that are stored in ``R-buildtest-config`` repo

.. code:: 
 
         [siddis14@amrndhl1157 buildtest-framework]$ buildtest -s R/3.3.1 -t intel/2017.01 --ignore-easybuild
         [BINARYTEST]: Processing YAML file for  R/3.3.1 intel/2017.01  at  /lustre/workspace/home/siddis14/buildtest-configs/ebapps/R/command.yaml

         Generating 2 binary tests for Application: R/3.3.1
         Binary Tests are written in /tmp/buildtest-tests/ebapp/R/3.3.1/intel/2017.01
         [SOURCETEST]: Processing all YAML files in  /lustre/workspace/home/siddis14/buildtest-configs/ebapps/R/config
         Generating 1 Source Tests and writing at  /tmp/buildtest-tests/ebapp/R/3.3.1/intel/2017.01
         Writing Log file:  /tmp/buildtest/R/3.3.1/intel/2017.01/buildtest_19_37_24_04_2018.log

         [siddis14@amrndhl1157 buildtest-framework]$ ls -l /tmp/buildtest-tests/ebapp/R/3.3.1/intel/2017.01
         total 16
         -rw-r--r-- 1 siddis14 amer 266 Apr 24 19:37 CMakeLists.txt
         -rw-r--r-- 1 siddis14 amer 150 Apr 24 19:37 hello.R.sh
         -rw-r--r-- 1 siddis14 amer  87 Apr 24 19:37 Rscript_--version.sh
         -rw-r--r-- 1 siddis14 amer  81 Apr 24 19:37 R_--version.sh



If you run ``buildtest -s R/3.3.1 -t intel/2017.01`` without ``--testset R`` flag, buildtest
will only build tests from YAML files in $BUILDTEST_CONFIGS_REPO. If ``--testset R`` was enabled 
buildtest will also build tests from $BUILDTEST_R_DIR. To illustrate this see what happens
when enabling ``--testset R``

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ buildtest -s R/3.3.1 -t intel/2017.01 --ignore-easybuild --testset R
   [BINARYTEST]: Processing YAML file for  R/3.3.1 intel/2017.01  at  /lustre/workspace/home/siddis14/buildtest-configs/ebapps/R/command.yaml

   Generating 2 binary tests for Application: R/3.3.1
   Binary Tests are written in /tmp/buildtest-tests/ebapp/R/3.3.1/intel/2017.01
   [SOURCETEST]: Processing all YAML files in  /lustre/workspace/home/siddis14/buildtest-configs/ebapps/R/config
   Generating 1 Source Tests and writing at  /tmp/buildtest-tests/ebapp/R/3.3.1/intel/2017.01
   Generating  3 tests for  fastcluster
   Generating  1 tests for  bitops
   Generating  3 tests for  gbm
   Generating  1 tests for  bnlearn
   Generating  14 tests for  adabag
   Generating  1 tests for  forecast
   Generating  54 tests for  timeDate
   Generating  1 tests for  fpc
   Generating  1 tests for  bio3d
   Generating  1 tests for  subplex
   Generating  1 tests for  fma
   Generating  14 tests for  BatchJobs
   Generating  1 tests for  futile.logger
   Generating  49 tests for  tm
   Generating  1 tests for  FactoMineR
   Generating  1 tests for  EasyABC
   Generating  1 tests for  flashClust
   Generating  1 tests for  tensor
   Generating  1 tests for  bootstrap
   Generating  14 tests for  geepack
   Generating  11 tests for  akima
   Generating  1 tests for  TeachingDemos
   Generating  15 tests for  gdalUtils
   Generating  1 tests for  calibrate
   Generating  1 tests for  fdrtool
   Generating  1 tests for  fpp
   Generating  1 tests for  Cairo
   Generating  12 tests for  cgdsr
   Generating  1 tests for  SuperLearner
   Generating  1 tests for  futile.options
   Generating  72 tests for  adegenet
   Generating  1 tests for  Brobdingnag
   Generating  33 tests for  geiger
   Generating  20 tests for  testthat
   Generating  1 tests for  boot
   Generating  1 tests for  fossil
   Generating  25 tests for  arm
   Generating  1 tests for  trimcluster
   Generating  1 tests for  ADGofTest
   Generating  1 tests for  FNN
   Generating  1 tests for  car
   Generating  1 tests for  SuppDists
   Generating  5 tests for  abind
   Generating  13 tests for  gclus
   Generating  35 tests for  base
   Generating  1 tests for  stringr
   Generating  1 tests for  ffbase
   Generating  1 tests for  fail
   Generating  1 tests for  foreign
   Generating  1 tests for  fastmatch
   Generating  12 tests for  unbalanced
   Generating  1 tests for  filehash
   Generating  1 tests for  expm
   Generating  1 tests for  ellipse
   Generating  1 tests for  bigmemory
   Generating  9 tests for  gamlss.data
   Generating  1 tests for  fastICA
   Generating  1 tests for  evaluate
   Generating  1 tests for  strucchange
   Generating  1 tests for  stringi
   Generating  9 tests for  tibble
   Generating  22 tests for  tripack
   Generating  1 tests for  Formula
   Generating  8 tests for  tseriesChaos
   Generating  285 tests for  ade4
   Generating  1 tests for  backports
   Generating  1 tests for  fracdiff
   Generating  1 tests for  tkrplot
   Generating  136 tests for  ape
   Generating  1 tests for  bit
   Generating  12 tests for  chron
   Generating  1 tests for  brglm
   Generating  11 tests for  gam
   Generating  42 tests for  gdata
   Generating  1 tests for  fields
   Generating  25 tests for  adephylo
   Generating  2 tests for  base64
   Generating  4 tests for  TH.data
   Generating  27 tests for  tseries
   Generating  11 tests for  assertthat
   Generating  1 tests for  beanplot
   Generating  1 tests for  tensorA
   Generating  1 tests for  survival
   Generating  1 tests for  formatR
   Generating  1 tests for  taxize
   Generating  1 tests for  flexmix
   Generating  1 tests for  tcltk
   Generating  8 tests for  abc
   Generating  2 tests for  acepack
   Generating  1 tests for  FME
   Generating  10 tests for  gamlss.dist
   Generating  36 tests for  TTR
   Generating  1 tests for  flexclust
   Generating  70 tests for  TraMineR
   Generating  4 tests for  AlgDesign
   Generating  8 tests for  AUC
   Generating  51 tests for  checkmate
   Generating  8 tests for  animation
   Generating  1 tests for  statmod
   Generating  1 tests for  caret
   Generating  1 tests for  survivalROC
   Generating  3 tests for  extrafont
   Generating  1 tests for  foreach
   Generating  14 tests for  tidyr
   Generating  10 tests for  tree
   Generating  34 tests for  cluster
   Generating  1 tests for  caTools
   Generating  91 tests for  ff
   Writing tests to  /tmp/buildtest-tests/ebapp/R/3.3.1/intel/2017.01
   Writing Log file:  /tmp/buildtest/R/3.3.1/intel/2017.01/buildtest_19_39_24_04_2018.log



Source Code Layout
--------------------

The source directory **BUILDTEST_CONFIGS_REPO** contains all the source code that 
will be used for generating the test. Here, you will find config scripts used 
for generating scripts. buildtest processes these config scripts inorder to 
generate the test.


+----------------------------------------------------+--------------------------------------------------------------------------+
|                     File                           |                                Description                               |  
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_CONFIGS_REPO/$software/command.yaml     |       A list of binary executables and parameters to test                |  
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_CONFIGS_REPO/$software/config/          |       Contains the yaml config files used for building test from source  |
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_CONFIGS_REPO/$software/code/            |       Directory Containing the source code, which is referenced          |
|                                                    |       by the testscript and yaml files                                   |
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_CONFIGS_REPO/system/command.yaml        |       A list of binary executables and parameters to for system packages |
+----------------------------------------------------+--------------------------------------------------------------------------+
