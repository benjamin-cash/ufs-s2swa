#!/usr/bin/bash -f

# This is a harness that allows for testing of script changes without creating an entirely new 
# cylc workflow installation. 
module purge
module use /work2/02441/bcash/frontera/spack-stack/envs/ufs-weather-model.frontera.intel/install/modulefiles/Core
module load stack-intel/19.1.1.217
module load stack-intel-mpi/2020.4.304
module load ufs-weather-model-env/1.0.0
module load nco

export CYLC_TASK_PARAM_mem="mem007"
export ROOT_DIR="/scratch1/02441/bcash/prototype-p8/two_year_ensemble.reduced_restart.744.x12.y16.cpn36.wg3.wt108"
export RUN_ROOT_DIR="${ROOT_DIR}/run"
export POST_ROOT_DIR="${ROOT_DIR}/post"
export CYLC_TASK_PARAM_ldate=2012010100
export RESOL="C384"
#
export SFCF_VARS="prateb_ave cpratb_ave tmp2m tmpsfc spfh2m hpbl shtfl_ave lhtfl_ave gflux_ave dswrf_ave uswrf_ave dlwrf_ave ulwrf_ave dswrf_avetoa ulwrf_avetoa uswrf_avetoa icec icetk dtend_temp_lw dtend_temp_sw dtend_temp_pbl dtend_temp_deepcnv dtend_temp_shalcnv dtend_temp_mp dtend_temp_orogwd dtend_temp_cnvgwd dtend_temp_phys snod soilt1 soilt2 soilt3 soilt4 soilw1 soilw2 soilw3 soilw4 ugrd10m vgrd10m pressfc pwat tcdc_aveclm"
#
export ATMF_VARS="pressfc tmp hgtsfc"
#
export VINTRP_VARS="u v t w gh q"
#
export OCN_VARS="SST SSH SSS MLD_003 latent sensible SW LW"
if [[ -e launcher_tseries.sh ]]; then
    rm launcher_tseries.sh
fi

export POSTDIR=$POST_ROOT_DIR/$CYLC_TASK_PARAM_ldate/$RESOL/$CYLC_TASK_PARAM_mem
export TSDIR=$POSTDIR/tseries

if [[ ! -e $TSDIR ]]; then
    mkdir -p $TSDIR
fi

for vname in ${SFCF_VARS[@]}; do
    echo "ncrcat -7 -L 1 -O $POSTDIR/${vname}.sfcf??????.nc $TSDIR/${vname}.sfcf.tseries.nc" >> launcher_tseries.sh
done

for vname in ${ATMF_VARS[@]}; do
    echo "ncrcat -7 -L 1 -O $POSTDIR/${vname}.atmf??????.nc $TSDIR/${vname}.atmf.tseries.nc" >> launcher_tseries.sh
done

for vname in ${VINTRP_VARS[@]}; do
    echo "ncrcat -7 -L 1 -O $POSTDIR/isobaric.${vname}.GFSPRS.GrbF??????.nc $TSDIR/isobaric.${vname}.tseries.nc" >> launcher_tseries.sh
    echo "ncrcat -7 -L 1 -O $POSTDIR/N80.isobaric.${vname}.GFSPRS.GrbF??????.nc $TSDIR/N80.isobaric.${vname}.tseries.nc" >> launcher_tseries.sh
done

for vname in ${OCN_VARS[@]}; do
    echo "ncrcat -7 -L 1 -O $POSTDIR/${vname}.ocn_daily_????_??_??.nc $TSDIR/${vname}.ocn_daily.tseries.nc" >> launcher_tseries.sh
done

