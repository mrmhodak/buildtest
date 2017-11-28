.. _Generate_yaml_from_buildtest:

Generate YAML from buildtest
============================

buildtest can be used for writing YAML files for binary testing (**command.yaml**). This feature was added to help facilitate binary
testing for Easybuild and System Packages. 

For system packages, typically you need to find all the binaries provided by the system package. Let's assume for our discussion we are
in Redhat, you would need to get output of ``rpm -ql <package>`` and go through each file and determine what is a binary. Once you get the 
binary run the binary with any options like ``--help``, ``-h``, ``--version`` or ``-V`` for a help or version check. This process can be tedious
so buildtest has this implemented in the framework.

Since there is no universal test case for evaluating each binary we leave it up to the users to determine how they want to perform binary test.

.. note:: The user need needs to verify the YAML configuration after buidltest creats YAML file

Binary Test for System package
------------------------------

To create a binary test for a system package, first check $BUILDTEST_SOURCEDIR/systempkg to see which system package are already provided. If there is 
no directory then it makes sense to create a the system package binary test using ``buildtest --sysyaml``

For this example we will generate the YAML configuration for  **firefox** package. 

.. program-output:: cat scripts/Generate_yaml_from_buildtest/firefox_example.txt

buildtest will try to check for executable files in standard Linux path that include the following

 - /usr/bin
 - /bin
 - /sbin
 - /usr/sbin
 - /usr/local/bin
 - /usr/local/sbin 
 
Looking at the content of yaml file we see the following

.. program-output:: cat scripts/Generate_yaml_from_buildtest/firefox_command.yaml


When you run **firefox** in your shell, this will launch the browser, this is not good for testing purpose since we will be running these tests in batch mode. So specify a 
command that is going to terminate by running something like ``firefox --help``. This same command will be injected in your test script. 

.. note:: Each item in **binaries** key will generate a separate test script and a new entry in CMakeList.txt

In this example we modified firefox YAML configuration to use ``--help`` with firefox to display the help command to verify the firefox binary is working

.. program-output:: cat scripts/Generate_yaml_from_buildtest/firefox-system-test.txt

Let's confirm this test by running it.

.. program-output:: cat scripts/Generate_yaml_from_buildtest/_usr_bin_firefox_--help.sh.run


Once you have confirmed the test, you can share your YAML configuration by creating a Pull Request for the appropriate file.




        


