.. _ruby_package_testing:

Building Tests for Ruby packages (``_buildtest --ruby-package <RUBY-PACKAGE>``)
===============================================================================

buildtest comes with option to build test for ruby packages to verify ruby packages
are working as expected. The ruby tests are coming from the repository
https://github.com/HPC-buildtest/Ruby-buildtest-config

In buildtest this repository is defined by variable ``BUILDTEST_RUBY_REPO`` that
can be tweaked by environment variable or configuration file (``config.yaml``)

buildtest supports tab completion for option ``--ruby-package`` which will show
a list of ruby packages available for testing.

To illustrate the tab completion feature see command below

.. code::

    [siddis14@prometheus buildtest-framework]$ _buildtest --ruby-package
    addressable  bigdecimal



To build ruby package test you must specify a ``ruby`` module. buildtest will
generate the binarytest along with any test from ruby package specified by
option ``--ruby-package``.

.. code::

    [siddis14@prometheus buildtest-framework]$ _buildtest -s Ruby/2.5.0-intel-2018a --ruby-package addressable

    Detecting Software:  Ruby/2.5.0-intel-2018a
    --------------------------------------------
    [STAGE 1]: Building Binary Tests
    --------------------------------------------
    Detecting Test Type: Software
    Processing Binary YAML configuration:  /home/siddis14/github/buildtest-configs/buildtest/ebapps/ruby/2.5.0/command.yaml

    Generating 16 binary tests
    Binary Tests are written in /tmp/buildtest-tests/ebapp/Ruby/2.5.0-intel-2018a/
    Generating  1 tests for  addressable
    Writing Log file:  /tmp/buildtest/Ruby/2.5.0-intel-2018a/buildtest_10_40_07_08_2018.log

This option is compatible with ``--shell`` and ``--job-template`` if you want to build
tests with different shell or create job scripts
