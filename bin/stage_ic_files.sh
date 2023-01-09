#!/bin/bash

INPUT_DATA_ROOT_DIR=$CYLC_INPUT_ROOT_DIR/$SUBDIR
INPUT_DATA_CASE_DIR=$INPUT_DATA_ROOT_DIR/$CYLC_TASK_PARAM_ldate
RUNDIR=$CYLC_RUN_ROOT_DIR/$CYLC_TASK_PARAM_ldate/$CYLC_RESOL
MEMBER=$CYLC_TASK_PARAM_mem
RESOL=$CYLC_RESOL

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

list_of_common_input_files=$INPUT_DATA_CASE_DIR/${RESOL}.common_file_list.txt
list_of_perturbed_input_files=$INPUT_DATA_CASE_DIR/${RESOL}.perturbed_file_list.txt

while IFS=" " read -ra fname; do
	if [[ -e $INPUT_DATA_CASE_DIR/${fname[0]} ]]; then
		echo $INPUT_DATA_CASE_DIR/${fname[0]} $RUNDIR/$MEMBER/${fname[1]}
		cp $INPUT_DATA_CASE_DIR/${fname[0]} $RUNDIR/$MEMBER/${fname[1]}
	else
		echo "ERROR " $INPUT_DATA_CASE_DIR/${fname[0]} "not found!"
		exit_code=1
	fi
done < $list_of_common_input_files

while IFS=" " read -ra fname; do
	echo $INPUT_DATA_CASE_DIR/$MEMBER/${fname[0]} $RUNDIR/$MEMBER/INPUT/${fname[1]}
	if [[ -e $INPUT_DATA_CASE_DIR/$MEMBER/${fname[0]} ]]; then
		echo $INPUT_DATA_CASE_DIR/$MEMBER/${fname[0]} $RUNDIR/$MEMBER/INPUT/${fname[1]}
		cp $INPUT_DATA_CASE_DIR/$MEMBER/${fname[0]} $RUNDIR/$MEMBER/INPUT/${fname[1]}
	else
		echo "ERROR " $INPUT_DATA_CASE_DIR/$MEMBER/${fname[0]} "not found!"
		exit_code=1
	fi
done < $list_of_perturbed_input_files

exit $exit_code

