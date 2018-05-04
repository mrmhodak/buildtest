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


Let's build test for ``GCC/6.4.0-2.28`` by running the following ``buildtest -s GCC/6.4.0-2.28 --shell csh``


.. program-output:: cat scripts/Shell/GCC-6.4.0-2.28_csh.txt

Now let's check the files 

.. program-output:: cat scripts/Shell/GCC-6.4.0-2.28_csh_listing.txt


Let's rerun this with bash: ``buildtest -s GCC/6.4.0-2.28 --shell bash``


.. program-output:: cat scripts/Shell/GCC-6.4.0-2.28_bash.txt


.. program-output:: cat scripts/Shell/GCC-6.4.0-2.28_bash_listing.txt


You will notice the same tests are written with different shell extension. buildtest
will automatically delete the directory before running the test to ensure their is no
corruption in cmake configuration (i.e CMakeList.txt).

Everytime a test is created it is added in CMakeList.txt if you check the file you will
notice the extension is also configured in CMakeList.txt

.. program-output:: cat scripts/Shell/cmakelist_dump.txt

Let's dive deeper into a OpenMP helloworld example that changes its test output
according to different shells.

.. program-output:: cat scripts/Shell/openmp_hello_bash.txt


In bash and sh, the keyword ``export`` is used for setting environment variables, in
this case to set OpenMP threads we set OMP_NUM_THREADS before running program. 

In csh, notice the same test is created but instead of using ``export`` we are using
``setenv`` for setting the environment variable, because that is how we declare environment 
variables in csh. Also notice the magic string (first line) is set to the appropriate
shell

.. program-output:: cat scripts/Shell/openmp_hello_csh.txt

The yaml configuration used for creating a hello world OpenMP version is the following

.. program-output:: cat scripts/Shell/omp_hello.f.yaml.txt


Notice that ``envvar`` doesn't specify whether to use **export** or **setenv** but rather
keeps it generic and buildtest will figure out what keyword to append in front to comply
with the shell type.



