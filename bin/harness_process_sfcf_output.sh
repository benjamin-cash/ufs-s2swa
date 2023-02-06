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
export NHOURS=48
. ./date_manipulation.sh
mkdir -p $POSTDIR
export SFCF_VARS="prateb_ave cpratb_ave tmp2m tmpsfc spfh2m hpbl shtfl_ave lhtfl_ave dswrf_ave uswrf_ave dlwrf_ave ulwrf_ave icec icetk dtend_temp_lw dtend_temp_sw dtend_temp_pbl dtend_temp_deepcnv dtend_temp_shalcnv dtend_temp_mp dtend_temp_orogwd dtend_temp_cnvgwd dtend_temp_phys"
python $WORK/workflow/ufs-s2swa/bin/process_sfcf_output.py
