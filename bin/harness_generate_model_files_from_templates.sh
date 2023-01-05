#!/usr/bin/bash -f

export CYLC_TASK_PARAM_mem="mem001"
export RUN_ROOT_DIR="/scratch1/02441/bcash/prototype-p8/ufs-s2swa.test.744.x12.y16.cpn36.wg3.wt108/run"
export CYLC_TASK_PARAM_ldate=2012010100
export RESOL="C384"
export input="/work2/02441/bcash/frontera/ufs-weather-model/prototype-p8/tests/parm/nems.configure.cpld.IN"
export output="nems.configure"

bash generate_model_files_from_templates.sh
python $WORK/workflow-tools/src/uwtools/templater.py -i $RUN_ROOT_DIR/$CYLC_TASK_PARAM_ldate/$RESOL/$CYLC_TASK_PARAM_mem/${output}.jinja2 --values_needed
