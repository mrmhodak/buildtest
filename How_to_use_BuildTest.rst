.. _How_to_use_BuildTest:


How to use buildtest
====================


.. contents::
   :backlinks: none


If you have not completed setup your environment please :ref:`checkout the  setup. <Setup>`


Usage
-----

Let's start with the basics. 

If you are unsure about buildtest see the help section (``buildtest --help``) for more details.

.. program-output:: cat scripts/How_to_use_buildtest/buildtest-help.txt

Building the Test
-----------------

Whenever you want to build a test, check your module file to find out what software package
exist on your system, then simply run the test as follows:

.. program-output:: cat scripts/How_to_use_buildtest/example-GCC-5.4.0-2.27.txt



Launching Testing 
-----------------
buildtest will setup your environment with CTEST so you can build from out-of-source directory.
Create a new directory for instance **build**, then do the following


.. program-output:: cat scripts/How_to_use_buildtest/cmake-build.txt

You can launch an interactive session to run the test. This can be done by running the following.


.. code::

   buildtest --runtest

Follow instruction in the menu to run the test.


Afterward run ``ctest .`` to run all the tests


.. program-output:: cat scripts/How_to_use_buildtest/run-GCC-5.4.0-2.27.txt

buildtest has an interactive session to run the test. This can be done by running

buildtest can generate tests for system packages using the flag **--system**. 
Currently, system package test only perform binary test. This means you need to 
find the binaries associated with the package and add the executable and any 
parameters in command.yaml.

This file will be $BUILDTEST_SOURCEDIR/system/$pkg/command.yaml where $pkg is 
name of system package. At this moment, buildtest is using Redhat package 
naming convention.


.. code::

   buildtest --runtest

This will result in a menu driven promp to navigate to the test.

.. program-output:: cat scripts/How_to_use_buildtest/runtest.txt

TAB Argument Completion
-----------------------

buildtest use the argcomplete python module to autocomplete buildtest argument. 
Just press TAB key on the keyboard to fill in the arguments. 

For instance if you just type ``buildtest`` followed by TAB you should see the 
following.

.. code::

        [siddis14@amrndhl1157 buildtest-framework]$ buildtest -
        --clean-logs                  --findconfig                  --list-toolchain              --runtest                     -svr                          -V
        --clean-tests                 --findtest                    --list-unique-software        -s                            --system                      --version
        --diff-trees                  -ft                           --logdir                      --scantest                    --sysyaml
        --easyconfigs-in-moduletrees  -h                            -ls                           --shell                       -t
        --ebyaml                      --help                        -lt                           --software                    --testdir
        -ecmt                         --ignore-easybuild            -mns                          --software-version-relation   --testset
        -fc                           --job-template                --module-naming-scheme        --submitjob                   --toolchain

.. Note:: You will need to press the TAB key few times before it shows all the 
   args

TAB completion works for choice parameters like ``--shell``, ``--software``, 
``--toolchain``, ``--system``, ``--sysyaml``, ``--testset``

TAB complete on --software
~~~~~~~~~~~~~~~~~~~~~~~~~~


TAB complete on --software will present all unique software found from module tree
`BUILDTEST_EBROOT`


.. code::

   [siddis14@amrndhl1228 buildtest-framework]$ buildtest --software
   Display all 193 possibilities? (y or n)
   ACTC/.1.1                                          Ghostscript/.9.19                                  M4/.1.4.17
   Advisor/2017_update1                               git/2.10.2                                         Mako/.1.0.6-Python-2.7.12
   Amber/14-AmberTools-15-patchlevel-13-13            git-lfs/1.1.1                                      Mesa/17.0.2
   Anaconda2/4.2.0                                    GLib/.2.49.5                                       motif/.2.3.5
   Anaconda3/4.2.0                                    GLPK/4.60                                          NAMD/2.12-mpi
   Aspera-Connect/3.6.1                               GMP/6.1.1                                          NASM/.2.12.02
   Autoconf/.2.69                                     Go/1.9                                             ncurses/.6.0
   Automake/.1.15                                     gompi/.2016.03                                     netCDF/4.4.1
   Autotools/.20150215                                gompi/.2016.09                                     netCDF-Fortran/4.4.4
   BamTools/2.4.0                                     gompi/.2016b                                       nettle/.3.3
   BEDTools/2.26.0                                    grace/5.1.25                                       numactl/2.0.11
   binutils/.2.26                                     GROMACS/2016-hybrid                                NWChem/6.6.revision27746-2015-10-20-Python-2.7.12
   binutils/.2.27                                     GSL/2.1                                            OpenBabel/2.4.1-Python-2.7.12
   Bison/.3.0.4                                       HDF5/1.8.16                                        OpenBLAS/0.2.19-LAPACK-3.6.0
   Boost/1.54.0-Python-2.7.12                         HMMER/3.1b2                                        OpenMPI/2.0.0
   Boost/1.60.0                                       hwloc/1.11.3                                       OpenMPI/2.0.1
   Boost/1.63.0-Python-2.7.12                         icc/.2017.1.132-GCC-5.4.0-2.27                     OpenMPI/2.0.2
   Bowtie/1.1.2                                       iccifort/.2017.1.132-GCC-5.4.0-2.27                OSU-Micro-Benchmarks/5.3.2
   Bowtie2/2.2.9                                      iccifortcuda/.2017.01                              parallel/20160622
   BWA/0.7.15                                         ifort/.2017.1.132-GCC-5.4.0-2.27                   PCRE/8.38
   bzip2/.1.0.6                                       IGV/2.3.80-Java-1.8.0_92                           PEAR/0.9.8
   cairo/.1.14.6                                      iimpi/.2017.01-GCC-5.4.0-2.27                      Perl/5.22.1
   cairo/1.14.6                                       iimpic/.2017.01                                    picard/2.1.0-Java-1.8.0_92
   cellranger/2.0.1                                   ImageMagick/7.0.3-1                                pigz/2.3.4
   cellranger/2.0.2                                   imkl/2017.1.132                                    pixman/.0.34.0
   Chimera/1.11.2-linux_x86_64                        impi/2017.1.132                                    pkg-config/.0.29.1
   Clang/3.8.1                                        inputproto/.2.3.1                                  PROJ/.4.9.3
   ClustalW2/2.1                                      Inspector/2017_update1                             PyCharm/2017.2.3
   CMake/3.7.1                                        intel/2017.01                                      Python/2.7.12
   CP2K/4.1                                           IntelClusterChecker/2017.1.016                     R/3.3.1
   CUDA/8.0.44                                        intelcuda/2017.01                                  R-bundle-extra/2017-R-3.3.1
   cuDNN/5.1-CUDA-8.0.44                              iompi/2017.01                                      renderproto/.0.11
   cURL/.7.49.1                                       ipp/2017.1.132                                     Ruby/2.3.4
   cutadapt/1.9.1-Python-2.7.12                       itac/2017.1.024                                    Ruby-bundle/2.3.4-Ruby-2.3.4
   daal/2017.1.132                                    JAGS/4.2.0                                         SAMtools/1.3
   Doxygen/.1.8.11                                    JasPer/.1.900.1                                    ScaLAPACK/2.0.2-OpenBLAS-0.2.19-LAPACK-3.6.0
   EasyBuild/3.3.1                                    Java/1.8.0_92                                      seqtk/1.2
   EasyBuild/3.4.0                                    Jellyfish/2.2.6                                    snpEff/4.1d-Java-1.8.0_92
   Eigen/3.2.8                                        kbproto/.1.0.7                                     SQLite/.3.13.0
   EMBOSS/6.6.0                                       LAMMPS/11Aug17                                     supermagic/20170824
   expat/.2.2.0                                       libdrm/.2.4.76                                     SWIG/3.0.10-Python-2.7.12
   FastQC/0.11.5-Java-1.8.0_92                        libffi/.3.2.1                                      Szip/.2.1
   FASTX-Toolkit/0.0.14                               libGLU/.9.0.0                                      tbb/2017.2.132
   FFmpeg/3.1.3                                       libgtextutils/.0.7                                 Tcl/.8.6.5
   FFTW/3.3.4                                         libharu/.2.3.0                                     T-Coffee/11.00.8cbe486_linux_x64
   FFTW/3.3.5                                         libICE/.1.0.9                                      Tk/.8.6.5
   --More--

TAB complete on --toolchain
~~~~~~~~~~~~~~~~~~~~~~~~~~~

TAB completion on --toolchain will present all easybuild toolchains installed
in the software stack

.. code::

   [siddis14@amrndhl1228 buildtest-framework]$ buildtest --toolchain
   foss/.2016.03                        GCCcore/.5.4.0                       iccifort/.2017.1.132-GCC-5.4.0-2.27  intelcuda/2017.01
   foss/.2016.09                        GCCcore/.6.2.0                       iccifortcuda/.2017.01                iompi/2017.01
   foss/.2016b                          gompi/.2016.03                       iimpi/.2017.01-GCC-5.4.0-2.27
   GCC/5.4.0-2.27                       gompi/.2016.09                       iimpic/.2017.01
   GCC/6.2.0-2.27                       gompi/.2016b                         intel/2017.01

TAB complete on --system
~~~~~~~~~~~~~~~~~~~~~~~~

TAB completion on --system will display all the system package that have a yaml
file typically found in buildtest-configs repo under **system** directory.

.. code::

        [siddis14@amrndhl1228 buildtest-framework]$ buildtest --system
        acl                 coreutils           gcc                 hwloc               perl                rpm                 time                yum
        all                 curl                gcc-c++             iptables            pinfo               ruby                util-linux          zip
        binutils            diffstat            gcc-gfortran        ltrace              powertop            sed                 wget
        CentrifyDC-openssh  file                git                 ncurses             procps-ng           strace              which
        chrony              firefox             htop                numactl             python              systemd             xz

TAB complete on --sysyaml
~~~~~~~~~~~~~~~~~~~~~~~~~

TAB completion --sysyaml will present all system package available on your
system. If you are using Centos, RHEL, or Fedora then you will be using yum
as your package manager. This output is extracted by getting output of ``rpm -qa``

.. code:: 

        [siddis14@amrndhl1228 buildtest-framework]$ buildtest --sysyaml
        Display all 1695 possibilities? (y or n)
        abattis-cantarell-fonts                         libnl3                                          python-custodia
        abrt                                            libnl3-cli                                      python-dateutil
        abrt-addon-ccpp                                 libnotify                                       python-decorator
        abrt-addon-kerneloops                           liboauth                                        python-deltarpm
        abrt-addon-pstoreoops                           libogg                                          python-devel
        abrt-addon-python                               libosinfo                                       python-dmidecode
        abrt-addon-vmcore                               libotf                                          python-dns
        abrt-addon-xorg                                 libpath_utils                                   python-enum34
        abrt-cli                                        libpcap                                         python-ethtool
        abrt-console-notification                       libpciaccess                                    python-gssapi
        abrt-dbus                                       libpeas                                         python-gudev
        abrt-libs                                       libpipeline                                     python-hwdata
        abrt-python                                     libplist                                        python-idna
        abrt-tui                                        libpng                                          python-iniparse
        acl                                             libpng12                                        python-ipaddress
        adcli                                           libproxy                                        python-javapackages
        adwaita-cursor-theme                            libpwquality                                    python-jsonpointer
        adwaita-gtk2-theme                              libquadmath                                     python-jwcrypto
        adwaita-icon-theme                              libquadmath-devel                               python-kerberos
        aic94xx-firmware                                librados2                                       python-kitchen
        alsa-firmware                                   libraw1394                                      python-kmod
        alsa-lib                                        libref_array                                    python-krbV
        alsa-tools-firmware                             libreport                                       python-ldap
        apr                                             libreport-cli                                   python-libipa_hbac
        apr-util                                        libreport-filesystem                            python-libs
        at                                              libreport-plugin-mailx                          python-lxml
        atk                                             libreport-plugin-rhtsupport                     python-magic
        atlas                                           libreport-plugin-ureport                        python-netaddr
        atop                                            libreport-python                                python-netifaces
        at-spi2-atk                                     libreport-rhel                                  python-nose
        at-spi2-core                                    libreport-web                                   python-nss
        attica                                          libreswan                                       python-pcp
        attr                                            librsvg2                                        python-perf
        audit                                           librsvg2-tools                                  python-ply
        audit-libs                                      libsane-hpaio                                   python-psutil
        augeas-libs                                     libsecret                                       python-psycopg2
        authconfig                                      libselinux                                      python-pycparser
        autoconf                                        libselinux-devel                                python-pycurl
        autofs                                          libselinux-python                               python-pyudev
        autogen-libopts                                 libselinux-utils                                python-qrcode-core
        automake                                        libsemanage                                     python-requests
        avahi                                           libsepol                                        python-rhsm
        avahi-autoipd                                   libsepol-devel                                  python-rhsm-certificates
        avahi-glib                                      libshout                                        python-rtslib
        avahi-libs                                      libSM                                           python-setuptools
        basesystem                                      libsmbclient                                    python-six
        --More--


System Package Test
-------------------

buildtest can generate tests for system packages using the option ``buildtest --system <package>``. 
Currently, system package test only perform binary test. This means you need to 
find the binaries associated with the package and add the executable and any 
parameters in ``command.yaml``.

This file will be ``$BUILDTEST_CONFIGS_REPO/system/$pkg/command.yaml`` where $pkg is 
name of system package. At this moment, buildtest is using Redhat package 
naming convention.

For instance to build test for the system package ``gcc`` you can do the following

.. code::

   buildtest --system gcc


To run all system package test you can do the following

.. code::

   buildtest --system all


Log files
---------

All buildtest logs will be written in ``BUILDTEST_LOGDIR``. 

buildtest will store log files for ``buildtest -s app/app_ver`` in ``BUILDTEST_LOGDIR/app/app_ver``
If toolchain option is specified for instance ``buildtest -s app/app_ver -t tc_name/tc_ver`` then buildtest will store the logs in
``BUILDTEST_LOGDIR/app/app_ver/tc_name/tc_ver``.

Similarly logs for system tests like ``buildtest --system <package>`` will be stored in ``BUILDTEST_LOGDIR/system/package``

You may override BUILDTEST_LOGDIR option at command line via ``buildtest --logdir`` and you may even store individual buildtest runs in separate directories
such as the following

.. code::

   buildtest -s OpenMPI/3.0.0-GCC-6.4.0-2.28 --logdir=/tmp

 
