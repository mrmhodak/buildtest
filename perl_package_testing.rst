.. _perl_package_testing:

Building Tests for Perl packages (``_buildtest --perl-package <PERL-PACKAGE>``)
===============================================================================

buildtest comes with option to build test for perl packages to verify perl packages
are working as expected. The Perl tests are coming from the repository
https://github.com/HPC-buildtest/Perl-buildtest-config

In buildtest this repository is defined by variable ``BUILDTEST_PERL_REPO`` that
can be tweaked by environment variable or configuration file (``config.yaml``)

buildtest supports tab completion for option ``--perl-package`` which will show
a list of perl packages available for testing.

To illustrate the tab completion feature see command below

.. code::

    siddis14@prometheus buildtest-framework]$ _buildtest --perl-package
    Algorithm  AnyData    AppConfig  Authen


To build perl package test you must specify a ``Perl`` module. buildtest will
generate the binarytest along with any test from perl package specified by
option ``--perl-package``.

.. code::

    [siddis14@prometheus buildtest-framework]$  _buildtest -s Perl/5.26.0-GCCcore-6.4.0 --perl-package AnyData
    Detecting Software:  Perl/5.26.0-GCCcore-6.4.0
    --------------------------------------------
    [STAGE 2]: Building Source Tests
    --------------------------------------------
    Processing all YAML files in directory: /home/siddis14/github/buildtest-configs/buildtest/ebapps/perl/config
    Generating 1 Source Tests and writing at  /tmp/buildtest-tests/ebapp/Perl/5.26.0-GCCcore-6.4.0/
    Generating  1 tests for  AnyData
    Writing Log file:  /tmp/buildtest/Perl/5.26.0-GCCcore-6.4.0/buildtest_19_38_06_08_2018.log

Perl Package Check Validation
-------------------------------

buildtest will check if perl package exists for particular perl module specified
in ``--software`` to ensure tests are not created that are bound to fail due to
missing package.

To illustrate see the following example where we try building test for perl package
``Algorithm``

.. code::

    [siddis14@prometheus buildtest-framework]$  _buildtest -s Perl/5.26.0-GCCcore-6.4.0 --perl-package Algorithm
    Detecting Software:  Perl/5.26.0-GCCcore-6.4.0
    --------------------------------------------
    [STAGE 2]: Building Source Tests
    --------------------------------------------
    Processing all YAML files in directory: /home/siddis14/github/buildtest-configs/buildtest/ebapps/perl/config
    Generating 1 Source Tests and writing at  /tmp/buildtest-tests/ebapp/Perl/5.26.0-GCCcore-6.4.0/
    Algorithm is not installed in software Perl/5.26.0-GCCcore-6.4.0



This option is compatible with ``--shell`` and ``--job-template`` if you want to build
tests with different shell or create job scripts
