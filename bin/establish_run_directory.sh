#!/bin/bash

MEMBER=$CYLC_TASK_PARAM_mem
RUNDIR=$RUN_ROOT_DIR/$CYLC_TASK_PARAM_ldate/$RESOL/$MEMBER

echo "path variables"
echo $RUNDIR

# Check for existing run directory
if [ -d $RUNDIR ]; then
    echo $CLEAN_FLAG
    if [ $CLEAN_FLAG ]; then
        echo "Removing existing run directory"
        rm -rf ${RUNDIR}.del
        mv $RUNDIR ${RUNDIR}.del
    else
        echo "Run directory exists and CLEAN_FLAG false, exiting"
        exit 1
    fi
fi
echo $SUBDIRS

for SUBDIR in ${SUBDIRS[@]}; do
	echo $RUNDIR/$SUBDIR 
    if ! [ -e $RUNDIR/SUBDIR ]; then
        mkdir -p $RUNDIR/$SUBDIR
    fi
done
