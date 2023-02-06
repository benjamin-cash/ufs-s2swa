"""
Post-processing of grib and netcdf ufs s2swa files
"""
import os

import xarray as xr
#import xesmf as xe

import utils

# Grib files are a minimum of 00, then go up with the total number of hours

def main():
    """
    Main program body
    """
    print("Initial hour to process ",os.environ['FHROT'])
    print("Final hour to process",os.environ['FHMAX'])
    vlist = os.environ['OCN_VARS'].split(" ")
    byear = int(os.environ['BYEAR'])
    bmonth = int(os.environ['BMONTH'])
    bday = int(os.environ['BDAY'])
    eyear = int(os.environ['EYEAR'])
    emonth = int(os.environ['EMONTH'])
    eday = int(os.environ['EDAY'])
    ocn_indices = utils.date_index_gen(byear,bmonth,bday,eyear,emonth,eday)
    
    for count,ocn_index in enumerate(ocn_indices):
        for vname in vlist:
            print(os.environ['CYLC_TASK_PARAM_ldate'], os.environ['CYLC_TASK_PARAM_mem'], ocn_index, vname)
            netcdf_fname =  os.path.join(os.environ['RUNDIR'],"ocn_daily_"+ocn_index+".nc")
            subset_fname = os.path.join(os.environ['POSTDIR'],vname+".ocn_daily_"+ocn_index+".nc")
            dset_in = xr.open_dataset(netcdf_fname, engine='netcdf4')
            darray = dset_in[vname] 
            darray.to_netcdf(subset_fname, unlimited_dims='time')
if __name__ == "__main__":
    main()
