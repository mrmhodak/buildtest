.. _Job_Template:

Job Template
------------



.. contents::
      :backlinks: none


LSF Job template
-----------------

buildtest provides a default job template for LSF to generate test scripts for LSF. This template is for creating LSF job submission scripts that can be run 
via ``bsub``. The templates can be found at ``$BUILDTEST_ROOT/template/``

.. program-output:: cat scripts/Job_Template/template.txt

Generate Job scripts via buildtest
----------------------------------

.. program-output:: cat scripts/Job_Template/template_example.txt


buildtest will generate the .lsf script in the same directory as the test script.

Let's take a look at the LSF test script


.. program-output:: cat scripts/Job_Template/firefox_jobscript.txt
