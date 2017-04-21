.. _How_to_use_BuildTest:



How to use BuildTest
====================

If you have not completed setup your environment please :ref:`checkout the  setup. <Setup>`


Usage
-----

Let's start with the basics. 

If you are unsure about buildtest see the help section for more information.

.. program-output:: cat scripts/buildtest-help.txt

Building the Test
-----------------

Whenever you want to build a test, check your module file to find out what software package
exist on your system, then simply run the test as follows:

.. program-output:: cat scripts/example-GCC-5.4.0-2.27.txt

buildtest will setup your environment with CTEST so you can build from out-of-source directory.
Create a new directory for instance **build**, then do the following

.. program-output:: cat scripts/test-GCC-5.4.0-2.27.txt


System Package Test
-------------------

buildtest can generate tests for system packages using the flag **--system**. Currently, system package 
test only perform binary test. This means you need to find the binaries associated with the package and
add the executable and any parameters in command.yaml.

This file will be $BUILDTEST_SOURCEDIR/system/$pkg/command.yaml where $pkg is name of system package.
At this moment, buildtest is using Redhat package naming convention.


.. code::

   [hpcswadm@amrndhl1157 BuildTest]$ python buildtest.py --system gcc-c++
        Creating Test: /hpc/hpcswadm/BuildTest/testing/system/gcc-c++/x86_64-redhat-linux-c++.sh
        Creating Test: /hpc/hpcswadm/BuildTest/testing/system/gcc-c++/g++.sh
        Creating Test: /hpc/hpcswadm/BuildTest/testing/system/gcc-c++/x86_64-redhat-linux-g++.sh
        Creating Test: /hpc/hpcswadm/BuildTest/testing/system/gcc-c++/c++.sh

To run all system package test do the following

.. code::

   [hpcswadm@amrndhl1157 BuildTest]$ python buildtest.py --system all


