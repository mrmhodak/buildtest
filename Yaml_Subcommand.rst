.. _Yaml_Subcommand:

Yaml Subcommand (``_buildtest yaml --help``)
======================================================================

.. program-output:: cat scripts/Yaml_Subcommand/help.txt

Rebuilding Yaml Configuration (``_buildtest yaml --rebuild``)
---------------------------------------------------------------

The option ``--rebuild`` allows buildtest to rebuild the yaml file for binarytest (``command.yaml``)
in the event the file exist. When the file exist, buildtest will generally return and
do nothing.

::

    (buildtest-0.5.0) [siddis14@adwnode1 buildtest-framework]$ _buildtest yaml --app GCCcore/6.4.0
    File already exist: /home/siddis14/github/buildtest-configs/buildtest/ebapps/gcccore/6.4.0/command.yaml

You may remove the file and rerun the command or you can use ``--rebuild`` or use short
option ``-r``.


::

    (buildtest-0.5.0) [siddis14@adwnode1 buildtest-framework]$ _buildtest yaml --app GCCcore/6.4.0 -r
    Please check YAML file  /home/siddis14/github/buildtest-configs/buildtest/ebapps/gcccore/6.4.0/command_10_57_17_10_2018.yaml  and fix test accordingly



Overwriting Yaml Configuration (``_buildtest yaml --overwrite``)
-----------------------------------------------------------------

Similar to ``--rebuild`` the ``--overwrite`` or short option ``-o`` is used to
overwrite the binary file ``command.yaml``

::

    (buildtest-0.5.0) [siddis14@adwnode1 buildtest-framework]$ _buildtest yaml --app GCCcore/6.4.0 -o
    Overwriting content of yaml file: /home/siddis14/github/buildtest-configs/buildtest/ebapps/gcccore/6.4.0/command.yaml

Both ``--rebuild`` and ``--overwrite`` option works with ``--app``, ``--systempkg``,
``--all-software-yaml``, ``--all-system-yaml``.
