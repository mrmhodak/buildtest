.. _module_load_test:

Testing Module Load for Module Tree (``buildtest --module-load-test``)
======================================================================

.. Note:: This is an experimental feature


buildtest provides feature to test ``module load`` functionality on all module files
in a module tree. This assumes you have the module tree in ``MODULEPATH`` in order 
for ``module`` command to work properly.

To use this feature specify the appropriate module tree for parameter ``BUILDTEST_MODULE_ROOT`` in
``config.yaml`` or via environment variable. To use this feature you need to use ``buildtest --module-load-test``

To demonstrate let's start off with an example where we test module load for a single module tree.

.. code::

   [siddis14@amrndhl1228 buildtest-framework]$ buildtest --show | grep BUILDTEST_MODULE_ROOT
   BUILDTEST_MODULE_ROOT                              (C) = /nfs/grid/software/RHEL7/non-easybuild/modules/all


Let's start the test

.. code::

   [siddis14@amrndhl1228 buildtest-framework]$ buildtest --module-load-test
   STATUS: PASSED - Testing module: VNL-ATK/2016.4
   STATUS: PASSED - Testing module: anaconda2/4.2.0-chemistry
   STATUS: PASSED - Testing module: anaconda3/4.2.0-chemistry
   STATUS: PASSED - Testing module: bcl2fastq2/v2.17.1.14
   STATUS: PASSED - Testing module: ccp4/7.0
   STATUS: PASSED - Testing module: ccp4/7.0-nightly
   STATUS: PASSED - Testing module: cellranger/1.2.1
   STATUS: PASSED - Testing module: gaussian/g16.a03.avx
   STATUS: PASSED - Testing module: gaussian/g16.a03.avx2
   STATUS: PASSED - Testing module: gaussian/g16.a03.legacy
   STATUS: PASSED - Testing module: gaussian/g16.a03.sse4
   STATUS: PASSED - Testing module: hmmer/3.1b2
   STATUS: PASSED - Testing module: materialstudios/2018
   STATUS: PASSED - Testing module: openeye/2017
   STATUS: PASSED - Testing module: phenix/dev2666
   STATUS: PASSED - Testing module: rosetta/3.7
   STATUS: PASSED - Testing module: turbomole/7.11
   STATUS: PASSED - Testing module: turbomole/7.12
   STATUS: PASSED - Testing module: xds/20161205


buildtest will attempt to load each module from module-tree individually, in case
of you have Hierarchical-Module-Naming-Scheme (HMNS) this may not work where some
modules depend on other modules to be loaded in advance.

You may specify multiple module trees in ``BUILDTEST_MODULE_ROOT`` for testing
``buildtest --module-load-test`` but you may run module conflicts if two or more trees
consist of same module file. In that case, you may be testing module file that may
be first in ``MODULEPATH``.

To use this feature properly, it is best to use this with one module tree at a time.
