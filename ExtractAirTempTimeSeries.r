#extract values from mean daily temperature netcdf

# 1) load dependencies
    #libraries
        library(ncdf4) # package for netcdf manipulation
        library(raster) # package for raster manipulation
        library(rgdal) # package for geospatial analysis
        library(ggplot2) # package for plotting

    #functions
        source(list.files(file.path( "Code", 'Functions'), full.names=TRUE))

# 2) Open netcdf and create some baic outputs to confirm it is as expected
    nc_data <- nc_open("Data/tg_ens_mean_0.1deg_reg_v19.0eHOM.nc")
    # Save the print(nc) dump to a text file
        sink('Outputs/tg_ens_mean_0.1deg_reg_v19.0eHOM_metadata.txt')
            print(nc_data)
        sink()
    
    #example plot of data
        lat <- ncvar_get(nc_data, "latitude")
        lon <- ncvar_get(nc_data, "longitude")
        tempExample <- ncvar_get( nc_data, start=c( 1,1, 1), count=c(length(lon), length(lat), 1))

        r <- raster(t(tempExample), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
        r <- flip(r, direction='y')
        
        jpeg("Figures/TemperatureExamplePlot")
            plot(r)
        dev.off()

# 3) load our site dataframe with cordiantes
    #for now an example
    coords_df<-data.frame(SiteID=c("Abc1", "Code2"), Latitude=c(40, 45), Longitude=c(0, 20))

# 4) extract time series
    timeSeries_mat<-extractNetcdfTimeSeries(openNc=nc_data, coords_df=coords_df)

# 5) save time series
    saveRDS(file="Outputs/TempTimeSeriesForSites.RDS", timeSeries_mat)



