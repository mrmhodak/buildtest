.. _r_package_testing:

Building Tests for R packages (``_buildtest --r-package <R-PACKAGE>``)
===============================================================================

buildtest comes with option to build test for R packages to verify R packages
are working as expected. The R tests are coming from the repository
https://github.com/HPC-buildtest/R-buildtest-config

In buildtest this repository is defined by variable ``BUILDTEST_R_REPO`` that
can be tweaked by environment variable or configuration file (``config.yaml``)

buildtest supports tab completion for option ``--r-package`` which will show
a list of r packages available for testing.

To illustrate the tab completion feature see command below

.. code::

    [siddis14@prometheus buildtest-framework]$ _buildtest --r-package
    Display all 108 possibilities? (y or n)
    abc             animation       bigmemory       calibrate       evaluate        ffbase          forecast        gam             stringi         TeachingDemos   TraMineR
    abind           ape             bio3d           car             expm            fields          foreign         gamlss.data     stringr         tensor          tree
    acepack         arm             bit             caret           extrafont       filehash        formatR         gamlss.dist     strucchange     tensorA         trimcluster
    adabag          assertthat      bitops          caTools         FactoMineR      flashClust      Formula         gbm             subplex         testthat        tripack
    ade4            AUC             bnlearn         cgdsr           fail            flexclust       fossil          gclus           SuperLearner    TH.data         tseries
    adegenet        backports       boot            checkmate       fastcluster     flexmix         fpc             gdalUtils       SuppDists       tibble          tseriesChaos
    adephylo        base            bootstrap       chron           fastICA         fma             fpp             gdata           survival        tidyr           TTR
    ADGofTest       base64          brglm           cluster         fastmatch       FME             fracdiff        geepack         survivalROC     timeDate        unbalanced
    akima           BatchJobs       Brobdingnag     EasyABC         fdrtool         FNN             futile.logger   geiger          taxize          tkrplot
    AlgDesign       beanplot        Cairo           ellipse         ff              foreach         futile.options  statmod         tcltk           tm



To build r package test you must specify a ``R`` module. buildtest will
generate the binarytest along with any test from R package specified by
option ``--r-package``.

.. code::

    [siddis14@prometheus buildtest-framework]$ _buildtest -s R/3.4.3-intel-2018a-X11-20171023 --r-package abc
    Detecting Software:  R/3.4.3-intel-2018a-X11-20171023
    --------------------------------------------
    [STAGE 1]: Building Binary Tests
    --------------------------------------------
    Detecting Test Type: Software
    Processing Binary YAML configuration:  /home/siddis14/github/buildtest-configs/buildtest/ebapps/r/3.4.3/command.yaml

    Generating 2 binary tests
    Binary Tests are written in /tmp/buildtest-tests/ebapp/R/3.4.3-intel-2018a-X11-20171023/
    --------------------------------------------
    [STAGE 2]: Building Source Tests
    --------------------------------------------
    Processing all YAML files in directory: /home/siddis14/github/buildtest-configs/buildtest/ebapps/r/config
    Generating 1 Source Tests and writing at  /tmp/buildtest-tests/ebapp/R/3.4.3-intel-2018a-X11-20171023/
    Generating  8 tests for  abc
    Writing Log file:  /tmp/buildtest/R/3.4.3-intel-2018a-X11-20171023/buildtest_10_27_07_08_2018.log


This option is compatible with ``--shell`` and ``--job-template`` if you want to build
tests with different shell or create job scripts
