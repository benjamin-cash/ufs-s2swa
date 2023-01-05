#!/usr/bin/bash -f

export CYLC_TASK_PARAM_mem="mem001"
export RUN_ROOT_DIR="/scratch1/02441/bcash/prototype-p8/ufs-s2swa.test.744.x12.y16.cpn36.wg3.wt108/run"
export CYLC_TASK_PARAM_ldate=2012010100
export RESOL="C384"
export input="/work2/02441/bcash/frontera/ufs-weather-model/prototype-p8/tests/parm/model_configure.IN"
export output="model_configure"

bash generate_model_files_from_templates.sh
