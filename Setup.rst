.. _Setup:

Setup
=====


Requirements
-------------
 - Python
 - argparse, PyYAML library
 - easyconfig repo
 - Lmod/Environment Modules
 - CMake >= 2.8


Let's first get you setup with buildtest, so you can than start testing :)

Pre-Setup
----------

Make sure you have Python and the PyYAML package on your system. If not please install it.

.. code:: 

   $ python -V
     Python 2.7.5

If you get an error like the following: 

.. code::

        Traceback (most recent call last):
        File "<stdin>", line 1, in <module>
        ImportError: No module named yaml

Then you need to install the package via pip or a package manager.
     

Environment Setup
-----------------

Follow instructions on getting buildtest and its config repos
in your system. If you have a easybuild-easyconfigs repo then please clone
that too.

.. program-output:: cat scripts/Setup/clonerepo.txt

          
There is a few environment variables that need to be set prior to using this
framework.

Environment Description:

    - **BUILDTEST_ROOT**: root directory of buildtest
    - **BUILDTEST_SOURCEDIR**: source directory where YAML test scripts are picked up
    - **BUILDTEST_EASYCONFIGDIR**: easyconfig directory used for toolchain verification
    - **BUILDTEST_TESTDIR**: directory where test scripts will be generated and used by CTEST
    - **BUILDTEST_MODULE_EBROOT**: root of easybuild module tree
    - **BUILDTEST_PYTHON_DIR**: root of Python buildtest directory
    - **BUILDTEST_PERL_DIR**: root of Perl buildtest directory
    - **BUILDTEST_R_DIR**: root of R buildtest directory

To setup the buildtest environment variable source  **setup.sh** in your shell environment. 

.. note:: 
   The script assumes you have cloned buildtest-framework and all the extra repos inside 
   buildtest-framework so the paths are in reference to $BUILDTEST_ROOT. If you decide to 
   to clone them somewhere else, then manually edit the file or export the variables with
   the correct path


.. program-output:: cat scripts/Setup/envsetup.txt

Once you have sourced setup.sh you will need to specify the following environment variables:

* BUILDTEST_MODULE_EBROOT
* BUILDTEST_EASYCONFIGDIR

Each site will have their own configuration where they install their eb apps and easyconfig repo.


The environment variables are used by buildtest to determine the path where to retrieve
module files, easyconfigs, and yaml configs and write test scripts. You can also reference
these variables in yaml configs to write custom build and run commands. The testscript can
reference source directory via **BUILDTEST_SOURCEDIR** to find files of interest

Setup Check
-----------

You can check if you are configured properly by running the following

.. code::

   buildtest --check-config

This will check if the system has the following set
    
1. Buildtest environment variables
2. Check if module exists and whether you are running Lmod/environment-modules

.. program-output:: cat scripts/Setup/check_setup.txt


You can check the current version of buildtest by running the following

.. program-output:: cat scripts/Setup/version.txt

Verification
-------------

Check if software and toolchain are processed by buildtest 

buildtest finds the modulefiles from *BUILDTEST_MODULE_EBROOT* and extracts the 
name and version since module files are stored in format <software>/<version>. 
buildtest adds software into a set to report unique software. buildtest uses 
easyconfig files to extract the toolchain names by processing the toolchain 
field from each easyconfig and adds the toolchain to set.

Software List
-------------

buildtest can report the software list by running the following

.. code:: 

   buildtest -ls

buildtest determines the software list based on your module tree and these are
apps that can be used for generating tests

.. program-output:: cat scripts/Setup/softwarelist.txt    


Toolchain List
--------------

buildtest can list the toolchain list by running

.. code::
   
   buildtest -lt

This will get the same result defined by **eb --list-toolchains**, we have
taken the list of toolchains from eb and defined them in buildtest. Any app
built with the any of the toolchains can be used with buildtest to generate
tests.

.. program-output:: cat scripts/Setup/toolchainlist.txt


If you are able to get to this far, now you can start building tests


