"""
Post-processing of grib and netcdf ufs s2swa files
"""
import os
import sys
from cdo import Cdo
import utils
import xarray as xr

# Grib files are a minimum of 00, then go up with the total number of hours

def main():
    """
    Main program body
    """
    cdo = Cdo()
    cdo.setCdo(os.path.join(os.environ['WORK'],"bin","cdo"))

    print("Initial hour to process ",os.environ['FHROT'])
    print("Final hour to process",os.environ['FHMAX'])

    weights_fname=os.path.join(os.environ['WORK'],"regrid","C384.to.N80.weights.nc")
    
    grib_indices=utils.file_index_gen(int(os.environ['FHROT']),int(os.environ['FHMAX']),6,2)
    byear, bmonth, bday, bhour, eyear, emonth, eday, ehour = utils.get_date_range_from_environment()
    out_indices=utils.date_index_gen(byear, bmonth, bday, bhour, eyear, emonth, eday, ehour, '6H')
    
    grib_vlist = sys.argv[1:]
    
    for count,grib_index in enumerate(grib_indices):
        for grib_vname in grib_vlist:
            print(os.environ['CYLC_TASK_PARAM_mem'], os.environ['CYLC_TASK_PARAM_ldate'], grib_index,
                out_indices[count], grib_vname)
            grib_fname = os.path.join(os.environ['RUNDIR'],"GFSPRS.GrbF"+grib_index)
            
            isobaric_fname= \
                os.path.join(os.environ['POSTDIR'],grib_vname,
                os.environ['CYLC_TASK_PARAM_ldate']+"."+os.environ['CYLC_TASK_PARAM_mem']+"."+"isobaric."+ \
                grib_vname+".GFSPRS."+out_indices[count]+".nc")
            
            if not os.path.isdir(os.environ['POSTDIR']+"/"+grib_vname):
                os.makedirs(os.environ['POSTDIR']+"/"+grib_vname)
            y = utils.get_dataarray(grib_fname, 'grib', grib_vname, "isobaricInhPa")
            y.to_netcdf(isobaric_fname, unlimited_dims='time',encoding={grib_vname:{"zlib": True, "complevel": 1}})
            
            N80_isobaric_fname = \
                os.path.join(os.environ['POSTDIR'],grib_vname,
                os.environ['CYLC_TASK_PARAM_ldate']+"."+os.environ['CYLC_TASK_PARAM_mem']+"."+"N80.isobaric."+ \
                grib_vname+".GFSPRS."+out_indices[count]+".nc")
            
            N80 = cdo.remap("N80,"+weights_fname, input=isobaric_fname, output=N80_isobaric_fname)
if __name__ == "__main__":
    main()
