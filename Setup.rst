.. _Setup:

buildtest Setup
===============


.. contents::
   :backlinks: none


Requirements
------------

 - Linux OS (Redhat or Centos)
 - Python 2.6 or recent version of 2.x
 - argparse, PyYAML library
 - easyconfig repo
 - A module tool environment - Lmod or EnvironmentModules
 - CMake >= 2.8


Let's first get you setup with buildtest, so you can than start testing :)


Installing buildtest
--------------------

Follow instructions on getting buildtest and its config repos
in your system. If you have a easybuild-easyconfigs repo then please clone
that too.

.. program-output:: cat scripts/Setup/clonerepo.txt

Once you clone the repos you should have the following layout

.. program-output:: cat scripts/Setup/buildtest-directory.txt


buildtest Environment Variables
-------------------------------
          
There are a few buildtest environment variables that you should
be aware of when using buildtest


.. include:: Setup/buildtest-environment.txt



To setup the buildtest environment variable run ``source  setup.sh`` in your shell environment. 

.. note:: 
   The script assumes you have cloned buildtest-framework and all the extra repos inside 
   buildtest-framework so the paths are in reference to $BUILDTEST_ROOT. If you decide to 
   to clone them somewhere else, then manually edit the **setup.sh** or export the variables with
   the correct path


.. program-output:: cat scripts/Setup/envsetup.txt

Once you have sourced setup.sh you will need to specify the following environment variables:

* BUILDTEST_MODULE_EBROOT
* BUILDTEST_EASYCONFIGDIR

Each site will have their own configuration where they install their eb apps and location
to easyconfig repo.


The environment variables are used by buildtest to determine the path where to retrieve
module files, easyconfigs, and yaml configs and write test scripts. You can also reference
these variables in yaml configs to write custom build and run commands. The testscript can
reference source directory via **BUILDTEST_SOURCEDIR** to find files of interest

Verify buildtest configuration
------------------------------

You can check if you are configured properly by running the following

.. code::

   buildtest --check-setup

This will check if the system has the following set
    
1. Buildtest environment variables
2. Check if module exists and whether you are running Lmod/environment-modules

.. program-output:: cat scripts/Setup/check_setup.txt

Don't worry if BUILDTEST_TESTDIR failed, once you create a test $BUILDTEST_ROOT/testing will be
created where all the tests will be stored. The check indicates the directory doesn't exist, 
but buildtest will check this before creating the test.


buildtest version
-----------------

You can check the current version of buildtest by running the following

.. program-output:: cat scripts/Setup/version.txt




