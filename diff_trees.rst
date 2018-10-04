.. _diff_trees:

Difference Between Module Trees (``_buildtest --diff-trees``)
---------------------------------------------------------------

buildtest can report difference between two module trees and report which software is present
in which tree. This may be useful if you plan to have a **stage** and **prod** module tree
and you want to keep these trees in sync.

If your HPC site builds software stack for each architecture and your environment is
heterogeneous then ``--diff-trees`` will be helpful.


buildtest takes two trees as argument for --diff-trees option ``_buildtest --diff-tree tree1,tree2``
where trees are separated by a comma. The tree must point to the root of the module tree in your
system and buildtest will walk through the entire tree. We expect this operation to be quick
given that the module tree is on the order of few thousand module files which is a reasonable
count of module files in a large HPC facility.

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ _buildtest --diff-trees /nfs/grid/software/easybuild/2018/Broadwell/redhat/7.3/all,/clust/app/easybuild/2018/SkyLake/redhat/7.3/modules/all
                            Comparing Module Trees for differences in module files
                            -------------------------------------------------------

     Module Tree 1: /nfs/grid/software/easybuild/2018/Broadwell/redhat/7.3/all
     Module Tree 2: /clust/app/easybuild/2018/SkyLake/redhat/7.3/modules/all

     ID       |     Module                                                   |   Module Tree 1    |   Module Tree 2
     ---------|--------------------------------------------------------------|--------------------|----------------------
     1        | OpenMM/7.1.1-intel-2018a-Python-2.7.14                       | FOUND              | NOT FOUND
     2        | BamTools/2.5.1-intel-2018a                                   | FOUND              | NOT FOUND
     3        | SAMtools/1.6-intel-2018a                                     | FOUND              | NOT FOUND
     4        | GLPK/4.61-intel-2018a                                        | FOUND              | NOT FOUND
     5        | BEDTools/2.27.1-intel-2018a                                  | FOUND              | NOT FOUND
     6        | Ruby/2.5.0-intel-2018a                                       | FOUND              | NOT FOUND
     7        | git/2.16.1-intel-2018a                                       | FOUND              | NOT FOUND
     8        | JAGS/4.3.0-intel-2018a                                       | FOUND              | NOT FOUND
     9        | netCDF-Fortran/4.4.4-intel-2018a                             | FOUND              | NOT FOUND
     10       | BWA/0.7.17-intel-2018a                                       | FOUND              | NOT FOUND



If there is no difference between module trees you will get the following.

.. code::


   [siddis14@amrndhl1157 buildtest-framework]$ _buildtest --diff-trees /clust/app/easybuild/2018/Broadwell/redhat/7.3/modules/all,/clust/app/easybuild/2018/SkyLake/redhat/7.3/modules/all
   No difference found between module tree:  /clust/app/easybuild/2018/Broadwell/redhat/7.3/modules/all and module tree: /clust/app/easybuild/2018/SkyLake/redhat/7.3/modules/all
