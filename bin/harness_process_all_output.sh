#!/usr/bin/bash -f
#SBATCH -J post_process           # Job name
#SBATCH -o post_process.o%j       # Name of stdout output file
#SBATCH -e post_process.e%j       # Name of stderr error file
#SBATCH -p small           # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for serial)
#SBATCH -n 56               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 12:00:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A ATM22010       # Project/Allocation name (req'd if you have more than 1)

# This is a harness that allows for testing of script changes without creating an entirely new 
# cylc workflow installation. 
module purge
module use /work2/02441/bcash/frontera/spack-stack/envs/ufs-weather-model.frontera.intel/install/modulefiles/Core
module load stack-intel/19.1.1.217
module load stack-intel-mpi/2020.4.304
module load ufs-weather-model-env/1.0.0
module load nco

export CYLC_TASK_PARAM_mem="mem010"
export ROOT_DIR="/scratch1/02441/bcash/prototype-p8/two_year_ensemble.reduced_restart.744.x12.y16.cpn36.wg3.wt108"
export RUN_ROOT_DIR="${ROOT_DIR}/run"
export POST_ROOT_DIR="${ROOT_DIR}/post"
export CYLC_TASK_PARAM_ldate=2012010100
export RESOL="C384"
export CYLC_TASK_CYCLE_POINT=1
export NHOURS=48
. ./date_manipulation.sh
mkdir -p $POSTDIR
bash harness_process_sfcf_output.sh
bash harness_process_atmf_output.sh
bash harness_process_grib_output.sh
bash harness_process_ocean_output.sh
