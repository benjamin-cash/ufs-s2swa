#!/usr/bin/bash -f

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
export NHOURS=744
. ./date_manipulation.sh
mkdir -p $POSTDIR
export ATMF_VARS="pressfc tmp hgtsfc"
#srun python $WORK/workflow/ufs-s2swa/bin/process_atmf_output.py
if [[ -e launcher_process_atmf_output.sh ]]; then
    rm launcher_process_atmf_output.sh
fi

for vname in ${ATMF_VARS[@]}; do
    echo "time python $WORK/workflow/ufs-s2swa/bin/process_atmf_output_dask.py $vname" >> launcher_process_atmf_output.sh
done
