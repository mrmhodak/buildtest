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

Let's get buildtest on your system. Follow instructions below to clone buildtest
buildtest-config and your easyconfig repo in your system

.. program-output:: cat scripts/Setup/clonerepo.txt

          
There is a few environment variables that need to be set prior to using this
framework.

Environment Description:

    - **BUILDTEST_ROOT**: root directory of buildtest
    - **BUILDTEST_SOURCEDIR**: source directory where YAML test scripts are picked up
    - **BUILDTEST_EASYCONFIGDIR**: easyconfig directory used for toolchain verification
    - **BUILDTEST_TESTDIR**: directory where test scripts will be generated and used by CTEST
    - **BUILDTEST_MODULEPATH**: root of module tree

This can be done by sourcing **setup.sh**

.. program-output:: cat scripts/Setup/envsetup.txt

buildtest requires easyconfig and buildtest-config repo to reside in the directory where you cloned buildtest.
Make sure the name of your easyconfig repo matches the value for BUILDTEST_EASYCONFIGDIR
in setup.sh that is used to specify the location where all your easyconfig files resides.


The shell environment variables are used by buildtest to determine paths where to retrieve
module files, easyconfigs, and yaml configs and write test scripts. You can also reference
these variables in yaml configs to write custom build and run commands. The testscript can
reference source directory via **BUILDTEST_SOURCEDIR** to find files of interest


Verification
-------------

Check if software and toolchain are processed by buildtest 

buildtest finds the modulefiles from *BUILDTEST_MODULEROOT* and extracts the 
name and version since module files are stored in format <software>/<version>. 
buildtest adds software into a set to report unique software. buildtest uses 
easyconfig files to extract the toolchain names by processing the toolchain 
field from each easyconfig and adds the toolchain to set.

Software List
-------------

.. code::    

        [hpcswadm@amrndhl1157 BuildTest]$ python buildtest.py -ls | head -n 15
        
                       List of Unique Software: 
                      ---------------------------- 
        Advisor
        Anaconda2
        Anaconda3
        Autoconf
        Automake
        Autotools
        BEDTools
        BWA
        BamTools
        Bison
        Boost
        Bowtie  

Toolchain List
--------------

.. code::

        [hpcswadm@amrndhl1157 BuildTest]$ python buildtest.py -lt
 
                List of Toolchains:
                --------------------
              
        GCCcore 6.2.0
        dummy dummy
        iimpic 2017.01-GCC-5.4.0-2.27
        GCC 5.4.0-2.27
        iccifortcuda 2017.1.132-GCC-5.4.0-2.27
        GCC 6.2.0-2.27
        gompic 2016.03
        iompi 2017.01
        gompi 2016.09
        iccifort 2017.1.132-GCC-5.4.0-2.27
        GCCcore 5.4.0
        gcccuda 2016.03
        foss 2016.03
        intel 2017.01
        goolfc 2016.03
        foss 2016.09
        gompi 2016.03
        iimpi 2017.01-GCC-5.4.0-2.27


If you are able to get to this far, now you can start testing.


