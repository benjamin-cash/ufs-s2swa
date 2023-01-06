#!/usr/bin/bash -f

export CYLC_TASK_PARAM_mem="mem001"
export RUN_ROOT_DIR="/scratch1/02441/bcash/prototype-p8/ufs-s2swa.test.744.x12.y16.cpn36.wg3.wt108/run"
export CYLC_TASK_PARAM_ldate=2012010100
export RESOL="C384"
export input="/work2/02441/bcash/frontera/ufs-weather-model/prototype-p8/tests/parm/ww3_shel.inp.IN"
export output="ww3_shel.inp"
export CYLC_TASK_CYCLE_POINT=1
export NHOURS=744
bash generate_model_files_from_templates.sh
python $WORK/workflow-tools/src/uwtools/templater.py -i $RUN_ROOT_DIR/$CYLC_TASK_PARAM_ldate/$RESOL/$CYLC_TASK_PARAM_mem/${output}.jinja2 --values_needed
