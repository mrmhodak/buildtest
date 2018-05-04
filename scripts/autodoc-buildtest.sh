#!/bin/bash

DIR=$HOME/github/buildtest/scripts
if [[ ! -d $DIR/buildtest-framework ]]; then

	git clone git@github.com:HPC-buildtest/buildtest-framework.git
	git clone git@github.com:HPC-buildtest/buildtest-configs.git
	git clone git@github.com:HPC-buildtest/R-buildtest-config.git
	git clone git@github.com:HPC-buildtest/Python-buildtest-config.git
	git clone git@github.com:HPC-buildtest/Perl-buildtest-config.git
	git clone git@github.com:HPC-buildtest/Ruby-buildtest-config.git
	git clone git@github.com:HPC-buildtest/Tcl-buildtest-config.git
fi

cd $DIR/buildtest-framework
ml eb-2017 Anaconda2/4.2.0
ml
source $DIR/buildtest-framework/setup.sh
cd ..
export BUILDTEST_CONFIGS_REPO=$DIR/buildtest-configs
export BUILDTEST_R_REPO=$DIR/R-buildtest-config
export BUILDTEST_PYTHON_REPO=$DIR/Python-buildtest-config
export BUILDTEST_PERL_REPO=$DIR/Perl-buildtest-config
export BUILDTEST_RUBY_REPO=$DIR/Ruby-buildtest-config
export BUILDTEST_TCL_REPO=$DIR/Tcl-buildtest-config

export BUILDTEST_TESTDIR=$BUILDTEST_ROOT/tests
export BUILDTEST_LOGDIR=$BUILDTEST_ROOT/logs
cd $DIR/buildtest-framework

buildtest --help >  $DIR/How_to_use_buildtest/buildtest-help.txt
buildtest -s GCC/6.4.0-2.28  >$DIR/How_to_use_buildtest/example-GCC-6.4.0-2.28.txt
cd $BUILDTEST_ROOT
mkdir -p build
cd build
cmake .. > $DIR/How_to_use_buildtest/cmake-build.txt
ctest . > $DIR/How_to_use_buildtest/run-GCC-6.4.0-2.28.txt
cd $BUILDTEST_ROOT
buildtest --show > $DIR/Show_Configuration/buildtest-show.txt
buildtest -s OpenMPI/2.0.0 -t GCC/5.4.0-2.27 --testset MPI --enable-job > $DIR/Jobscript_yaml_configuration/slurm-example.txt

buildtest -s GCC/6.4.0-2.28 --shell csh > $DIR/Shell/GCC-6.4.0-2.28_csh.txt
ls -l $BUILDTEST_TESTDIR/ebapp/GCC/6.4.0-2.28/ > $DIR/Shell/GCC-6.4.0-2.28_csh_listing.txt
buildtest -s GCC/6.4.0-2.28 --shell bash > $DIR/Shell/GCC-6.4.0-2.28_bash.txt
ls -l $BUILDTEST_TESTDIR/ebapp/GCC/6.4.0-2.28/ > $DIR/Shell/GCC-6.4.0-2.28_bash_listing.txt

cat $BUILDTEST_ROOT/template/job.lsf > $DIR/Job_Template/job.lsf
buildtest --system firefox --job-template template/job.lsf --enable-job > $DIR/Job_Template/firefox_jobscript.txt
buildtest -s GCC/6.4.0-2.28 --job-template template/job.lsf --enable-job
ls -l $BUILDTEST_TESTDIR/ebapp/GCC/6.4.0-2.28/*.lsf > $DIR/Job_Template/GCC-6.4.0-2.28_lsf_job.txt
rm -rf $BUILDTEST_ROOT

