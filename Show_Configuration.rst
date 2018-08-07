.. _Show_Configuration:


Show Configuration (``_buildtest --show``)
=============================================

buildtest can display it's configuration by running ``_buildtest --show``. The
configuration can be changed by the following.

 1. Command Line
 2. Environment Variable (``BUILDTEST_``)
 3. Configuration File (``config.yaml``)

buildtest will read configuration from file ``config.yaml`` and override any configuration
by environment variables that start with ``BUILDTEST_``. The command line may
override the environment variables at runtime.

Shown below is a sample configuration from buildtest.


.. code::

    [siddis14@prometheus buildtest-framework]$ _buildtest --show

     buildtest configuration summary
     (C): Configuration File,  (E): Environment Variable

    BUILDTEST_ROOT                                     (E): /home/siddis14/github/buildtest-framework
    BUILDTEST_CLEAN_BUILD                              (C) = False
    BUILDTEST_CONFIGS_REPO                             (C) = /home/siddis14/github/buildtest-configs
    BUILDTEST_CONFIGS_REPO_SOFTWARE                    (C) = /home/siddis14/github/buildtest-configs/buildtest/ebapps
    BUILDTEST_CONFIGS_REPO_SYSTEM                      (C) = /home/siddis14/github/buildtest-configs/buildtest/system
    BUILDTEST_ENABLE_JOB                               (C) = False
    BUILDTEST_IGNORE_EASYBUILD                         (C) = False
    BUILDTEST_JOB_TEMPLATE                             (E) = /home/siddis14/github/buildtest-framework/template/job.slurm
    BUILDTEST_LOGDIR                                   (C) = /tmp/buildtest
    BUILDTEST_MODULE_NAMING_SCHEME                     (C) = FNS
    BUILDTEST_MODULE_ROOT                              (C) = /clust/app/easybuild/2018/Broadwell/redhat/7.3/modules/all
    BUILDTEST_PERL_REPO                                (C) = /home/siddis14/github/Perl-buildtest-config
    BUILDTEST_PERL_TESTDIR                             (C) = /home/siddis14/github/Perl-buildtest-config/buildtest/perl/code
    BUILDTEST_PYTHON_REPO                              (C) = /home/siddis14/github/Python-buildtest-config
    BUILDTEST_PYTHON_TESTDIR                           (C) = /home/siddis14/github/Python-buildtest-config/buildtest/python/code
    BUILDTEST_RUBY_REPO                                (C) = /home/siddis14/github/Ruby-buildtest-config
    BUILDTEST_RUBY_TESTDIR                             (C) = /home/siddis14/github/Ruby-buildtest-config/buildtest/ruby/code
    BUILDTEST_R_REPO                                   (C) = /home/siddis14/github/R-buildtest-config
    BUILDTEST_R_TESTDIR                                (C) = /home/siddis14/github/R-buildtest-config/buildtest/R/code
    BUILDTEST_SHELL                                    (C) = sh
    BUILDTEST_TCL_REPO                                 (C) = /home/siddis14/github/Tcl-buildtest-config
    BUILDTEST_TESTDIR                                  (C) = /tmp/buildtest-tests




``_buildtest --show`` will update the output as you set any BUILDTEST environment
variables.

For instance, if you want to customize the buildtest log and test directory to another path, you may configure via environment
variable. buildtest will report which values are overriden by environment variable with a notation **(E)**

.. Note:: if you plan to customize your buildtest configuration with Configuration File and Environment Variable, always check your shell
   environment first to avoid having values overriden unintentionally

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ export BUILDTEST_LOGDIR=/tmp
   [siddis14@amrndhl1157 buildtest-framework]$ export BUILDTEST_TESTDIR=$HOME
   (buildtest) [siddis14@amrndhl1157 buildtest-framework]$ _buildtest --show

            buildtest configuration summary
            (C): Configuration File,  (E): Environment Variable

   BUILDTEST_ROOT                                     (E): /home/siddis14/github/buildtest-framework
   BUILDTEST_CLEAN_BUILD                              (C) = False
   BUILDTEST_CONFIGS_REPO                             (C) = /home/siddis14/github/buildtest-configs
   BUILDTEST_CONFIGS_REPO_SOFTWARE                    (C) = /home/siddis14/github/buildtest-configs/buildtest/ebapps
   BUILDTEST_CONFIGS_REPO_SYSTEM                      (C) = /home/siddis14/github/buildtest-configs/buildtest/system
   BUILDTEST_ENABLE_JOB                               (C) = False
   BUILDTEST_IGNORE_EASYBUILD                         (C) = False
   BUILDTEST_JOB_TEMPLATE                             (E) = /home/siddis14/github/buildtest-framework/template/job.slurm
   BUILDTEST_LOGDIR                                   (E) = /tmp
   BUILDTEST_MODULE_NAMING_SCHEME                     (C) = FNS
   BUILDTEST_MODULE_ROOT                              (C) = /clust/app/easybuild/2018/Broadwell/redhat/7.3/modules/all
   BUILDTEST_PERL_REPO                                (C) = /home/siddis14/github/Perl-buildtest-config
   BUILDTEST_PERL_TESTDIR                             (C) = /home/siddis14/github/Perl-buildtest-config/buildtest/perl/code
   BUILDTEST_PYTHON_REPO                              (C) = /home/siddis14/github/Python-buildtest-config
   BUILDTEST_PYTHON_TESTDIR                           (C) = /home/siddis14/github/Python-buildtest-config/buildtest/python/code
   BUILDTEST_RUBY_REPO                                (C) = /home/siddis14/github/Ruby-buildtest-config
   BUILDTEST_RUBY_TESTDIR                             (C) = /home/siddis14/github/Ruby-buildtest-config/buildtest/ruby/code
   BUILDTEST_R_REPO                                   (C) = /home/siddis14/github/R-buildtest-config
   BUILDTEST_R_TESTDIR                                (C) = /home/siddis14/github/R-buildtest-config/buildtest/R/code
   BUILDTEST_SHELL                                    (C) = sh
   BUILDTEST_TCL_REPO                                 (C) = /home/siddis14/github/Tcl-buildtest-config
   BUILDTEST_TESTDIR                                  (E) = /home/siddis14

Sanity Checks
-------------

buildtest conducts a few sanity checks to ensure user don't pass invalid argument to buildtest variables via Configuration File
or Environment Variable.


buildtest will check for valid directory paths for buildtest repository. For instance
if you specify ``BUILDTEST_CONFIGS_REPO`` to an invalid  path you will get the following
message


.. code::

    [siddis14@prometheus buildtest-framework]$ _buildtest --show
    ERROR:           BUILDTEST_CONFIGS_REPO:  /tmp/buildtest-configs  does not exist
    Please fix your BUILDTEST configuration
