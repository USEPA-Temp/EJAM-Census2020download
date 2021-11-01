#' @title Download Census 2020 data files from FTP
#' @description
#'   Warning: Code is not tested.
#'   Attempts to download data files for specified states
#'   from the US Census Bureau's FTP site for Decennial Census file data.
#'   see \url{https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf}
#' @param folder Default is getwd()
#' @param mystates Character vector of 2 letter abbreviations, now optional - Default is 50 states + DC + PR here
#' @seealso \link{census2020_read} \link{census2020_unzip}
#' @return Effect is to download and save locally a number of data files.
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
#' @export
census2020_download <-
  function(folder = getwd(), mystates) {
    if (!dir.exists(folder)) {
      dir.create(folder)
    }
    allstates <- c(tolower(state.abb), 'dc', 'pr')
    statelookup <- data.frame(ST=allstates, statename=c(state.name, 'District_of_Columbia', 'Puerto_Rico'))
    # VALIDATE STATES ###################
    if (missing(mystates)) {
      mystates <- allstates
    } else {
      mystates <- tolower(mystates)
      mystates <- mystates[mystates %in% allstates]
    }

    mystatenames <- statelookup[match(mystates, tolower(statelookup$ST)), 'statename']
    mystatenames <- gsub(' ', '_', mystatenames)

    # print(mystates)
    #	SPECIFY URL AND ZIPFILE NAME ######
    zipnames <- paste((mystates),'2020.pl.zip',sep = '')
    zipfile.fullpaths <- paste('https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/',mystatenames, '/', zipnames, sep = '')
    # print(zipfile.fullpaths)

    # DOWNLOAD ###################

    for (statenum  in 1:length(mystates)) {
      if (!file.exists(file.path(folder, zipnames[statenum]))) {
        x <- try(download.file(zipfile.fullpaths[statenum], destfile = file.path(folder, zipnames[statenum])))
# do not download if already there.
      }

      # for (tablenum in 1:length(tables)) {
      # unzip
      # } # end of for loop over table files such as 01, 02, 03, 04

    } # end of for loop over states

    ################# #
    # VERIFY ALL FILES WERE DOWNLOADED?
    # BUT THIS DOESN'T CHECK IF ZIP FILE IS CORRUPT/VALID (other than checking for size 0 above)
    # note count of downloaded zip files should be
    # length(stateabbs) * length(tables)
    #if (length(stateabbs) * length(tables) > length(dir(pattern="zip")) ) { print("please check count of zip files downloaded") }
  }
