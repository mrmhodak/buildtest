.. _Job_Template:

Job Template (``buildtest --job-template <template>``)
======================================================



.. contents::
      :backlinks: none


LSF Job template
-----------------

buildtest provides a default job template for LSF to generate test scripts for LSF. This template is for creating LSF job submission scripts that can be run 
via ``bsub``. The templates can be found at ``$BUILDTEST_ROOT/template/``

.. program-output:: cat scripts/Job_Template/job.lsf

Feel free to change or bring or specify your own job template. buildtest will
use job template and create job script for each test script with the same template 
configuration, this may work for binary tests where job configuration is not 
important. However, this may not work well for parallel jobs (OpenMP, MPI) where
further configuration is needed

Generate Job scripts via buildtest
----------------------------------

buildtest can automatically generate job scripts with a template job script specified
by ``--job-template`` option or with variable ``BUILDTEST_JOB_TEMPLATE``

Let's run the following ``buildtest --system firefox --job-template template/job.lsf --enable-job`` to
build LSF job scripts 


.. program-output:: cat scripts/Job_Template/firefox_jobscript.txt


Job templates work with option ``--system`` and ``--software``. Let's try another example 
building job scripts with a software package ``GCC/6.4.0-2.28`` with lsf job template


``buildtest -s GCC/6.4.0-2.28 --job-template template/job.lsf --enable-job``

.. program-output:: cat scripts/Job_Template/GCC-6.4.0-2.28_lsf_job.txt



Job Template with ``--testset``
-------------------------------

Job templates work with ``--testset`` option as well and creates job scripts for each package test.

To demonstrate this example we run job template with Perl.

.. code::

   buildtest -s Perl/5.22.1 -t foss/.2016.03 --testset Perl --job-template template/job.lsf --enable-job

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

