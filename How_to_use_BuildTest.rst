.. _How_to_use_BuildTest:


How to use buildtest
====================


.. contents::
   :backlinks: none


If you have not completed setup your environment please :ref:`checkout the  setup. <Setup>`


Usage
-----

Let's start with the basics. 

If you are unsure about buildtest see the help section for more information.

.. program-output:: cat scripts/How_to_use_buildtest/buildtest-help.txt

Building the Test
-----------------

Whenever you want to build a test, check your module file to find out what software package
exist on your system, then simply run the test as follows:

.. program-output:: cat scripts/How_to_use_buildtest/example-GCC-5.4.0-2.27.txt

For instance if you want to build tests for OpenMPI/2.0.0 and you specified the GCC/5.4.0-2.25
instead of GCC/5.4.0-2.27 as the toolchain, buildtest will automatically stop and report an error.
following.

.. program-output:: cat scripts/How_to_use_buildtest/fail_toolchain.txt


Launching Testing 
-----------------
buildtest will setup your environment with CTEST so you can build from out-of-source directory.
Create a new directory for instance **build**, then do the following


.. program-output:: cat scripts/How_to_use_buildtest/cmake-build.txt

.. program-output:: cat scripts/How_to_use_buildtest/test-GCC-5.4.0-2.27.txt

You can launch an interactive session to run the test. This can be done by running the following.


.. code::

   buildtest --runtest

Follow instruction in the menu to run the test.


Afterward run ``ctest .`` to run all the tests


.. program-output:: cat scripts/How_to_use_buildtest/run-GCC-5.4.0-2.27.txt

buildtest has an interactive session to run the test. This can be done by running

buildtest can generate tests for system packages using the flag **--system**. 
Currently, system package test only perform binary test. This means you need to 
find the binaries associated with the package and add the executable and any 
parameters in command.yaml.

This file will be $BUILDTEST_SOURCEDIR/system/$pkg/command.yaml where $pkg is 
name of system package. At this moment, buildtest is using Redhat package 
naming convention.


.. code::

   buildtest --runtest

This will result in a menu driven promp to navigate to the test.

.. program-output:: cat scripts/How_to_use_buildtest/runtest.txt

System Package Test
-------------------

buildtest can generate tests for system packages using the flag **--system**. 
Currently, system package test only perform binary test. This means you need to 
find the binaries associated with the package and add the executable and any 
parameters in command.yaml.

This file will be $BUILDTEST_SOURCEDIR/system/$pkg/command.yaml where $pkg is 
name of system package. At this moment, buildtest is using Redhat package 
naming convention.


.. program-output:: cat scripts/How_to_use_buildtest/systempkg_gcc-c++.txt


To run all system package test do the following

.. code::

   [siddis14@amrndhl1295 buildtest-framework]$  buildtest --system all


Log files
---------

Log files are stored in $BUILDTEST_ROOT/log. Flags for building tests ebapps (**-s**) and system package (**--system**) will 
create log files in $BUILDTEST_ROOT/log/ with directories **[system | ebapps]**. 

For instance a GCC/5.4.0-2.27 build will be stored in **$BUILDTEST_ROOT/log/GCC/5.4.0-2.27/dummy/dummy/buildtest_HH_MM_DD_MM_YYYY.log**

 
