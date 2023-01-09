#!/bin/bash

INPUT_DATA_ROOT_DIR=$INPUT_ROOT_DIR/$SUBDIR
RUNDIR=$RUN_ROOT_DIR/$CYLC_TASK_PARAM_ldate/$RESOL
MEMBER=$CYLC_TASK_PARAM_mem

# Assume success
exit_code=0

echo "path variables"
echo $INPUT_DATA_ROOT_DIR
echo $RUNDIR
echo $MEMBER

# Check for model run directory
if ! [ -e $RUNDIR/$MEMBER/INPUT ]; then
        mkdir -p $RUNDIR/$MEMBER/INPUT
fi

list_of_input_files=$INPUT_DATA_ROOT_DIR/$FLIST

while IFS=" " read -ra fname; do
	if [[ -e $INPUT_DATA_ROOT_DIR/${fname[0]} ]]; then
		echo $INPUT_DATA_ROOT_DIR/${fname[0]} $RUNDIR/$MEMBER/${fname[1]}
		$CMD $INPUT_DATA_ROOT_DIR/${fname[0]} $RUNDIR/$MEMBER/${fname[1]}
	else
		echo "ERROR "$INPUT_DATA_ROOT_DIR/${fname[0]} "not found!"
		exit_code=1
	fi
done < $list_of_input_files

exit $exit_code
