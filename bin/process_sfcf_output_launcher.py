"""
Post-processing of grib and netcdf ufs s2swa files
"""
import os
import sys
import utils 
import xarray as xr

# Grib files are a minimum of 00, then go up with the total number of hours

def main():
    """
    Main program body
    """
    print("Initial hour to process ",os.environ['FHROT'])
    print("Final hour to process",os.environ['FHMAX'])

    vlist = sys.argv[1:]
    netcdf_indices=utils.file_index_gen(int(os.environ['FHROT']),int(os.environ['FHMAX']),6,3)
    byear, bmonth, bday, bhour, eyear, emonth, eday, ehour = utils.get_date_range_from_environment()

    out_indices=utils.date_index_gen(byear, bmonth, bday, bhour, eyear, emonth, eday, ehour, '6H')
    
    for count,netcdf_index in enumerate(netcdf_indices):
      for vname in vlist:
        print(os.environ['CYLC_TASK_PARAM_mem'], os.environ['CYLC_TASK_PARAM_ldate'], out_indices[count], netcdf_index, vname)
        netcdf_fname =  os.path.join(os.environ['RUNDIR'],"sfcf"+netcdf_index+".nc")
        subdir = os.environ['POSTDIR']+"/"+vname
        y = utils.get_subset(netcdf_fname, vname)
        utils.write_compressed_file(y, os.environ['POSTDIR'], os.environ['CYLC_TASK_PARAM_ldate'], 
            os.environ['CYLC_TASK_PARAM_mem'], vname, "sfcf", out_indices[count])

if __name__ == "__main__":
    main()
