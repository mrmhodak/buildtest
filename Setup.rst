.. _Setup:

buildtest Setup
===============


Requirements
-------------
 - Python
 - argparse, PyYAML library
 - easyconfig repo
 - Lmod/Environment Modules
 - CMake >= 2.8


Let's first get you setup with buildtest, so you can than start testing :)

Setup
-----

Make sure you have python on your system. If not please install it.

.. code:: 

   $ python -V
     Python 2.7.5

Let's check if you have argparse and PyYAML package installed. Start up a
python session and try importing the argparse and yaml package

.. code::

   -bash-4.2$ python
        Python 2.7.5 (default, Oct 11 2015, 17:47:16) 
        [GCC 4.8.3 20140911 (Red Hat 4.8.3-9)] on linux2
        Type "help", "copyright", "credits" or "license" for more information.
        >>> import argparse
        >>>

If you get an error like the following: 

.. code::

        Traceback (most recent call last):
        File "<stdin>", line 1, in <module>
        ImportError: No module named argparse

Then you need to install the package via pip or a package manager. Similarly try the
same with **yaml** package

.. code::

      -bash-4.2$ python
        Python 2.7.5 (default, Oct 11 2015, 17:47:16) 
        [GCC 4.8.3 20140911 (Red Hat 4.8.3-9)] on linux2
        Type "help", "copyright", "credits" or "license" for more information.
        >>> import yaml
        >>>
     
Another way to check this is by running **pip list** to see if you have the 
package installed, for this you would need pip on your system.

buildtest Configuration
-----------------------

Setup your shell environment for buildtest to match your directory path.

I have my buildtest directory at /hpc/grid/scratch/workspace/BuildTest/BuildTest/

.. code::
       
        [hpcswadm@hpcv27 scripts]$ export BUILDTEST_SOURCEDIR=/hpc/grid/scratch/workspace/BuildTest/BuildTest/source
        [hpcswadm@hpcv27 scripts]$ export BUILDTEST_ROOT=/hpc/grid/scratch/workspace/BuildTest/BuildTest
        [hpcswadm@hpcv27 scripts]$ export BUILDTEST_MODULEROOT=/nfs/grid/software/RHEL7/easybuild/modules
        [hpcswadm@hpcv27 scripts]$ export BUILDTEST_EASYCONFIGDIR=/hpc/grid/scratch/workspace/BuildTest/BuildTest/easybuild
        [hpcswadm@hpcv27 scripts]$ export BUILDTEST_TESTDIR=/hpc/grid/scratch/workspace/BuildTest/BuildTest/testing

        [hpcswadm@hpcv27 scripts]$ env | grep BUILDTEST
        BUILDTEST_SOURCEDIR=/hpc/grid/scratch/workspace/BuildTest/BuildTest/source
        BUILDTEST_ROOT=/hpc/grid/scratch/workspace/BuildTest/BuildTest
        BUILDTEST_MODULEROOT=/nfs/grid/software/RHEL7/easybuild/modules
        BUILDTEST_EASYCONFIGDIR=/hpc/grid/scratch/workspace/BuildTest/BuildTest/easybuild
        BUILDTEST_TESTDIR=/hpc/grid/scratch/workspace/BuildTest/BuildTest/testing


The shell environment variables are used only by test-scripts in case you need to
build a test that can't be achieved by buildtest framework. The testscript can
reference source directory via **BUILDTEST_SOURCEDIR** to find files of interest

Python buildtest variable configuration
---------------------------------------

The shell environment variables that we setup previously, we will now do the same 
for python variables found in file **setup.py**. These variables are referenced by 
multiple python scripts. 

1. Edit **setup.py** and specify path for your module tree root at 
**BUILDTEST_MODULEROOT**. This variable is used by **buildtest** to find modules 
in your system and used to verify which test can be created by buildtest.


For instance, **BUILDTEST_MODULEROOT** on my system is set to /nfs/grid/software/RHEL7/easybuild/modules/ 

.. code:: 
           
      [hpcswadm@amrndhl1157 BuildTest]$ ls -l /nfs/grid/software/RHEL7/easybuild/modules 
      total 2
      drwxr-xr-x 5 hpcswadm hpcswadm 69 Mar 27 14:25 all

2.  Specify the path for the easyconfig directory in **setup.py** for variable 
**BUILDTEST_EASYCONFIGDIR**. This will be used for finding the toolchains which 
is necessary to build the test.



.. Note:: If you haven't cloned your easyconfig repo, make sure you do this otherwise
        buildtest will hang. easyconfig files in repo but not installed on the system can 
        cause issues

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

        [hpcswadm@amrndhl1157 BuildTest]$ ./buildtest.py -ls | head -n 15
        
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

        [hpcswadm@amrndhl1157 BuildTest]$ ./buildtest.py -lt
 
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


