def file_index_gen(cstart,cend,step,pad):
    """
    Function to take in the chunk of output hours to process and create a list of
    hours to process padded to the appropriate length of the file type
    """

    intlist = list(range(cstart, cend+1,step))
    padlist = [str(item).zfill(pad) for item in intlist]
    return padlist

def date_index_gen(lbyear, lbmonth, lbday, leyear, lemonth, leday):
    """
    Function to take in the start and end date of a cycle and return a list 
    of dates in year_month_day format to process ocean files.
    """

    from datetime import date, timedelta
    import pandas as pd

    dlist = pd.date_range(date(lbyear,lbmonth,lbday),date(leyear,lemonth,leday)-timedelta(days=1), freq='d')
    return dlist.strftime('%Y_%m_%d').to_list()

def get_dataarray(fname, ftype, vname, levtype='isobaricInhPa'):
    """
    Function takes in the path to a file and returns an xarray dataset
    """
    import xarray as xr
    
    if ftype == 'grib':
        variable_filter={'filter_by_keys':{'typeOfLevel': levtype, 'shortName': vname}}
        fhandle = xr.open_dataset(fname, backend_kwargs=variable_filter, \
            engine='cfgrib').rename({levtype:'plev'})
    elif ftype == 'netcdf':
        fhandle = xr.open_dataset(fname, engine='netcdf4')[vname]
    return fhandle

