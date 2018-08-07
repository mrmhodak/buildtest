.. _Generate_yaml_from_buildtest:

Generate test configuration for binary testing with buildtest
=============================================================

buildtest can be used for writing YAML files for binary testing
(``command.yaml``). This feature was added to streamline binary testing for
Software and System Packages.

Binary Test for Software package(``_buildtest --ebyaml``)
----------------------------------------------------------

In order to test binaries for software packages in HPC environment, buildtest
will assume there is a modulefile present and accessible via ``module`` command.
This implies the module tree is defined in ``MODULEPATH`` and ``BUILDTEST_MODULE_ROOT``.

When buildtest takes argument ``_buildtest --ebyaml <module>`` it will run the
following command

.. code::

    module show <module>

buildtest will use the output of the above command to figure out root of the
software directory, in particular it searches for ``prepend_path("PATH"``
string to figure out the directory where binaries will reside. buildtest will
search for all files in all directories defined by ``$PATH`` in module file

buildtest will only add files, not directories, and only add files with unique
sha256 sum to avoid adding unncessary commands. buildtest will ignore symlinks
as well.

To demonstrate an example lets see the following example

``_buildtest --ebyaml GCCcore/6.4.0``

buildtest will search for $PATH in module file, lets assume the content of
module file is the following


.. code::

    (buildtest) [siddis14@amrndhl1157 buildtest-framework]$ ml show GCCcore/6.4.0
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
       /nfs/grid/software/easybuild/2018/IvyBridge/redhat/7.3/all/GCCcore/6.4.0.lua:
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    help([[
    Description
    ===========
    The GNU Compiler Collection includes front ends for C, C++, Objective-C,
     Fortran, Java, and Ada, as well as libraries for these languages (libstdc++,
     libgcj,...).  [NOTE: This module does not include Objective-C, Java or Ada]


    More information
    ================
     - Homepage: http://gcc.gnu.org/
    ]])
    whatis("Description:
     The GNU Compiler Collection includes front ends for C, C++, Objective-C,
     Fortran, Java, and Ada, as well as libraries for these languages (libstdc++,
     libgcj,...).  [NOTE: This module does not include Objective-C, Java or Ada]
    ")
    whatis("Homepage: http://gcc.gnu.org/")
    conflict("GCCcore")
    prepend_path("CPATH","/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0/include")
    prepend_path("LD_LIBRARY_PATH","/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0/lib")
    prepend_path("LD_LIBRARY_PATH","/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0/lib64")
    prepend_path("LD_LIBRARY_PATH","/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0/lib/gcc/x86_64-pc-linux-gnu/6.4.0")
    prepend_path("LIBRARY_PATH","/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0/lib")
    prepend_path("LIBRARY_PATH","/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0/lib64")
    prepend_path("MANPATH","/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0/share/man")
    prepend_path("PATH","/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0/bin")
    setenv("EBROOTGCCCORE","/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0")
    setenv("EBVERSIONGCCCORE","6.4.0")
    setenv("EBDEVELGCCCORE","/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0/easybuild/GCCcore-6.4.0-easybuild-devel")


The ``$PATH`` is defined as ``/nfs/grid/software/easybuild/IvyBridge/redhat/7.3/software/GCCcore/6.4.0/bin``, lets look in this directory and we see the following

.. code::


    total 84665
    -rwxr-xr-x 4 siddis14 hpcswbuild 4579728 Mar 12 11:23 c++
    lrwxrwxrwx 1 siddis14 hpcswbuild       3 Mar 12 11:24 cc -> gcc
    -rwxr-xr-x 1 siddis14 hpcswbuild 4575808 Mar 12 11:23 cpp
    lrwxrwxrwx 1 siddis14 hpcswbuild       8 Mar 12 11:24 f77 -> gfortran
    lrwxrwxrwx 1 siddis14 hpcswbuild       8 Mar 12 11:24 f95 -> gfortran
    -rwxr-xr-x 4 siddis14 hpcswbuild 4579728 Mar 12 11:23 g++
    -rwxr-xr-x 3 siddis14 hpcswbuild 4572584 Mar 12 11:23 gcc
    -rwxr-xr-x 2 siddis14 hpcswbuild  148704 Mar 12 11:23 gcc-ar
    -rwxr-xr-x 2 siddis14 hpcswbuild  148664 Mar 12 11:23 gcc-nm
    -rwxr-xr-x 2 siddis14 hpcswbuild  148672 Mar 12 11:23 gcc-ranlib
    -rwxr-xr-x 1 siddis14 hpcswbuild 3149272 Mar 12 11:23 gcov
    -rwxr-xr-x 1 siddis14 hpcswbuild 2877592 Mar 12 11:23 gcov-dump
    -rwxr-xr-x 1 siddis14 hpcswbuild 3104832 Mar 12 11:23 gcov-tool
    -rwxr-xr-x 2 siddis14 hpcswbuild 4580352 Mar 12 11:23 gfortran
    -rwxr-xr-x 4 siddis14 hpcswbuild 4579728 Mar 12 11:23 x86_64-pc-linux-gnu-c++
    -rwxr-xr-x 4 siddis14 hpcswbuild 4579728 Mar 12 11:23 x86_64-pc-linux-gnu-g++
    -rwxr-xr-x 3 siddis14 hpcswbuild 4572584 Mar 12 11:23 x86_64-pc-linux-gnu-gcc
    -rwxr-xr-x 3 siddis14 hpcswbuild 4572584 Mar 12 11:23 x86_64-pc-linux-gnu-gcc-6.4.0
    -rwxr-xr-x 2 siddis14 hpcswbuild  148704 Mar 12 11:23 x86_64-pc-linux-gnu-gcc-ar
    -rwxr-xr-x 2 siddis14 hpcswbuild  148664 Mar 12 11:23 x86_64-pc-linux-gnu-gcc-nm
    -rwxr-xr-x 2 siddis14 hpcswbuild  148672 Mar 12 11:23 x86_64-pc-linux-gnu-gcc-ranlib
    -rwxr-xr-x 2 siddis14 hpcswbuild 4580352 Mar 12 11:23 x86_64-pc-linux-gnu-gfortran

You will notice some files have same sha256 sum which may not be important for testing purpose.

.. code::

    (buildtest) [siddis14@amrndhl1157 bin]$ sha256sum x86_64-pc-linux-gnu-c++
    95e52799e1e4e766c98f3c64e3d13920375d694a546ff8884ed73f5188b62113  x86_64-pc-linux-gnu-c++
    (buildtest) [siddis14@amrndhl1157 bin]$ sha256sum c++
    95e52799e1e4e766c98f3c64e3d13920375d694a546ff8884ed73f5188b62113  c++

buildtest will write the content in ``command.yaml`` which must be checked for further modification

.. code::

    (buildtest) [siddis14@amrndhl1157 buildtest-framework]$ _buildtest --ebyaml GCCcore/6.4.0
    YAML file already exists, please check:  /lustre/workspace/home/siddis14/buildtest-configs/ebapps/gcccore/6.4.0/command.yaml
    (buildtest) [siddis14@amrndhl1157 buildtest-framework]$ buildtest --ebyaml GCCcore/6.4.0
    Please check YAML file /lustre/workspace/home/siddis14/buildtest-configs/ebapps/gcccore/6.4.0/command.yaml  and fix test accordingly


If we look at the content we will see following binaries have been added

.. code::

    binaries:
    - x86_64-pc-linux-gnu-gfortran
    - gcc-nm
    - x86_64-pc-linux-gnu-g++
    - gcc
    - gcov-tool
    - x86_64-pc-linux-gnu-gcc-ranlib
    - gcc-ar
    - cpp
    - gcov
    - gcov-dump

The last step is to add any options (if applicable) required to run the binary command.


Binary Test for System package (``_buildtest --sysyaml``)
----------------------------------------------------------

For system packages, typically you need to find all the binaries provided by the
system package. Let's assume for our discussion we are in Redhat, you would need
to get output of ``rpm -ql <package>`` and go through each file and determine
what is a binary. Once you get the binary run the binary with any options like
``--help``, ``-h``, ``--version`` or ``-V`` for a help or version check. This
process can be tedious so buildtest has this implemented in the framework.

Since there is no universal test case for evaluating each binary we leave it up
to the users to determine how they want to perform binary test.

.. note:: The user needs to verify the YAML configuration after buidltest creates YAML file

To create a binary test for a system package, first check
``$BUILDTEST_CONFIGS_REPO/buildtest/system/<package>`` to see which system
package are already provided. If there is no directory then it makes sense to
create a the system package binary test using ``_buildtest --sysyaml``

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


When you run **firefox** in your shell, this will launch the browser, this is
not good for testing purpose since we will be running these tests in batch mode.
So specify a command that is going to terminate by running something like
``firefox --help``. This same command will be injected in your test script.

.. note:: Each item in **binaries** key will generate a separate test script and a new entry in CMakeList.txt

In this example we modified firefox YAML configuration to use ``--help`` with
firefox to display the help command to verify the firefox binary is working

.. program-output:: cat scripts/Generate_yaml_from_buildtest/firefox-system-test.txt

Let's confirm this test by running it.

.. program-output:: cat scripts/Generate_yaml_from_buildtest/_usr_bin_firefox_--help.sh.run


Once you have confirmed the test, you can share your YAML configuration by creating a Pull Request for the appropriate file.
