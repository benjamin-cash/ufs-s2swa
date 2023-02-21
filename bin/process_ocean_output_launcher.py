"""
Post-processing of grib and netcdf ufs s2swa files
"""
import os
import sys
import xarray as xr
import utils

# Grib files are a minimum of 00, then go up with the total number of hours

def main():
    """
    Main program body
    """
    print("Initial hour to process ",os.environ['FHROT'])
    print("Final hour to process",os.environ['FHMAX'])
    vlist = sys.argv[1:]

    byear, bmonth, bday, bhour, eyear, emonth, eday, ehour = utils.get_date_range_from_environment()
    ocn_indices = utils.mom6_index_gen(byear, bmonth, bday, eyear, emonth, eday, "D")
    out_indices = utils.date_index_gen(byear, bmonth, bday, bhour, eyear, emonth, eday, ehour, 'D')

    for count,ocn_index in enumerate(ocn_indices):
        for vname in vlist:
            print(os.environ['CYLC_TASK_PARAM_mem'], os.environ['CYLC_TASK_PARAM_ldate'], out_indices[count],
                ocn_index, vname)
            netcdf_fname =  os.path.join(os.environ['RUNDIR'],"ocn_daily_"+ocn_index+".nc")
            dset_in = xr.open_dataset(netcdf_fname, engine='netcdf4')
            y = dset_in[vname].to_dataset()
            utils.write_compressed_file(y, os.environ['POSTDIR'], os.environ['CYLC_TASK_PARAM_ldate'],
                os.environ['CYLC_TASK_PARAM_mem'], vname, "ocn_daily", out_indices[count])
if __name__ == "__main__":
    main()
