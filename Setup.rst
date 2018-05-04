.. _Setup:

buildtest Setup
===============


.. contents::
   :backlinks: none


Requirements
------------

 - Linux OS (Redhat or Centos)
 - Python 2.6 or recent version of 2.x
 - argparse, PyYAML library
 - easyconfig repo
 - A module tool environment - Lmod or EnvironmentModules
 - CMake >= 2.8


Let's first get you setup with buildtest, so you can than start testing :)


Installing buildtest
--------------------

To get started just clone all the repos related to buildtest in your filesystem

.. program-output:: cat scripts/Setup/clonerepo.txt

Once you clone the repos you will want to edit your ``config.yaml`` file to specify
buildtest configuration



buildtest Configuration Variables
---------------------------------
          
There are a few buildtest variables that you should
be aware of when using buildtest. 


.. include:: Setup/buildtest-environment.txt

To get started run the following script  ``source setup.sh`` in your shell and edit
the file ``$BUILDTEST_ROOT/config.yaml`` accordingly.  

The ``setup.sh`` will define variable ``BUILDTEST_ROOT`` that can be used in ``config.yaml`` 
for specifying other paths relative to ``$BUILDTEST_ROOT``

Shown below is value of ``$BUILDTEST_ROOT`` after running ``source setup.sh`` 

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ env | grep BUILDTEST
   BUILDTEST_ROOT=/home/siddis14/github/buildtest-framework


Each site will have to customize their buildtest configuration to reflect the root of the module trees. 
You may specify multiple module trees  in ``config.yaml`` for variable ``BUILDTEST_MODULE_ROOT``. 
For more detail refer to ``config.example.yaml``.

You may specify any of the ``BUILDTEST_*`` variables with exception of ``BUILDTEST_ROOT`` using environment variables which will
override values specified in  ``config.yaml``. 

The environment variables are used by buildtest to determine the path where to retrieve
module files, yaml configs and write test scripts. You can also reference
these variables in yaml configs to write custom build and run commands. The testscript can
reference source directory via **BUILDTEST_CONFIGS_REPO** to find files of interest


buildtest version (``buildtest -V``)
------------------------------------

You can check the current version of buildtest by running the following

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ buildtest -V
   buildtest version: 0.2.0

