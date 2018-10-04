#!/bin/bash

DIR=/hpc/grid/hpcws/hpcengineers/siddis14/buildtest/scripts
cd $DIR
if [[ ! -d $DIR/buildtest-framework ]]; then

	git clone git@github.com:HPC-buildtest/buildtest-framework.git -b devel
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
export PATH=$BUILDTEST_ROOT:$PATH

_buildtest --help >  $DIR/How_to_use_buildtest/buildtest-help.txt
_buildtest build -s GCCcore/6.4.0  >$DIR/How_to_use_buildtest/example-GCCcore-6.4.0.txt
rm -rf /tmp/build
mkdir -p /tmp/build
cd /tmp/build
cmake .. > $DIR/How_to_use_buildtest/cmake-build.txt
ctest . > $DIR/How_to_use_buildtest/run-GCCcore-6.4.0.txt
cd $BUILDTEST_ROOT
_buildtest --show > $DIR/Show_Configuration/buildtest-show.txt
_buildtest build -s OpenMPI/2.0.0 -t GCC/5.4.0-2.27 --testset MPI --enable-job > $DIR/Jobscript_yaml_configuration/slurm-example.txt

_buildtest build -s GCCcore/6.4.0 --shell csh > $DIR/Shell/GCCcore-6.4.0_csh.txt
ls -l $BUILDTEST_TESTDIR/ebapp/GCCcore/6.4.0/ > $DIR/Shell/GCCcore-6.4.0_csh_listing.txt
_buildtest build -s GCCcore/6.4.0 --shell bash > $DIR/Shell/GCCcore-6.4.0_bash.txt
ls -l $BUILDTEST_TESTDIR/ebapp/GCCcore/6.4.0/ > $DIR/Shell/GCCcore-6.4.0_bash_listing.txt

cat $BUILDTEST_ROOT/template/job.lsf > $DIR/Job_Template/job.lsf
_buildtest build --system firefox --job-template template/job.lsf --enable-job > $DIR/Job_Template/firefox_jobscript.txt
_buildtest build -s GCCcore/6.4.0 --job-template template/job.lsf --enable-job
ls -l $BUILDTEST_TESTDIR/ebapp/GCCcore/6.4.0/*.lsf > $DIR/Job_Template/GCCcore-6.4.0_lsf_job.txt

# List_Subcommand.rst
_buildtest list --help > $DIR/List_Subcommand/help.txt
_buildtest list --list-unique-software > $DIR/List_Subcommand/software.txt
_buildtest list --list-toolchain > $DIR/List_Subcommand/toolchain.txt
_buildtest list --software-version-relation > $DIR/List_Subcommand/software_version.txt
_buildtest list --easyconfigs > $DIR/List_Subcommand/easyconfigs.txt

_buildtest list -ls --format stdout > $DIR/List_Subcommand/software_format_stdout.txt
_buildtest list -ls --format json > $DIR/List_Subcommand/software_format_json.txt
_buildtest list -svr --format csv > $DIR/List_Subcommand/software_format_csv.txt

# Build_Subcommand.rst
_buildtest build --help > $DIR/Build_Subcommand/help.txt

# perl_package_testing.rst
_buildtest build -s Perl/5.26.0-GCCcore-6.4.0 --perl-package AnyData > $DIR/perl_packagetest_AnyData.txt
_buildtest build -s Perl/5.26.0-GCCcore-6.4.0 --perl-package Algorithm > $DIR/perl_packagetest_Algorithm.txt

# Run_Subcommand.rst
_buildtest run --help > $DIR/Run_Subcommand/help.txt
_buildtest run --systempkg gcc > $DIR/Run_Subcommand/systempkg_gcc.txt
_buildtest run --app GCCcore/6.4.0 > $DIR/Run_Subcommand/app_GCCcore.txt
#rm -rf $BUILDTEST_ROOT

