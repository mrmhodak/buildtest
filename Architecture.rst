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
software modules found in module tree $BUILDTEST_MODULE_EBROOT.

Similarly, **--toolchain** is autopopulated based on union of software modules
present in $BUILDTEST_MODULE_EBROOT and the toolchain list. Every
toolchain must be a software found in module tree $BUILDTEST_MODULE_EBROOT.

The buildtest options menu pre-processes this information into a list that is 
supplied as **choice** attribute in ``argparse.arg_argument``. For more detail
on this check out ``framework.tools.menu``

1. ModuleFile Verication
2. Toolchain verfication
3. Easyconfig Verification

How modulefiles affect testing
------------------------------

modulefiles are used in test script to load the software environment to test
the software's functionality. Typically the HPC software stack is installed in
a cluster filesystem that is non-standard Linux path (i.e $PATH) so modules
are used to load the environment properly. 

Names of modulefiles depend on module naming scheme in Easybuild this is 
controlled by ``eb --module-naming-scheme``. The default naming scheme is 
Easybuild Module Naming Scheme (EasyBuildMNS) which is a flat naming scheme. 
This naming scheme is simple, the complete  software module stack is present in
one directory and names of module file tend to be long because they take the 
format of ``<app>/<version>-<toolchain>``. 

For instance loading OpenMPI 2.0.0 with GCC-5.4.0-2.27 will be 

.. code::

   module load OpenMPI/2.0.0-GCC-5.4.0-2.27

Similarly, easybuild supports Hierarchical Module Naming Scheme (HMNS) that
categorize software module stack in different trees that are loaded dynamically 
based on your current module list. 

With HMNS, the same module will be loaded in its regular form but from a tree
GCC-5.4.0-2.27

.. code::

   module load OpenMPI/2.0.0

In HMNS, the module specified with **--toolchain**  must be loaded first prior 
to loading module specified by **--software**. This is due to the fact 
$MODULEPATH is altered inside toolchain modules to load different module trees
which allow users to load software modules. 

In each test script you will see the following commands

.. code::

        module purge
        module load <Toolchain>/<Toolchain-version>
        module load <Software>/<Software-version>


Easybuild automatically generates modules for all software installed by easybuild
and each module is written in a way to load all dependent modules necessary, 
therefore users don't need to worry about loading every dependent module in their
environment.

buildtest supports both EasyBuildMNS and HierarchicalMNS. buildtest takes
argument from ``--software`` and ``--toolchain`` to figure out which modules
need to be loaded at setup. 

How buildtest gets the software module stack 
--------------------------------------------

As mentioned previously, buildtest makes use of environment variable 
$BUILDTEST_MODULE_EBROOT (i.e root of module tree) to find all the software
modules. Easybuild supports Tcl and Lua modules so buildtest attempts to find
all files that are actual module files.

buildtest ignores ``.version`` or ``.default`` files and accepts all other files
in the module tree. This information is processed further by stripping full
path to extract the module name depending if you specified BUILDTEST_MODULE_NAMING_SCHEME
as Flat Naming Scheme (FNS) or Hierarchical Module Naming Scheme (HMNS). This 
can be specified in the buildtest command line via

.. code::

   buildtest --module-naming-scheme

The software module stack is used to populate the choice entries for --software
and --toolchain. buildtest supports TAB completion for ease of use.

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

How to determine if software is installed with easybuild
---------------------------------------------------------

You might wonder, how do we map software & toolchain from our software stack with 
buildtest.

From the previous two examples, we find that --software and --toolchain are 
predefined list automatically generated from your software stack. Also note that
the combination of --software and --toolchain will not determine the software
is actually installed on the system. The only way to determine this is to see
if a particular easyconfig was built using ``eb`` command. 

You can run into an issue if the software and toolchain do not correspond to an 
actual software installation. Since we have no way to determine the software is 
actually installed by analyzing the file structure or querying 
a rpm database, or a user command history of eb commands, buildtest takes a 
different approach to solve this problem. 

**buildtest assumes that easyconfig found in $BUILDTEST_EASYCONFIG_DIR was used
in installing the software stack**. 

.. Note:: $BUILDTEST_EASYCONFIG_DIR is path to your easybuild-easyconfig directory

In easybuild, each easyconfig corresponds to a software module that makes up the 
software stack. Even if the easyconfig is present in your easybuild-easyconfig repo but not 
installed in the software stack the following deduction is valid.

**Every software module in software stack must come from only 1 unique easyconfig
file**. 

This only applies that HPC site do not mix up easybuild software stack with custom
software stack in their module tree.

With that being said, buildtest conducts a easyconfig check to verify software
is installed.

 
easyconfig check
----------------

You might run into an issue when easyconfig check fails

.. code:: 

        [siddis14@amrndhl1157 buildtest-framework]$ buildtest -s GCC/5.4.0-2.27 -t GCCcore/.5.4.0
        ERROR: No such easyconfig file: /lustre/workspace/home/siddis14/easybuild-easyconfigs/easybuild/easyconfigs/g/GCC/GCC-5.4.0-2.27-GCCcore-5.4.0.eb

        buildtest checks the easyconfig to ensure application is installed with easybuild


.. Note:: Modules that are hidden must be passed with a leading dot in --software and 
   --toolchain option


Every application is built with a particular toolchain in EasyBuild. 
In order to make sure we are building for the correct test in the event
of multiple packages are installed with different toolchain we need a 
way to classify which package to use. For instance if **flex/2.6.0** is 
installed with **GCCcore/5.4.0**, **GCCcore/6.2.0**, and **dummy** toolchain 
then we have three instances of this package. In 
**Hierarchical Module Naming Scheme (HMNS)**  these 3 instances could be in 
different module trees. We can perform this test by searching all the easyconfig 
files with the directory name **flex** and search for the tag 
**toolchain = { name='toolchain-name', version='toolchain-version' }**


The easyconfig verification will pass if all of the conditions are met:

   1. software,version argument specified to buildtest matches 
      **name**, **version** tag in easyconfig

   2. toolchain argument from buildtest matches 
      **toolchain-name**, **toolchain-version** tag in easyconfig

   3. **versionsuffix** from eb file name matches the module file. 

   4. For **Hierarchical Module Naming Scheme (HMNS)** 
      modulefile: <version>-<version-suffix>.lua 

   5. For **Flat Naming Scheme (FNS)** 
      modulefile: <version>-<toolchain>-<version-suffix>.lua

Module File Check is not sufficient for checking modules in the event when there
is a match for a software package but there is a toolchain mismatch. For instance 
if R/3.3.1 is built with intel/2017.01 toolchain and the user request to build 
R/3.3.1 with foss/2016.09, the module file & toolchain verification will pass 
but it wouldn't pass the easyconfig verification if there is no easyconfig found.


.. code:: shell

        [siddis14@amrndhl1295 buildtest-framework]$ buildtest -s R/3.3.1 -t foss/.2016.09
        Checking Software: R/3.3.1  ... SUCCESS
        Checking Software: foss/.2016.09  ... SUCCESS
        Checking Toolchain: foss/.2016.09 ... SUCCESS
        Checking easyconfig file ... FAILED
        ERROR: Attempting to  find easyconfig file  R-3.3.1-foss-2016.09.eb
        Writing Logfile:  /hpc/grid/hpcws/hpcengineers/siddis14/buildtest-framework/log/buildtest_10_32_28_08_2017.log


Testing Directory Structure
-------------------------------

buildtest will write the tests in the directory specified by **BUILDTEST_TESTDIR**. 
By default the testing directory is set to **BUILDTEST_ROOT/testing**. Recall that 
CTest is the Testing Framework that automatically generates Makefiles necessary 
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
that are stored in R-buildtest-config repo

.. program-output:: cat scripts/Architecture/R-3.3.1_without_testset.txt



If you run ``buildtest -s R/3.3.1 -t intel/2017.01`` without ``--testset R`` flag, buildtest
will only build tests from YAML files in $BUILDTEST_SOURCE. If ``--testset R`` was enabled 
buildtest will also build tests from $BUILDTEST_R_DIR. To illustrate this see what happens
when enabling ``--testset R``

.. program-output:: cat scripts/Architecture/R-3.3.1_with_testset.txt



Source Code Layout
--------------------

The source directory **BUILDTEST_SOURCEDIR** contains all the source code that 
will be used for generating the test. Here, you will find config scripts used 
for generating scripts. buildtest processes these config scripts inorder to 
generate the test.


+----------------------------------------------------+--------------------------------------------------------------------------+
|                     File                           |                                Description                               |  
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/$software/command.yaml        |       A list of binary executables and parameters to test                |  
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/$software/config/             |       Contains the yaml config files used for building test from source  |
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/$software/code/               |       Directory Containing the source code, which is referenced          |
|                                                    |       by the testscript and yaml files                                   |
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/system/command.yaml           |       A list of binary executables and parameters to for system packages |
+----------------------------------------------------+--------------------------------------------------------------------------+
