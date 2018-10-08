.. _Run_Subcommand:

Running Test with buildtest (``_buildtest run``)
=================================================


.. program-output:: cat scripts/Run_Subcommand/help.txt

Interactive Testing (``_buildtest run --interactive``)
----------------------------------------------------------

buildtest comes with a menu driven test that can be used
as an alternate method to ``ctest``. Just run ``_buildtest run --interactive``
after you created a few tests and follow the prompt to navigate to
the appropriate test

.. program-output:: cat scripts/How_to_use_buildtest/runtest.txt


Running Individual Tests (``_buildtest run --testname``)
----------------------------------------------------------


Run an Application Test Suite (``_buildtest run --app``)
-----------------------------------------------------------

buildtest can run test written in ``$BUILDTEST_TESTDIR`` for a particular application
specified by option ``--app``. The choice field for this option is populated based
on directories found in ``$BUILDTEST_TESTDIR`` which were created by subsequent runs
of ``_buildtest build -s <application>``.

::

    (buildtest) [siddis14@adwnode11 buildtest-framework]$ ./_buildtest run --app
    GCC/6.4.0-2.28             GCCcore/6.4.0              Perl/5.26.0-GCCcore-6.4.0


Shown below is an output of ``_buildtest run --app GCCcore/6.4.0`` which attempts
to run all tests for application ``GCCcore/6.4.0``

.. program-output:: head -n 25 scripts/Run_Subcommand/app_GCCcore.txt


Run a System Package Test Suite (``_buildtest run --systempkg``)
------------------------------------------------------------------

Similarly, ``buildtest run --systempkg`` is used to run test suite for system packages
that were built by option ``_buildtest build --system <package>``

Shown below is an output of ``_buildtest run --systempkg gcc``

.. program-output:: head -n 25 scripts/Run_Subcommand/systempkg_gcc.txt
