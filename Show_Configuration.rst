.. _Show_Configuration:


Show Configuration (``buildtest --show``)
=========================================

buildtest can display it's configuration by running ``buildtest --show``. The
configuration can be changed by the following.

 1. Command Line
 2. Environment Variable (``BUILDTEST_``)
 3. Configuration File (``config.yaml``)

buildtest will read configuration from file ``config.yaml`` and override any configuration
by environment variables that start with ``BUILDTEST_``. The command line may
override the environment variables at runtime.

Shown below is a sample configuration from buildtest.


.. code::

    (buildtest) [siddis14@amrndhl1157 buildtest-framework]$ buildtest --show

         buildtest configuration summary
         (C): Configuration File,  (E): Environment Variable

    BUILDTEST_ROOT                                     (E): /home/siddis14/github/buildtest-framework
    BUILDTEST_CLEAN_BUILD                              (C) = False
    BUILDTEST_CONFIGS_REPO                             (C) = /lustre/workspace/home/siddis14/buildtest-configs
    BUILDTEST_ENABLE_JOB                               (C) = False
    BUILDTEST_IGNORE_EASYBUILD                         (C) = False
    BUILDTEST_JOB_TEMPLATE                             (C) = template/job.slurm
    BUILDTEST_LOGDIR                                   (C) = /tmp/buildtest
    BUILDTEST_MODULE_NAMING_SCHEME                     (C) = HMNS
    BUILDTEST_MODULE_ROOT                              (C) = /nfs/grid/software/easybuild/2018/IvyBridge/redhat/7.3/all
    BUILDTEST_PERL_REPO                                (C) = /lustre/workspace/home/siddis14/Perl-buildtest-config
    BUILDTEST_PYTHON_REPO                              (C) = /lustre/workspace/home/siddis14/Python-buildtest-config
    BUILDTEST_RUBY_REPO                                (C) = /lustre/workspace/home/siddis14/Ruby-buildtest-config
    BUILDTEST_R_REPO                                   (C) = /lustre/workspace/home/siddis14/R-buildtest-config
    BUILDTEST_SHELL                                    (C) = sh
    BUILDTEST_TCL_REPO                                 (C) = /lustre/workspace/home/siddis14/Tcl-buildtest-config



``buildtest --show`` will update the output as you set any BUILDTEST environment
variables.

For instance, if you want to customize the buildtest log and test directory to another path, you may configure via environment
variable. buildtest will report which values are overriden by environment variable with a notation **(E)**

.. Note:: if you plan to customize your buildtest configuration with Configuration File and Environment Variable, always check your shell
   environment first to avoid having values overriden unintentionally

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ export BUILDTEST_LOGDIR=/tmp
   [siddis14@amrndhl1157 buildtest-framework]$ export BUILDTEST_TESTDIR=$HOME
   (buildtest) [siddis14@amrndhl1157 buildtest-framework]$ buildtest --show

              buildtest configuration summary
              (C): Configuration File,  (E): Environment Variable

     BUILDTEST_ROOT                                     (E): /home/siddis14/github/buildtest-framework
     BUILDTEST_CLEAN_BUILD                              (C) = False
     BUILDTEST_CONFIGS_REPO                             (C) = /lustre/workspace/home/siddis14/buildtest-configs
     BUILDTEST_ENABLE_JOB                               (C) = False
     BUILDTEST_IGNORE_EASYBUILD                         (C) = False
     BUILDTEST_JOB_TEMPLATE                             (C) = template/job.slurm
     BUILDTEST_LOGDIR                                   (E) = /tmp
     BUILDTEST_MODULE_NAMING_SCHEME                     (C) = HMNS
     BUILDTEST_MODULE_ROOT                              (C) = /nfs/grid/software/easybuild/2018/IvyBridge/redhat/7.3/all
     BUILDTEST_PERL_REPO                                (C) = /lustre/workspace/home/siddis14/Perl-buildtest-config
     BUILDTEST_PYTHON_REPO                              (C) = /lustre/workspace/home/siddis14/Python-buildtest-config
     BUILDTEST_RUBY_REPO                                (C) = /lustre/workspace/home/siddis14/Ruby-buildtest-config
     BUILDTEST_R_REPO                                   (C) = /lustre/workspace/home/siddis14/R-buildtest-config
     BUILDTEST_SHELL                                    (C) = sh
     BUILDTEST_TCL_REPO                                 (C) = /lustre/workspace/home/siddis14/Tcl-buildtest-config
     BUILDTEST_TESTDIR                                  (E) = /home/siddis14

Sanity Checks
-------------

buildtest conducts a few sanity checks to ensure user don't pass invalid argument to buildtest variables via Configuration File
or Environment Variable.


buildtest will check for valid directory paths for buildtest repository. For instance
if you specify ``BUILDTEST_CONFIGS_REPO`` to an invalid  path you will get the following
message


.. code::

        [siddis14@amrndhl1157 buildtest-framework]$ export BUILDTEST_CONFIGS_REPO=/tmp/buildtest-configs
        [siddis14@amrndhl1157 buildtest-framework]$ buildtest --show
        ERROR:           BUILDTEST_CONFIGS_REPO:  /tmp/buildtest-configs  does not exist
        Please fix your BUILDTEST configuration
