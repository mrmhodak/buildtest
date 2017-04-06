.. BuildTest_Setup:

BuildTest Setup
-----------------

Requirements:
 - Python 
 - YAML library
 - easyconfig repo
 - Lmod/Environment Modules
 - CMake >= 2.8

1. Edit setup.py and specify path for your module tree root at **BUILDTEST_MODULEROOT**. This variable is used by **buildtest** to find modules in your system and used to verify which test can be created by buildtest.

For instance, **BUILDTEST_MODULEROOT** on my system is set to /nfs/grid/software/RHEL7/easybuild/modules/ 

.. code:: 
           
      [hpcswadm@amrndhl1157 BuildTest]$ ls -l /nfs/grid/software/RHEL7/easybuild/modules 
      total 2
      drwxr-xr-x 5 hpcswadm hpcswadm 69 Mar 27 14:25 all

2.  Specify the path for the easyconfig directory in **setup.py** for variable **BUILDTEST_EASYCONFIGDIR**. This will be used for finding the toolchains which is necessary to build the test.

.. Note:: easyconfig files not installed on the system can cause issues

3. Check if software and toolchain are processed via buildtest 

   BuildTest finds the modulefiles from *BUILDTEST_MODULEROOT* and extracts the name and version since module files are stored in format <software>/<version>. BuildTest adds software into a set to report unique software. BuildTest uses easyconfig files to extract the toolchain names by processing the toolchain field from each easyconfig and adds the toolchain to set.

.. code::    

        [hpcswadm@amrndhl1157 BuildTest]$ ./buildtest.py -ls | head -n 15
        
                       List of Unique Software: 
                      ---------------------------- 
        Advisor
        Anaconda2
        Anaconda3
        Autoconf
        Automake
        Autotools
        BEDTools
        BWA
        BamTools
        Bison
        Boost
        Bowtie  


        [hpcswadm@amrndhl1157 BuildTest]$ ./buildtest.py -lt
 
                List of Toolchains:
                --------------------
              
        GCCcore 6.2.0
        dummy dummy
        iimpic 2017.01-GCC-5.4.0-2.27
        GCC 5.4.0-2.27
        iccifortcuda 2017.1.132-GCC-5.4.0-2.27
        GCC 6.2.0-2.27
        gompic 2016.03
        iompi 2017.01
        gompi 2016.09
        iccifort 2017.1.132-GCC-5.4.0-2.27
        GCCcore 5.4.0
        gcccuda 2016.03
        foss 2016.03
        intel 2017.01
        goolfc 2016.03
        foss 2016.09
        gompi 2016.03
        iimpi 2017.01-GCC-5.4.0-2.27

