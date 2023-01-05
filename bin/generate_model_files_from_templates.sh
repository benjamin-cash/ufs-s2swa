#!/usr/bin/bash -f

MEMBER=$CYLC_TASK_PARAM_mem
RUNDIR=$RUN_ROOT_DIR/$CYLC_TASK_PARAM_ldate/$RESOL/$MEMBER
echo $RUNDIR

# Date manipulation to generate environment variables to fill in template
# from cylc ldate
export SYEAR=${CYLC_TASK_PARAM_ldate:0:4}
export SMONTH=${CYLC_TASK_PARAM_ldate:4:2}
export SDAY=${CYLC_TASK_PARAM_ldate:6:2}
export SHOUR=${CYLC_TASK_PARAM_ldate:8:2}

# CYCLE manipulation to calculate start and ending hours
export FHROT=$(( (CYLC_TASK_CYCLE_POINT-1)*NHOURS ))

# Increment in hours for end of next cycle
export FHMAX=$(( (CYLC_TASK_CYCLE_POINT)*NHOURS ))
echo $CYLC_TASK_CYCLE_POINT $CYLC_NHOURS

# Calculate ISEED_CA based on ldate and ensemble member
CDATE=${CYLC_TASK_PARAM_ldate:0:8}
MNUM=10#${MEMBER:3:3}
export ISEED_CA=$(( (CDATE*1000 + MNUM*10 + 4) % 2147483647 ))

python $WORK/workflow-tools/src/uwtools/atparse_to_jinja2.py -i $input -o $RUNDIR/${output}.jinja2
python $WORK/workflow-tools/src/uwtools/templater.py -i $RUNDIR/${output}.jinja2 -o $RUNDIR/${output}
 
