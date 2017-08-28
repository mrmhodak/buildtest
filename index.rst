.. BuildTestDocs documentation master file, created by
   sphinx-quickstart on Tue Apr  4 07:54:15 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

buildtest Documentation
=========================================

Welcome to buildtest_ documentation. buildtest is a HPC Application Testing 
Framework designed to build tests more quickly and verify application in a 
module environment. 

This documentation was last rebuild on |today| and is intended for version |version|. 

**Author: Shahzeb Siddiqui**


Contents:

.. toctree::
   :glob:
   :maxdepth: 1
 
    
   Setup 
   Architecture
   Writing_Test_In_YAML    
   How_to_use_BuildTest
   Future_Work

Description
--------------------
**buildtest** is an Automatic Test Generating Framework for writing test cases 
efficiently and quickly for scientific applications. buildtest can generate 
test scripts (.sh) automatically and tests can be recreated as many times. buildtest
makes use of EasyBuild_ easyconfig files to determine which module + toolchain to use. 
You will need module environment EnvironmentModules_ or Lmod_ on your system to use this
framework 

.. _EasyBuild: https://easybuild.readthedocs.io/en/latest/
.. _EnvironmentModules: http://modules.sourceforge.net/
.. _Lmod: https://github.com/TACC/Lmod


Motivation
-----------

An HPC environment has hundreds of application that running constantly, the 
HPC engineers would build these apps and put them on production system. Some
of the application have vendor provided scripts such as **make test** or 
**ctest** that can test the software after **make** step. Unfortunately, 
these methods perform tests in the build directory and does not perform a 
"Post Install Test". Changing the vendor test script to the install
paths can be tedious and this would have to be done manually. 

Writing test scripts manually can be tedious, also there is no sharing of code 
and most likely they are not compatible to work on different systems. Easybuild
takes a step at improving application build process by automating the entire 
software workflow.

buildtest takes a step to ease testing of software with similar objectives as 
EasyBuild but focusing on Testing.

What is buildtest?
------------------


buildtest is a python script that can generate self-contained testscripts in 
shell scripts (.sh). The test scripts can be run independently but they are 
designed to work in CMake_ CTest Framework. 

buildtest can:

 - Creates test for binary testing 
 - Generates test that requires compilation 
 - Verify modulefile can be loaded. 
 - generate tests for system packages
 - List software packages provided by MODULEPATH
 - List available toolchains
 - List a tabular software-version relationship
 - Verbosity level to control output
 - Support for logging
 - Search for YAML and test scripts
 - build tests easily for scripting languages (R, Python, Perl) 
 - Run tests through an interactive menu

.. _CMake: https://cmake.org/documentation/

Useful Links
-------------
* buildtest_ - The buildtest documentation
* buildtest-framework_ - The buildtest Testing framework
* buildtest-configs_ - buildtest YAML configs for generic apps
* R-buildtest-config_ - R test scripts repository
* Perl-buildtest-config_ - Perl test scripts repository
* Python-buildtest-config_ - Python test scripts repository

.. _buildtest: https://github.com/HPC-buildtest/buildtest
.. _buildtest-framework: https://github.com/HPC-buildtest/buildtest-framework
.. _buildtest-configs: https://github.com/HPC-buildtest/buildtest-configs
.. _R-buildtest-config: https://github.com/HPC-buildtest/R-buildtest-config
.. _Perl-buildtest-config: https://github.com/HPC-buildtest/Perl-buildtest-config
.. _Python-buildtest-config: https://github.com/HPC-buildtest/Python-buildtest-config



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
