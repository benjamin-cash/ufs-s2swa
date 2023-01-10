"""
Post-processing of grib and netcdf ufs s2swa files
"""
import os

import xarray as xr
from cdo import Cdo

# Grib files are a minimum of 00, then go up with the total number of hours

def file_index_list(cstart,cend,step,pad):
    """
    Function to take in the chunk of output hours to process and create a list of
    hours to process padded to the appropriate length of the file type
    """

    intlist = list(range(cstart, cend+1,step))
    padlist = [str(item).zfill(pad) for item in intlist]
    return padlist

def get_xr_dataarray(fname, ftype, vname):
    """
    Function takes in the path to a file and returns an xarray dataset
    """
    if ftype == 'grib':
        variable_filter={'filter_by_keys':{'typeOfLevel': 'isobaricInhPa', 'shortName': vname}}
        fhandle = xr.open_dataset(fname, backend_kwargs=variable_filter, \
            engine='cfgrib').rename({'isobaricInhPa':'plev'})
    elif ftype == 'netcdf':
        fhandle = xr.open_dataset(fname, engine='netcdf4')[vname]
    return fhandle

def open_netcdf_dataset(fname):
    '''
    Function take the path to a netcdf file and returns an xarray dataset
    '''
    fhandle = xr.open_dataset(fname, engine='netcdf4')
    return fhandle


def main():
    cdo = Cdo()
    cdo.setCdo(os.path.join(os.environ['WORK'],"bin","cdo"))

    print("Initial hour to process ",os.environ['FHROT'])
    print("Final hour to process",os.environ['FHMAX'])

    weights_fname=os.path.join(os.environ['WORK'],"regrid","C384.to.N80.weights.nc")
    grib_indices=file_index_list(int(os.environ['FHROT']),int(os.environ['FHMAX']),6,2)
    netcdf_indices=file_index_list(int(os.environ['FHROT']),int(os.environ['FHMAX']),6,3)
    out_indices=file_index_list(int(os.environ['FHROT']),int(os.environ['FHMAX']),6,6)
    grib_vlist = ["u", "v",  "t",  "w", "gh", "q"] 
    
    for count,grib_index in enumerate(grib_indices):
        for grib_vname in grib_vlist:
            print(os.environ['CYLC_TASK_PARAM_ldate'], os.environ['CYLC_TASK_PARAM_mem'], grib_index, grib_vname)
            grib_fname_in = os.path.join(os.environ['RUNDIR'],"GFSPRS.GrbF"+grib_index)
            darray = get_xr_dataarray(grib_fname_in, 'grib', grib_vname)
            isobaric_fname = \
            os.path.join(os.environ['POSTDIR'],"isobaric."+grib_vname+".GFSPRS.GrbF"+out_indices[count]+".nc")
            N80_isobaric_fname = \
            os.path.join(os.environ['POSTDIR'],"N80.isobaric."+grib_vname+".GFSPRS.GrbF"+out_indices[count]+".nc")
            darray.to_netcdf(isobaric_fname)
            N80 = cdo.remap("N80,"+weights_fname, input=isobaric_fname, output=N80_isobaric_fname)
    
    netcdf_vname = "prateb_ave"
    for count,netcdf_index in enumerate(netcdf_indices):
        print(os.environ['CYLC_TASK_PARAM_ldate'], os.environ['CYLC_TASK_PARAM_mem'], netcdf_index)
        netcdf_fname =  os.path.join(os.environ['RUNDIR'],"sfcf"+netcdf_index+".nc")
        darray = get_xr_dataarray(netcdf_fname, 'netcdf', netcdf_vname)
        darray.to_netcdf(os.path.join(os.environ['SCRATCH'],netcdf_vname+".sfcf"+out_indices[count]+".nc"), \
            unlimited_dims='time')

if __name__ == "__main__":
    main()
