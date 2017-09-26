.. _Features_of_buildtest:

Features of buildtest
---------------------

buildtest can comes with several features that includes
 - List software 
 - List easybuild toolchains
 - List Software Version Relationship

List Software
~~~~~~~~~~~~~~

buildtest can report the software list by running the following

.. code::

   buildtest -ls

buildtest determines the software list based on your module tree and these are
apps that can be used for generating tests


.. program-output:: cat scripts/Features_of_buildtest/softwarelist.txt

List Toolchains
~~~~~~~~~~~~~~~

buildtest can list the toolchain list by running

.. code::

   buildtest -lt

This will get the same result defined by **eb --list-toolchains**, we have
taken the list of toolchains from eb and defined them in buildtest. Any app
built with the any of the toolchains can be used with buildtest to generate
tests.


.. program-output:: cat scripts/Features_of_buildtest/toolchainlist.txt


Software Version Relationship
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to find every application in your eb stack with the exact version
you should use 

.. code::

   buildtest -svr

To query all the modules with the corresponding versions. Multiple versions of 
the same application will be separated by comma. Hidden files will be presented 
separately with a leading **.** followed by the version 

.. program-output:: cat scripts/Features_of_buildtest/software_version.txt
