#!/usr/bin/bash -f
#SBATCH -A ATM22010
#SBATCH --time 00:30:00 
#SBATCH --partition development
#SBATCH -n 58
#SBATCH -N 2

# This is a harness that allows for testing of script changes without creating an entirely new 
# cylc workflow installation. 
module purge
module use /work2/02441/bcash/frontera/spack-stack/envs/ufs-weather-model.frontera.intel/install/modulefiles/Core
module load stack-intel/19.1.1.217
module load stack-intel-mpi/2020.4.304
module load ufs-weather-model-env/1.0.0
module load nco
module load launcher

export CYLC_TASK_PARAM_mem="mem007"
export ROOT_DIR="/scratch1/02441/bcash/prototype-p8/two_year_ensemble.reduced_restart.744.x12.y16.cpn36.wg3.wt108"
export RUN_ROOT_DIR="${ROOT_DIR}/run"
export POST_ROOT_DIR="${ROOT_DIR}/post"
export CYLC_TASK_PARAM_ldate=2012010100
export RESOL="C384"
export CYLC_TASK_CYCLE_POINT=1
export NHOURS=8928
. ./date_manipulation.sh

export TSDIR=$POST_ROOT_DIR/$CYLC_TASK_PARAM_ldate/$RESOL/$CYLC_TASK_PARAM_mem/tseries
if [[ ! -e $TSDIR ]]; then
    mkdir -p $TSDIR
fi

export LAUNCHER_WORKDIR=$SCRATCH/launcher/process_all
export LAUNCHER_JOB_FILE=$WORK/workflow/ufs-s2swa/bin/launcher_tseries.sh
export LAUNCHER_BIND=1
export LAUNCHER_SCHED=interleaved

if [[ ! -e $LAUNCHER_WORKDIR ]]; then
    mkdir -p $LAUNCHER_WORKDIR
fi
$LAUNCHER_DIR/paramrun

