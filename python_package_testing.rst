.. _python_package_testing:

Building Tests for Python  Packages (``_buildtest --python-package <PYTHON-PACKAGE>``)
======================================================================================

buildtest comes with option to build test for python packages to verify python packages
are working as expected. The Python tests are coming from the repository
https://github.com/HPC-buildtest/Python-buildtest-config

In buildtest this repository is defined by variable ``BUILDTEST_PYTHON_REPO`` that
can be tweaked by environment variable or configuration file (``config.yaml``)

buildtest supports tab completion for option ``--python-package`` which will show
a list of python packages available for testing.

To illustrate the tab completion feature see command below

.. code::

    [siddis14@prometheus buildtest-framework]$ _buildtest --python-package
    anaconda-client  Babel            bitarray         cdecimal         cryptography     deap             mpi4py           nose             paramiko         pytz
    astriod          backports_abc    blist            chest            Cython           funcsigs         netaddr          numpy            paycheck         scipy
    astropy          beautifulsoup4   Bottleneck       colorama         dateutil         mock             netifaces        os               pyparsing        setuptools


To build python package test you must specify a ``Python`` module. buildtest will
generate the binarytest along with any test from python package specified by
option ``--python-package``.

.. code::

    [siddis14@prometheus buildtest-framework]$ _buildtest -s Python/2.7.14-intel-2018a --python-package dateutil
    Detecting Software:  Python/2.7.14-intel-2018a
    --------------------------------------------
    [STAGE 1]: Building Binary Tests
    --------------------------------------------
    Detecting Test Type: Software
    Processing Binary YAML configuration:  /home/siddis14/github/buildtest-configs/buildtest/ebapps/python/2.7.14/command.yaml

    Generating 6 binary tests
    Binary Tests are written in /tmp/buildtest-tests/ebapp/Python/2.7.14-intel-2018a/
    --------------------------------------------
    [STAGE 2]: Building Source Tests
    --------------------------------------------
    Processing all YAML files in directory: /home/siddis14/github/buildtest-configs/buildtest/ebapps/python/config
    Generating 4 Source Tests and writing at  /tmp/buildtest-tests/ebapp/Python/2.7.14-intel-2018a/
    Generating  1 tests for  dateutil
    Writing Log file:  /tmp/buildtest/Python/2.7.14-intel-2018a/buildtest_19_25_06_08_2018.log

Python Package Check Validation
-------------------------------

buildtest will check if python package exists for particular Python module specified
in ``--software`` to ensure tests are not created that are bound to fail due to
missing package.

To illustrate see the following example where we try building test for python package
``Bottleneck``

.. code::

    [siddis14@prometheus buildtest-framework]$ _buildtest -s Python/2.7.14-GCCcore-6.4.0-bare --python-package Bottleneck
    Detecting Software:  Python/2.7.14-GCCcore-6.4.0-bare
    --------------------------------------------
    [STAGE 1]: Building Binary Tests
    --------------------------------------------
    Detecting Test Type: Software
    Processing Binary YAML configuration:  /home/siddis14/github/buildtest-configs/buildtest/ebapps/python/2.7.14/command.yaml

    Generating 6 binary tests
    Binary Tests are written in /tmp/buildtest-tests/ebapp/Python/2.7.14-GCCcore-6.4.0-bare/
    --------------------------------------------
    [STAGE 2]: Building Source Tests
    --------------------------------------------
    Processing all YAML files in directory: /home/siddis14/github/buildtest-configs/buildtest/ebapps/python/config
    Generating 4 Source Tests and writing at  /tmp/buildtest-tests/ebapp/Python/2.7.14-GCCcore-6.4.0-bare/
    Bottleneck is not installed in software Python/2.7.14-GCCcore-6.4.0-bare


This option is compatible with ``--shell`` and ``--job-template`` if you want to build
tests with different shell or create job scripts
