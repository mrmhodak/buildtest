.. _Architecture:

buildtest Architecture
=======================


Two Step Verification
---------------------

BuildTest performs a two-step verification before creating any test case. This 
is designed to prevent buildtest from creating testscripts that would fail during execution.

1. ModuleFile Verication
2. Easyconfig Toolchain Verification

**Module File Verification:** buildtest makes use of **$BUILDTEST_MODULEROOT** 
to find all the modules and stores the values in an array. Whenever an argument 
is passed for **--software** it is checked with the module array to make sure 
it exist. If there is no module found with the following name, the program will 
terminate immediately 

**Easyconfig Toolchain verification:** Every application is built with a 
particular toolchain in EasyBuild. In order to make sure we are building for 
the correct test in the event of multiple packages being installed with 
different toolchain we need a way to classify which package to use. For instance 
if **flex/2.6.0** is installed with **GCCcore/5.4.0**, **GCCcore/6.2.0**, and 
**dummy** toolchain then we have three instances of this package. In HMNS these 
3 instances could be in different module trees. We can perform this test by 
searching all the easyconfig files with the directory name **flex** and search 
for the tag **toolchain = { name='toolchain-name', version='toolchain-version' }**


The Toolchain verification will pass if the following condition is met:

   - software,version argument specified to buildtest matches **name**, **version** tag in easyconfig
   - toolchain argument from buildtest matches **toolchain-name**, **toolchain-version** tag in easyconfig
   - **versionsuffix** from eb file name matches the module file. 
   - For **Hierarchical Module Naming Scheme (HMNS)** modulefile: <version>-<version-suffix>.lua 
   - For **Flat Naming Scheme (FNS)** modulefile: <version>-<toolchain>-<version-suffix>.lua

Module File Check is not sufficient for checking modules in the event when there
is a match for a software package but there is a toolchain mismatch. For instance 
if Python 2.7.12 is built with foss toolchain only and the user request to build 
Python 2.7.12 with intel, the module file verification will pass but it wouldn't 
pass the Toolchain verification stage.



Testing Directory Structure
-------------------------------

BuildTest will write the test in the directory specified by **BUILDTEST_TESTDIR**. 
By default the testing directory is set to **BUILDTEST_ROOT/testing**. Recall that 
CTest is the Testing Framework that automatically generates Makefiles necessary 
to build and run the test. CTest will utilize *CMakeLists.txt* that will invoke 
CTest api to run the the test.  

**Testing CMakeList Structure Layout:** 


+-----------------------------------------------------------------------------+-------------------------------------------------------------------------+
|File                                                                         |       Description                                                       |
+-----------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/CMakeLists.txt                                            |       List of entries for each software                                 |
+-----------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/system/CMakeLists.txt                                     |       Entry for each system package                                     |
+-----------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/system/$systempkg/CMakeLists.txt                          |       List of tests for system package                                  |
+-----------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/ebapps/$software/CMakeLists.txt                           |       List of version entries for each software                         | 
+-----------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/ebapps/$software/$version/CMakeLists.txt                  |       List of toolchain name entries for each version of the software   |
+-----------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/ebapps/software/$version/$toolchain-name/CMakeLists.txt   |      Entry for each toolchain version for each toolchain name           |
+-----------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/ebapps/$software/$version/$toolchain/CMakeLists.txt       |       Entry for each test to run                                        |
+-----------------------------------------------------------------------------+-------------------------------------------------------------------------+

.. Note:: Whenever you build the test, you must specify the software and version 
   and this must match the name of the module you are trying to test, otherwise 
   there is no way of knowing what is being tested.  Each test will attempt to 
   load the application module along with the toolchain if specified prior to 
   anything. Similarly, toolchain must be specified with the exception of dummy 
   toolchain. If toolchain is hidden module in your system, you must specify 
   your toolchain version accordingly

CMakeLists.txt for $BUILDTEST_TESTDIR/ebapps/GCC/CMakeLists.txt would like like this for GCC-5.4.0-2.27 and GCC-6.2.0-2.27 test

.. program-output:: cat scripts/Architecture/GCC/CMakeLists.txt

The CMakeLists.txt in your test directory will look something like this

.. program-output:: cat scripts/Architecture/GCC/test/CMakeLists.txt


Testsets
---------

Test sets are meant to reuse YAML configs between different apps. For instance, we can have all the MPI wrappers (OpenMPI, MPICH, MVAPICH, etc...) use
one set of YAML files. For applications like R, Python, Perl, etc... that comes with 100s of subpackages, we only have the scripts and buildtest will automatically
build the testscripts. buildtest will process subdirectories and properly name the tests for CTest to avoid name conflict


R directory structure

.. code::

        code:
        abc  abind  acepack  ade4  adegenet  adephylo  ADGofTest  akima  AlgDesign  animation  ape  arm  assertthat  AUC  base


If you run the R testset then you will notice each of the R package tests are stored in a separate directory.
.. code::

        [hpcswadm@amrndhl1157 buildtest]$ python buildtest.py -s R/3.3.1 -t intel/2017.01 --testset R
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/R_--version.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/Rscript_--version.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/hello.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/ADGofTest/ad.test.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/AUC/auc.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/AlgDesign/gen.factorial.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/abc/human.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/abind/abind.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/acepack/ace.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/ade4/acacia.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/adegenet/nancycats.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/adephylo/tipToRoot.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/akima/aspline.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/animation/ani.pause.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/ape/add.scale.bar.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/arm/bayespolr.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/assertthat/are_equal.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/base/abbreviate.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/base/abs.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/base/acos.R.sh
        Creating Test: /hpc/hpcswadm/buildtest/testing/ebapp/R/3.3.1/intel/2017.01/base/addNA.R.sh
        Writing Log File: /hpc/hpcswadm/buildtest/log/R/3.3.1/intel/2017.01/buildtest_11_57_17_05_2017.log


Source Code Layout
--------------------

The source directory **BUILDTEST_SOURCEDIR** contains all the source code that 
will be used for generating the test. Here, you will find config scripts used 
for generating scripts. buildtest processes these config scripts inorder to 
generate the test.


+----------------------------------------------------+--------------------------------------------------------------------------+
|                     File                           |                                Description                               |  
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/<software>/command.yaml       |       A list of binary executables and parameters to test                |  
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_TESTDIR/$software/config/               |       Contains the yaml config files used for building test from source  |
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_TESTDIR/$software/code/                 |       Directory Containing the source code, which is referenced          |
|                                                    |       by the testscript and yaml files                                   |
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/system/command.yaml           |       A list of binary executables and parameters to for system packages |
+----------------------------------------------------+--------------------------------------------------------------------------+

