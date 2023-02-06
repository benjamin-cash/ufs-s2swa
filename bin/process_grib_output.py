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

    weights_fname=os.path.join(os.environ['WORK'],"regrid","C384.to.N80.weights.nc")
    
    grib_indices=utils.file_index_gen(int(os.environ['FHROT']),int(os.environ['FHMAX']),6,2)
    out_indices=utils.file_index_gen(int(os.environ['FHROT']),int(os.environ['FHMAX']),6,6)
    
    grib_vlist = os.environ['VINTRP_VARS'].split(" ")
    
    for count,grib_index in enumerate(grib_indices):
        for grib_vname in grib_vlist:
            print(os.environ['CYLC_TASK_PARAM_ldate'], os.environ['CYLC_TASK_PARAM_mem'], grib_index, grib_vname)

            grib_fname = os.path.join(os.environ['RUNDIR'],"GFSPRS.GrbF"+grib_index)
            isobaric_fname = \
            os.path.join(os.environ['POSTDIR'],"isobaric."+grib_vname+".GFSPRS.GrbF"+out_indices[count]+".nc")
            N80_isobaric_fname = \
            os.path.join(os.environ['POSTDIR'],"N80.isobaric."+grib_vname+".GFSPRS.GrbF"+out_indices[count]+".nc")
            
            darray = utils.get_dataarray(grib_fname, 'grib', grib_vname, "isobaricInhPa")
            darray.to_netcdf(isobaric_fname)
            N80 = cdo.remap("N80,"+weights_fname, input=isobaric_fname, output=N80_isobaric_fname)
    
if __name__ == "__main__":
    main()
