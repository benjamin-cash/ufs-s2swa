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

DATE_BEG=$(date -ud "$SYEAR$SMONTH$SDAY $SHOUR:00:00UTC + $FHROT hours" +%Y%m%d%H)
BYEAR=${DATE_BEG:0:4}
BMONTH=${DATE_BEG:4:2}
BDAY=${DATE_BEG:6:2}
BHOUR=${DATE_BEG:8:2}
export RUN_BEG="${BYEAR}${BMONTH}${BDAY} $(printf "%02d" $(( ${BHOUR}  )))0000"

DATE_END=$(date -ud "$SYEAR$SMONTH$SDAY $SHOUR:00:00UTC + $FHMAX hours" +%Y%m%d%H)
EYEAR=${DATE_END:0:4}
EMONTH=${DATE_END:4:2}
EDAY=${DATE_END:6:2}
EHOUR=${DATE_END:8:2}
export RUN_END="${EYEAR}${EMONTH}${EDAY} $(printf "%02d" $(( ${EHOUR}  )))0000"

echo $FHROT $FHMAX $RUN_BEG $RUN_END

# Calculate ISEED_CA based on ldate and ensemble member
CDATE=${CYLC_TASK_PARAM_ldate:0:8}
MNUM=10#${MEMBER:3:3}
export ISEED_CA=$(( (CDATE*1000 + MNUM*10 + 4) % 2147483647 ))

python $WORK/workflow-tools/src/uwtools/atparse_to_jinja2.py -i $input -o $RUNDIR/${output}.jinja2
python $WORK/workflow-tools/src/uwtools/templater.py -i $RUNDIR/${output}.jinja2 -o $RUNDIR/${output}
 
