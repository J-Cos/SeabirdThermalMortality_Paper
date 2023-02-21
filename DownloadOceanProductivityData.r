
library(cdsapi)
library(httr)

dataset <- "satellite-ocean-colour"
months<-c("'month': ['01', '07'], ", "'month': ['04', '10'], ")
result<-list()
for (monthSubset in 1:length(months)) {
    request <- paste0("{
        'variable': 'mass_concentration_of_chlorophyll_a',
        'projection': 'regular_latitude_longitude_grid',
        'year': [
            '1998', '1999', '2000',
            '2001', '2002', '2003',
            '2004', '2005', '2006',
            '2007', '2008', '2009',
            '2010', '2011', '2012',
            '2013', '2014', '2015',
            '2016', '2017', '2018',
            '2019', '2020', '2021'
        ], ",
        months[monthSubset],
        "'day': '15',
        'version': '5_0_1',
        'format': 'tgz'
    }")

    result[[monthSubset]] <- cds_retrieve( dataset, request)
        # If timeout the following can be used to try again without generating new request
        while (is.na(result[[monthSubset]]$outfile)) {
            result[[monthSubset]] <- cds_retrieve( dataset, request, request_id = result[[monthSubset]]$request_id)
        }
}

