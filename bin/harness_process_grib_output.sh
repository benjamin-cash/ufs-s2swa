#!/usr/bin/bash -f

# This is a harness that allows for testing of script changes without creating an entirely new 
# cylc workflow installation. 
module purge
module use /work2/02441/bcash/frontera/spack-stack/envs/ufs-weather-model.frontera.intel/install/modulefiles/Core
module load stack-intel/19.1.1.217
module load stack-intel-mpi/2020.4.304
module load ufs-weather-model-env/1.0.0
module load nco

export CYLC_TASK_PARAM_mem="mem007"
export ROOT_DIR="/scratch1/02441/bcash/prototype-p8/two_year_ensemble.reduced_restart.744.x12.y16.cpn36.wg3.wt108"
export RUN_ROOT_DIR="${ROOT_DIR}/run"
export POST_ROOT_DIR="${ROOT_DIR}/post"
export CYLC_TASK_PARAM_ldate=2012010100
export RESOL="C384"
export input="/work2/02441/bcash/frontera/ufs-weather-model/prototype-p8/tests/parm/ww3_shel.inp.IN"
export output="ww3_shel.inp"
export CYLC_TASK_CYCLE_POINT=3
export NHOURS=744
. ./date_manipulation.sh
mkdir -p $POSTDIR
python $WORK/workflow/ufs-s2swa/bin/process_grib_output.py
