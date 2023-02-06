"""
Post-processing of grib and netcdf ufs s2swa files
"""
import os
from cdo import Cdo
import utils

# Grib files are a minimum of 00, then go up with the total number of hours

def main():
    """
    Main program body
    """
    cdo = Cdo()
    cdo.setCdo(os.path.join(os.environ['WORK'],"bin","cdo"))

    print("Initial hour to process ",os.environ['FHROT'])
    print("Final hour to process",os.environ['FHMAX'])
    vlist = os.environ['ATMF_VARS'].split(" ")

    netcdf_indices=utils.file_index_gen(int(os.environ['FHROT']),int(os.environ['FHMAX']),6,3)
    out_indices=utils.file_index_gen(int(os.environ['FHROT']),int(os.environ['FHMAX']),6,6)
    
    for count,netcdf_index in enumerate(netcdf_indices):
        for vname in vlist:
            print(os.environ['CYLC_TASK_PARAM_ldate'], os.environ['CYLC_TASK_PARAM_mem'], netcdf_index, vname)
            netcdf_fname =  os.path.join(os.environ['RUNDIR'],"atmf"+netcdf_index+".nc")
            subset_fname = os.path.join(os.environ['POSTDIR'],vname+".atmf"+out_indices[count]+".nc")
            gmean_fname = os.path.join(os.environ['POSTDIR'],"gmean."+vname+".atmf"+out_indices[count]+".nc")
            darray = utils.get_dataarray(netcdf_fname, 'netcdf', vname)
            darray.to_netcdf(subset_fname, unlimited_dims='time')
            gmean = cdo.fldmean(input=subset_fname, output=gmean_fname)
if __name__ == "__main__":
    main()
