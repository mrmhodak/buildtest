#!/bin/bash

DIR=/hpc/grid/hpcws/hpcengineers/siddis14/buildtest/scripts
cd $DIR
if [[ ! -d $DIR/buildtest-framework ]]; then

	git clone git@github.com:shahzebsiddiqui/buildtest-framework.git -b devel
	git clone git@github.com:HPC-buildtest/buildtest-configs.git -b devel
	git clone git@github.com:HPC-buildtest/R-buildtest-config.git -b devel
	git clone git@github.com:HPC-buildtest/Python-buildtest-config.git -b devel
	git clone git@github.com:HPC-buildtest/Perl-buildtest-config.git -b devel
	git clone git@github.com:HPC-buildtest/Ruby-buildtest-config.git -b devel
fi

cd $DIR/buildtest-framework
#ml Anaconda3
#source activate buildtest
BUILDTEST_ROOT=$DIR/buildtest-framework
#export BUILDTEST_TESTDIR=$BUILDTEST_ROOT/tests
#export BUILDTEST_LOGDIR=$BUILDTEST_ROOT/logs
BUILDTEST_TESTDIR=/tmp/buildtest-tests
BUILDTEST_CONFIGS_REPO=$HOME/github/buildtest-configs
export PATH=$BUILDTEST_ROOT:$PATH

rm -rf $BUILDTEST_TESTDIR
_buildtest --help >  $DIR/How_to_use_buildtest/buildtest-help.txt
_buildtest build -s GCCcore/6.4.0  >$DIR/How_to_use_buildtest/example-GCCcore-6.4.0.txt
_buildtest run -s GCCcore/6.4.0 > $DIR/How_to_use_buildtest/run-GCCcore-6.4.0.txt

rm -rf /tmp/build
mkdir -p /tmp/build
cd /tmp/build
cmake .. > $DIR/Run_Subcommand/cmake-build.txt
ctest . -I 1,10 > $DIR/Run_Subcommand/run-GCCcore-6.4.0.txt

cd $BUILDTEST_ROOT
_buildtest --show > $DIR/Show_Configuration/buildtest-show.txt


# Job_Template.rst
cat $BUILDTEST_ROOT/template/job.lsf > $DIR/Job_Template/job.lsf
_buildtest build --package firefox --job-template template/job.lsf --enable-job > $DIR/Job_Template/firefox_jobscript.txt
_buildtest build -s GCCcore/6.4.0 --job-template template/job.lsf --enable-job
ls -l $BUILDTEST_TESTDIR/ebapp/GCCcore/6.4.0/*.lsf > $DIR/Job_Template/GCCcore-6.4.0_lsf_job.txt

# List_Subcommand.rst
_buildtest list --help > $DIR/List_Subcommand/help.txt
_buildtest list --list-unique-software > $DIR/List_Subcommand/software.txt
_buildtest list --list-toolchain > $DIR/List_Subcommand/toolchain.txt
_buildtest list --software-version-relation > $DIR/List_Subcommand/software_version.txt
_buildtest list --easyconfigs > $DIR/List_Subcommand/easyconfigs.txt
_buildtest list --buildtest-software > $DIR/List_Subcommand/buildtest_software.txt


_buildtest list -ls --format stdout > $DIR/List_Subcommand/software_format_stdout.txt
_buildtest list -ls --format json > $DIR/List_Subcommand/software_format_json.txt
_buildtest list -svr --format csv > $DIR/List_Subcommand/software_format_csv.txt

# Shell.rst
_buildtest build -s CMake/3.9.5-GCCcore-6.4.0 --shell csh > $DIR/Shell/CMake-3.9.5-GCCcore-6.4.0_csh.txt
ls -l $BUILDTEST_TESTDIR/ebapp/CMake/3.9.5-GCCcore-6.4.0/*.csh > $DIR/Shell/CMake-3.9.5-GCCcore-6.4.0_csh_listing.txt
_buildtest build -s CMake/3.9.5-GCCcore-6.4.0 --shell bash > $DIR/Shell/CMake-3.9.5-GCCcore-6.4.0_bash.txt
ls -l $BUILDTEST_TESTDIR/ebapp/CMake/3.9.5-GCCcore-6.4.0/*.bash > $DIR/Shell/CMake-3.9.5-GCCcore-6.4.0_bash_listing.txt
cat $BUILDTEST_TESTDIR/ebapp/CMake/3.9.5-GCCcore-6.4.0/CMakeLists.txt > $DIR/Shell/CMake-3.9.5-GCCcore-6.4.0_CMakelists.txt
_buildtest build -s GCCcore/6.4.0 --shell bash
cat $BUILDTEST_TESTDIR/ebapp/GCCcore/6.4.0/omp_hello.f.bash > $DIR/Shell/GCCcore-6.4.0_omp_hello.f.bash
_buildtest build -s GCCcore/6.4.0 --shell csh
cat $BUILDTEST_TESTDIR/ebapp/GCCcore/6.4.0/omp_hello.f.csh > $DIR/Shell/GCCcore-6.4.0_omp_hello.f.csh


# Build_Subcommand.rst
_buildtest build --help > $DIR/Build_Subcommand/help.txt
_buildtest build -s CMake/3.9.5-GCCcore-6.4.0  > $DIR/Build_Subcommand/CMake-3.9.5-GCCcore-6.4.0.txt
_buildtest build --package coreutils > $DIR/Build_Subcommand/coreutils.txt

# perl_package_testing.rst
_buildtest build -s Perl/5.26.0-GCCcore-6.4.0 --perl-package AnyData > $DIR/perl_packagetest_AnyData.txt
_buildtest build -s Perl/5.26.0-GCCcore-6.4.0 --perl-package Algorithm > $DIR/perl_packagetest_Algorithm.txt

# r_package_testing.rst
_buildtest build -s R/3.4.3-intel-2018a-X11-20171023 --r-package abc > $DIR/r_packagetest_abc.txt

# python_package_testing.rst
_buildtest build -s Python/2.7.14-intel-2018a --python-package dateutil > $DIR/python_packagetest_dateutil.txt
_buildtest build -s Python/2.7.14-GCCcore-6.4.0-bare --python-package Bottleneck > $DIR/python_packagetest_Bottleneck.txt

# ruby_package_testing_addressable
_buildtest build -s Ruby/2.5.0-intel-2018a --ruby-package addressable > $DIR/ruby_packagetest_addressable.txt

# Run_Subcommand.rst
_buildtest run --help > $DIR/Run_Subcommand/help.txt
_buildtest build --package gcc
_buildtest run --package gcc > $DIR/Run_Subcommand/systempkg_gcc.txt
_buildtest run --software GCCcore/6.4.0 > $DIR/Run_Subcommand/app_GCCcore.txt

#OpenMP_yaml.rst
cat $BUILDTEST_TESTDIR/ebapp/GCCcore/6.4.0/omp_getEnvInfo.c.csh > $DIR/OpenMP_yaml/omp_getEnvInfo.csh
ls -l  $BUILDTEST_TESTDIR/ebapp/GCCcore/6.4.0/omp_mm.c_nthread_*.csh > $DIR/OpenMP_yaml/omp_mm_listing.txt
cat  $BUILDTEST_TESTDIR/ebapp/GCCcore/6.4.0/omp_mm.c_nthread_2.csh > $DIR/OpenMP_yaml/omp_mm.c_nthread_2.csh

# Generate_yaml_from_buildtest.rst
_buildtest yaml --help > $DIR/Yaml_Subcommand/help.txt


cat $BUILDTEST_CONFIGS_REPO/buildtest/ebapps/gcccore/6.4.0/command.yaml > $DIR/BinaryTest_Yaml_Application/command.yaml
