.. _Shell:

Buildtest supports different shell types
========================================


.. contents::
   :backlinks: none


Currently, buildtest supports the following shell types

- sh (default)
- bash
- csh

To create tests for different shell types use ``buildtest --shell <shell-type>``.
You may set the environment variable ``BUILDTEST_SHELL`` or set this in your
``config.yaml``


Let's build test for ``GCCcore/6.4.0`` with ``csh`` support


.. program-output:: cat scripts/Shell/GCC-6.4.0-2.28_csh.txt

Now let's check the test files

.. program-output:: cat scripts/Shell/GCC-6.4.0-2.28_csh_listing.txt


Let's rerun this with bash: ``buildtest -s GCCcore/6.4.0 --shell bash``


.. program-output:: cat scripts/Shell/GCC-6.4.0-2.28_bash.txt

You will notice the test scripts for ``csh`` and ``bash`` are indicated with shell extension to avoid name conflict. Let's take a look
at the ``CMakeList.txt`` file which contains the test parameter required to run tests via ``ctest``

.. program-output:: cat scripts/Shell/GCC-6.4.0-2.28_bash_listing.txt


You will notice the same tests are written with different shell extension. buildtest
will automatically delete the directory before running the test to ensure their is no
corruption in cmake configuration (i.e CMakeList.txt).

Everytime a test is created it is added in CMakeList.txt if you check the file you will
notice the extension is also configured in CMakeList.txt

.. program-output:: cat scripts/Shell/cmakelist_dump.txt

Configuring Environment Variable for different shells
-----------------------------------------------------

Let's dive deeper into a OpenMP helloworld example that changes its test output
according to different shells. For instance, we have the following yaml file that
will build OpenMP hello world program using multi-threading.

.. code::

    name: omp_hello.f
    source:  omp_hello.f
    buildopts: -O2 -fopenmp
    envvars:
            OMP_NUM_THREADS : 2

You will notice the key ``envvars`` will declare the environment variable according to the shell
used for generating the test. For ``bash`` and ``sh`` the keyword ``export`` is used whereas for ``csh``
the keyword is ``setenv``

If you run ``buildtest -s GCC/6.4.0-2.28 --shell bash`` to build the following test and look at generated test ``omp_hello_f.bash`` you
will see the environment variable is set using keyword ``export``

.. code::

    (buildtest) [siddis14@amrndhl1157 buildtest-framework]$ cat /tmp/buildtest-tests/ebapp/GCC/6.4.0-2.28/omp_hello.f.bash
    #!/bin/bash
    module purge
    module load GCC/6.4.0-2.28
    export OMP_NUM_THREADS=2
    gfortran -o omp_hello.f.exe /lustre/workspace/home/siddis14/buildtest-configs/ebapps/gcc/code/omp_hello.f -O2 -fopenmp
    ./omp_hello.f.exe(buildtest)

If you compare this with ``csh`` test script for ``omp_hello_f``  the only difference will be the lines responsible for setting environment
variable ``OMP_NUM_THREADS``

.. code::

    (buildtest) [siddis14@amrndhl1157 buildtest-framework]$ cat /tmp/buildtest-tests/ebapp/GCC/6.4.0-2.28/omp_hello.f.csh
    #!/bin/csh
    module purge
    module load GCC/6.4.0-2.28
    setenv OMP_NUM_THREADS 2
    gfortran -o omp_hello.f.exe /lustre/workspace/home/siddis14/buildtest-configs/ebapps/gcc/code/omp_hello.f -O2 -fopenmp


.. Note:: Notice that ``envvars`` doesn't specify whether to use **export** or **setenv** but rather
    keeps configuration generic and buildtest will figure out what keyword to append in front depending
    on the shell type.
