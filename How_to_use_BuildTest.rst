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



