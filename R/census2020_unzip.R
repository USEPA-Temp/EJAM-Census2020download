#' unzip Census 2020 zipped files already downloaded
#'
#' @description
#'   Warning: Code is not tested.
#'   Attempts to read files already downloaded and unzipped, data files for specified states
#'   from the US Census Bureau's FTP site for Decennial Census file data.
#'   see \url{https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf}
#'
#' @param folder path to where zip files are, default is working directory
#' @param folderout path to where you want to put files, created if does not exist
#' @param filenumbers a vector with any or all of 1,2,3 --
#'   default is file 1.
#'   File01 has Tables P1 and P2, which have population counts by race ethnicity.
#'   File02 has Tables P3, P4, and H1.
#'   File03 has Table P5.
#' @param mystates optional vector of 2letter state abbreviations for which to unzip
#'
#' @seealso \link{census2020_download} \link{census2020_read}
#' @return Vector of filenames of unzipped contents
#' @export
#' @examples \dontrun{
#'  library(census2020download)
#'  census2020_download('./census2020zip', mystates = c('MD', 'DC'))
#'  census2020_unzip('./census2020zip','./census2020out')
#'  c2 <- census2020_read(folder = './census2020out', mystates = c('MD', 'DC'))
#'  save(c2,file = 'census2020blocks.rdata')
#'  dim(c2)
#'  str(c2)
#'  head(c2)
#'  sum(c2$POP100)
#'  plot(c2$INTPTLON[substr(c2$GEOCODE,1,2)=='24'], c2$INTPTLAT[substr(c2$GEOCODE,1,2)=='24'], pch='.')
#'  }
census2020_unzip <- function(folder='.', folderout=folder, filenumbers=1, mystates) {
  # not filenumbers=1:3
  if (!dir.exists(folderout)) {
    dir.create(folderout)
  }

  if (missing(mystates)) {
    zipfiles <- list.files(folder, pattern = '2020.pl.zip')
    mystates <- substr(zipfiles,1,2)
  } else {
    mystates <- tolower(mystates)
    zipfiles <- paste(mystates, '2020.pl.zip', sep = '')
  }

  allfiles <- vector()
  for (statenum  in 1:length(mystates)) {
    tablefiles <- paste(mystates[statenum], '0000', filenumbers, '2020.pl', sep = '')
    tablefiles <- c(tablefiles, paste(mystates[statenum], 'geo2020.pl',sep = ''))
    # print(tablefiles)
    # al000012020.pl
    # al000022020.pl
    # al000032020.pl
    # algeo2020.pl

    zipfolderfile <- file.path(folder, zipfiles[statenum])
    if (!file.exists(zipfolderfile)) {stop(paste0('Cannot find file', zipfolderfile))}
    unzip(zipfolderfile, files = tablefiles, exdir = folderout)
    cat(zipfolderfile, ' has ', paste(tablefiles, collapse = ', '), '\n')
    allfiles <- c(allfiles, tablefiles)
  }
return(allfiles)
}
