.. _Job_Template:

Job Template
============



.. contents::
      :backlinks: none


LSF Job template
-----------------

buildtest provides a default job template for LSF to generate test scripts for LSF. This template is for creating LSF job submission scripts that can be run 
via ``bsub``. The templates can be found at ``$BUILDTEST_ROOT/template/``

.. program-output:: cat scripts/Job_Template/template.txt

Feel free to change or bring or specify your own job template. buildtest will
use job template and create job script for each test script with the same template 
configuration, this may work for binary tests where job configuration is not 
important. However, this may not work well for parallel jobs (OpenMP, MPI) where
further configuration is needed

Generate Job scripts via buildtest
----------------------------------

.. program-output:: cat scripts/Job_Template/template_example.txt


buildtest will generate job scripts with **.lsf** extension in the same 
directory as the test script.

Let's take a look at the LSF test script


.. program-output:: cat scripts/Job_Template/firefox_jobscript.txt


For instance, if you build GCC with job template, you will get a job template 
for each script.

.. code:: 

   buildtest -s GCC/5.4.0-2.27 --job-template template/job.lsf

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ ls /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/*.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/arglist.c.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/cpp_--version.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/c++_--version.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/gcc-ar_--version.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/gcc-nm_--version.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/gcc-ranlib_--version.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/gcc_--version.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/gcov-tool_--version.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/gcov_--version.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/gfortran_--version.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/g++_--version.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/hello.c.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/hello.cpp.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/hello.f.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_dotprod_openmp.c.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_dotprod_openmp.f.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_dotprod_serial.c.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_dotprod_serial.f.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_getEnvInfo.c.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_getEnvInfo.f.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_hello.c_nthread_5.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_hello.f.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_mm.c_nthread_2.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_mm.f.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_orphan.c.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_orphan.f.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_reduction.c.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_reduction.f.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_workshare1.c.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_workshare1.f.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_workshare2.c.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/GCC/5.4.0-2.27/omp_workshare2.f.lsf


Job Template with --testset
-----------------------------

Job templates work with --testset as well and creates job scripts for each package test.

To demonstrate this example we run job template with Perl.

.. code::

   buildtest -s Perl/5.22.1 -t foss/.2016.03 --testset Perl --job-template template/job.lsf

After running this, we see the LSF job scripts have been created.

.. code:: shell

   [siddis14@amrndhl1157 buildtest-framework]$ ls -l /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03
   total 36
   drwxrwxr-x 2 siddis14 amer 4096 Jan  9 11:19 Algorithm
   drwxrwxr-x 2 siddis14 amer 4096 Jan  9 11:19 AnyData
   drwxrwxr-x 2 siddis14 amer 4096 Jan  9 11:19 AppConfig
   drwxrwxr-x 2 siddis14 amer 4096 Jan  9 11:19 Authen
   -rw-rw-r-- 1 siddis14 amer  359 Jan  9 11:19 CMakeLists.txt
   -rw-rw-r-- 1 siddis14 amer  215 Jan  9 11:19 hello.pl.lsf
   -rw-rw-r-- 1 siddis14 amer  173 Jan  9 11:19 hello.pl.sh
   -rw-rw-r-- 1 siddis14 amer  122 Jan  9 11:19 perl_-v.lsf
   -rw-rw-r-- 1 siddis14 amer   80 Jan  9 11:19 perl_-v.sh

Furthermore, each subdirectory that consist of Perl modules has an associated job
script to the test script.

.. code:: shell

   [siddis14@amrndhl1157 buildtest-framework]$ find /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03 -name *.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/Algorithm/diff.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/perl_-v.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/AnyData/AnyData.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/Authen/SASL.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/AppConfig/Args.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/AppConfig/State.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/AppConfig/File.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/AppConfig/Std.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/AppConfig/GetOpt.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/AppConfig/Sys.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/AppConfig/AppConfig.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/AppConfig/CGI.lsf
   /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/Perl/5.22.1/foss/.2016.03/hello.pl.lsf

