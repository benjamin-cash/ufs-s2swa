#!/usr/bin/bash -f

MEMBER=$CYLC_TASK_PARAM_mem
RUNDIR=$RUN_ROOT_DIR/$CYLC_TASK_PARAM_ldate/$RESOL/$MEMBER
MNUM=10#${MEMBER:3:3}
CDATE=${CYLC_TASK_PARAM_ldate:0:8}
export ISEED_CA=$(( (CDATE*1000 + MNUM*10 + 4) % 2147483647 ))
echo $RUNDIR

python $WORK/workflow-tools/src/uwtools/atparse_to_jinja2.py -i $input -o $RUNDIR/${output}.jinja2
python $WORK/workflow-tools/src/uwtools/templater.py -i $RUNDIR/${output}.jinja2 -o $RUNDIR/${output}
 
