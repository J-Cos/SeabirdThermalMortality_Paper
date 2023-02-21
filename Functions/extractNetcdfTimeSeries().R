#a function to extract timeseries of values from the closest point to coordinates provided.
# expects a data frame with columns titles, SiteID, Latitude, and Longitude

# example 
    #coords_df<-data.frame(SiteID=c("Abc1", "Code2"), Latitude=c(40, 45), Longitude=c(0, 20))
    #timeSeries_mat<-extractNetcdfTimeSeries(openNc=nc_data, coords_df=coords_df)



extractNetcdfTimeSeries<-function (openNc, coords_df) {
    NumberOfSites<-dim(coords_df)[1]

    t <- ncvar_get(nc_data, "time")
    time <-as.Date(as.POSIXct(t*24*60*60, origin = "1950-01-01", tz="UTC"))
    NumberOfDays<-length(time)

    timeSeries_mat<-matrix(NA,NumberOfDays, NumberOfSites, dimnames=list(as.character(time), coords_df$SiteID))
    for (Site in 1:NumberOfSites) {
        LatId <- which.min( abs(nc_data$dim$lat$vals -coords_df[Site,"Latitude"] ))
        LonId <- which.min( abs(nc_data$dim$lon$vals -coords_df[Site, "Longitude"] ))
        timeSeries_mat[,Site] <- ncvar_get( nc_data, start=c( LonId, LatId, 1), count=c(1, 1, NumberOfDays))
    }

    return(timeSeries_mat)
}

