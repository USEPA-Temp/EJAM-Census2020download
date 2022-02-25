#' Compile Census 2020 block data for all US states once downloaded and unzipped
#'
#' @description
#'   Not tested. Works for file 1, but maybe not files 2 and 3.
#'   Attempts to read files already downloaded and unzipped, data files for specified states
#'   from the US Census Bureau's FTP site for Decennial Census file data.
#'   see \url{https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf}
#' @details see Census website for list of possible fields etc.
#'   \preformatted{
#'  File 1 has Table P1 and
#'   Table P2. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
#'  Universe: Total population
#'  P0020001 P0020002 P0020003 P0020004 P0020005 P0020006 P0020007 P0020008 P0020009 P0020010 P0020011 P0020012 P0020013 P0020014
#'  Total: P0020001
#'   Hispanic or Latino P0020002
#'  Not Hispanic or Latino: P0020003
#'   Population of one race: P0020004
#'   White alone P0020005
#'  Black or African American alone P0020006
#'  American Indian and Alaska Native alone P0020007
#'  Asian alone P0020008
#'  Native Hawaiian and Other Pacific Islander alone P0020009
#'  Some Other Race alone P0020010
#'  Population of two or more races: Population of two races: P0020011
#'
#'  }
#' @param folder path
#' @param filenumbers a vector with any or all of 1,2,3 --
#'   default is file 1.
#'   File01 has Tables P1 and P2.
#'   File02 has Tables P3, P4, and H1.
#'   File03 has Table P5.
#' @param mystates can be vector of 2-letter abbreviations of states
#' @param sumlev default is 750, for blocks
#' @param best_header_cols default is a few key columns like POP100, GEOCODE (fips), etc.
#' @param best_data_cols default is key race ethnicity fields
#' @seealso \link{census2020_download} \link{census2020_unzip}
#' @return data.frame of 1 row per block, for example
#' @export
#'
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
#'  c2$LOGRECNO <- NULL
#'  colnames(c2) <- census_col_names_map$Rname[match(colnames(blocks2020), census_col_names_map$ftpname)]
#'  }
census2020_read <- function(folder='.', filenumbers=1, mystates, sumlev=750, 
                            best_header_cols=c("LOGRECNO", "GEOCODE", 
                                               "AREALAND","AREAWATR", 
                                               "POP100", "HU100", 
                                               "INTPTLAT", "INTPTLON"), 
                            best_data_cols = paste0('P00', (20001:20011))) {
  # Gets census 2020 data
  #  based on code provided by the Census Bureau for reading and merging their raw data files
  
  if (missing(mystates)) {
    pl_files <- list.files(folder, pattern = 'geo2020.pl')
    mystates <- substr(pl_files,1,2)
  } else {
    mystates <- tolower(mystates)
  }
  mystates <- unique(mystates)
  
  # example of format of unzipped files (for files 1,2,3,geo), for Alabama (al)
  # al000012020.pl
  # al000022020.pl
  # al000032020v
  # algeo2020.pl
  
  t1files <- paste0(mystates, '0000', 1, '2020.pl')
  t2files <- paste0(mystates, '0000', 2, '2020.pl')
  t3files <- paste0(mystates, '0000', 3, '2020.pl')
  geofiles <- paste0(mystates, 'geo2020.pl')
  
  
  ######## ***SEE pl_all_4_2020_dar.R *** ##############
  header_file_path <- file.path(folder, geofiles) # ;print(header_file_path) #  algeo2020.pl  for alabama  in    al2020.pl.zip
  part1_file_path  <- file.path(folder, t1files)
  part2_file_path  <- file.path(folder, t2files)
  part3_file_path  <- file.path(folder, t3files)
  
  # *** SHOULD CHANGE THIS TO LIMIT IT TO READING ONLY THE NECESSARY COLUMNS, ******************
  
  # ---------------------------- -
  # Assign names to data columns  -from header (geo file) #####
  # ---------------------------- -
  #  FILEID        File Identification
  
  #  STUSAB        State/US-Abbreviation (USPS)
  
  #  SUMLEV        Summary Level   750=Census Block pl file
  #  GEOVAR        Geographic Variant
  #  GEOCOMP       Geographic Component
  #  CHARITER      Characteristic Iteration
  #  CIFSN         Characteristic Iteration File Sequence Number
  
  #  LOGRECNO      Logical Record Number
  
  #  GEOID         Geographic Record Identifier
  
  #  GEOCODE       Geographic Code Identifier
  #  REGION        Region
  #  DIVISION      Division
  #  STATE         State (FIPS)
  #  STATENS       State (NS)
  
  #  COUNTY        County (FIPS)
  #  COUNTYCC      FIPS County Class Code
  #  COUNTYNS      County (NS)
  #  COUSUB        County Subdivision (FIPS)
  #  COUSUBCC      FIPS County Subdivision Class Code
  #  COUSUBNS      County Subdivision (NS)
  #  SUBMCD        Subminor Civil Division (FIPS)
  #  SUBMCDCC      FIPS Subminor Civil Division Class Code
  #  SUBMCDNS      Subminor Civil Division (NS)
  #  ESTATE        Estate (FIPS)
  #  ESTATECC      FIPS Estate Class Code
  #  ESTATENS      Estate (NS)
  #  CONCIT        Consolidated City (FIPS)
  #  CONCITCC      FIPS Consolidated City Class Code
  #  CONCITNS      Consolidated City (NS)
  #  PLACE         Place (FIPS)
  #  PLACECC       FIPS Place Class Code
  #  PLACENS       Place (NS)
  #  TRACT         Census Tract
  #  BLKGRP        Block Group
  #  BLOCK         Block
  #  AIANHH        American Indian Area/Alaska Native Area/Hawaiian Home Land (Census)
  #  AIHHTLI       American Indian Trust Land/Hawaiian Home Land Indicator
  #  AIANHHFP      American Indian Area/Alaska Native Area/Hawaiian Home Land (FIPS)
  #  AIANHHCC      FIPS American Indian Area/Alaska Native Area/Hawaiian Home Land Class Code
  #  AIANHHNS      American Indian Area/Alaska Native Area/Hawaiian Home Land (NS)
  #  AITS          American Indian Tribal Subdivision (Census)
  #  AITSFP        American Indian Tribal Subdivision (FIPS)
  #  AITSCC        FIPS American Indian Tribal Subdivision Class Code
  #  AITSNS        American Indian Tribal Subdivision (NS)
  #  TTRACT        Tribal Census Tract
  #  TBLKGRP       Tribal Block Group
  #  ANRC          Alaska Native Regional Corporation (FIPS)
  #  ANRCCC        FIPS Alaska Native Regional Corporation Class Code
  #  ANRCNS        Alaska Native Regional Corporation (NS)
  #  CBSA          Metropolitan Statistical Area/Micropolitan Statistical Area
  #  MEMI          Metropolitan/Micropolitan Indicator
  #  CSA           Combined Statistical Area
  #  METDIV        Metropolitan Division
  #  NECTA         New England City and Town Area
  #  NMEMI         NECTA Metropolitan/Micropolitan Indicator
  #  CNECTA        Combined New England City and Town Area
  #  NECTADIV      New England City and Town Area Division
  #  CBSAPCI       Metropolitan Statistical Area/Micropolitan Statistical Area Principal City Indicator
  #  NECTAPCI      New England City and Town Area Principal City Indicator
  #  UA            Urban Area
  #  UATYPE        Urban Area Type
  #  UR            Urban/Rural
  #  CD116         Congressional District (116th)
  #  CD118         Congressional District (118th)
  #  CD119         Congressional District (119th)
  #  CD120         Congressional District (120th)
  #  CD121         Congressional District (121st)
  #  SLDU18        State Legislative District (Upper Chamber) (2018)
  #  SLDU22        State Legislative District (Upper Chamber) (2022)
  #  SLDU24        State Legislative District (Upper Chamber) (2024)
  #  SLDU26        State Legislative District (Upper Chamber) (2026)
  #  SLDU28        State Legislative District (Upper Chamber) (2028)
  #  SLDL18        State Legislative District (Lower Chamber) (2018)
  #  SLDL22        State Legislative District (Lower Chamber) (2022)
  #  SLDL24        State Legislative District (Lower Chamber) (2024)
  #  SLDL26        State Legislative District (Lower Chamber) (2026)
  #  SLDL28        State Legislative District (Lower Chamber) (2028)
  #  VTD           Voting District
  #  VTDI          Voting District Indicator
  #  ZCTA          ZIP Code Tabulation Area (5-Digit)
  #  SDELM         School District (Elementary)
  #  SDSEC         School District (Secondary)
  #  SDUNI         School District (Unified)
  #  PUMA          Public Use Microdata Area
  
  #  AREALAND      Area (Land)
  #  AREAWATR      Area (Water)
  
  #  BASENAME      Area Base Name
  #  NAME          Area Name-Legal/Statistical Area Description (LSAD) Term-Part Indicator
  #  FUNCSTAT      Functional Status Code
  #  GCUNI         Geographic Change User Note Indicator
  
  #  POP100        Population Count (100%)
  #  HU100         Housing Unit Count (100%)
  #  INTPTLAT      Internal Point (Latitude)
  #  INTPTLON      Internal Point (Longitude)
  
  #  LSADC         Legal/Statistical Area Description Code
  #  PARTFLAG      Part Flag
  #  UGA           Urban Growth Area
  # -----------------------------
  
  
  # new functionality in readr::read_   we could use instead of loop below:
  #
  #
  # Reading multiple files at once
  #
  # Edition two has built-in support for reading sets of files with the same columns into one output table in a single command.
  # Just pass the filenames to be read in the same vector to the reading function.
  #  we can efficiently read files into one tibble by passing the filenames directly to readr.
  #
  # part1  <- readr::read_delim(part1_file_path, col_names = part1_colnames, show_col_types = FALSE, delim = "|")
  # part1 <- part1[ , colnames(part1) %in% cols_needed]
  # readr::read_delim(files)
  
  header_col_names <- c("FILEID", "STUSAB", "SUMLEV", "GEOVAR", "GEOCOMP", "CHARITER", "CIFSN", "LOGRECNO", "GEOID",
                        "GEOCODE", "REGION", "DIVISION", "STATE", "STATENS",
                        "COUNTY", "COUNTYCC", "COUNTYNS", "COUSUB",
                        "COUSUBCC", "COUSUBNS", "SUBMCD", "SUBMCDCC", "SUBMCDNS", "ESTATE", "ESTATECC", "ESTATENS",
                        "CONCIT", "CONCITCC", "CONCITNS", "PLACE", "PLACECC", "PLACENS", "TRACT", "BLKGRP", "BLOCK",
                        "AIANHH", "AIHHTLI", "AIANHHFP", "AIANHHCC", "AIANHHNS", "AITS", "AITSFP", "AITSCC", "AITSNS",
                        "TTRACT", "TBLKGRP", "ANRC", "ANRCCC", "ANRCNS", "CBSA", "MEMI", "CSA", "METDIV", "NECTA",
                        "NMEMI", "CNECTA", "NECTADIV", "CBSAPCI", "NECTAPCI", "UA", "UATYPE", "UR", "CD116", "CD118",
                        "CD119", "CD120", "CD121", "SLDU18", "SLDU22", "SLDU24", "SLDU26", "SLDU28", "SLDL18", "SLDL22",
                        "SLDL24", "SLDL26", "SLDL28", "VTD", "VTDI", "ZCTA", "SDELM", "SDSEC", "SDUNI", "PUMA", "AREALAND",
                        "AREAWATR", "BASENAME", "NAME", "FUNCSTAT", "GCUNI", "POP100", "HU100", "INTPTLAT", "INTPTLON",
                        "LSADC", "PARTFLAG", "UGA")
  combinedstates <- NULL
  
  for (i in 1:length(mystates)) {
    
    cat(paste0('Reading ', toupper(mystates[i])), '\n')
    
    header <- try(readr::read_delim(header_file_path[i], col_names = header_col_names, show_col_types = FALSE, delim = "|"))
    if ("try-error" %in% class(header)) {print(header_file_path[i]); stop('cannot find or read file')}
    
    # KEEP ONLY BLOCKS NOT OTHER GEOGRAPHIES LIKE TRACT
    header <- header[header$SUMLEV == sumlev, ]
    
    # mergebycolnames <- c("LOGRECNO", "STUSAB", "FILEID", "CHARITER")
    mergebycolnames <- "LOGRECNO"
    
    # KEEP ONLY THE CRITICAL COLUMNS
    # cols_to_keep <- unique(c(mergebycolnames, bestcols))
    header <- header[, best_header_cols]
    cols_needed <- c(best_header_cols, best_data_cols)
    list_needed <- list(header[,names(header) != 'CIFSN'])#  list(header) # list(header[,-7]) # cifsn - they left it in table 3 only, but maybe I can keep it in the header only instead
    
    # print(head(header))
    # str(list_needed)
    # stop('that was geo header')
    
    if (1 %in% filenumbers) {
      part1_colnames <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                          paste0("P00", c(10001:10071, 20001:20073)))
      part1  <- readr::read_delim(part1_file_path[i], col_names = part1_colnames,show_col_types = FALSE, delim = "|")
      part1 <- part1[ , colnames(part1) %in% cols_needed]
      # cols_needed <- c(cols_needed, colnames(part1)[!(colnames(part1) %in% c('FILEID', 'STUSAB','CHARITER', "CIFSN" ,   "LOGRECNO" ))])
      list_needed <- c(list_needed, list(part1)) # try leaving that field in here
    }
    if (2 %in% filenumbers) {
      part2_colnames <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                          paste0("P00", c(30001:30071, 40001:40073)),
                          paste0("H00", 10001:10003))
      part2  <- readr::read_delim(part2_file_path[i], col_names = part2_colnames, show_col_types = FALSE,  delim = "|")
      cols_needed <- c(cols_needed, colnames(part2)[!(colnames(part2) %in% c('FILEID', 'STUSAB','CHARITER', "CIFSN" ,   "LOGRECNO"))])
      list_needed <- c(list_needed, list(part2[,names(part2)[!(names(part2) %in% 'CIFSN')]] ))
    }
    if (3 %in% filenumbers) {
      part3_colnames <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                          paste0("P00", 50001:50010))
      part3  <- readr::read_delim(part3_file_path[i], col_names = part3_colnames, show_col_types = FALSE,  delim = "|")
      cols_needed <- c(cols_needed, colnames(part3)[!(colnames(part3) %in% c('FILEID', 'STUSAB','CHARITER', "CIFSN" ,   "LOGRECNO"))])
      list_needed <- c(list_needed, list(part3))   #[,names(part3)[!(names(part3) %in% 'CIFSN')]] )) # seems like they did not remove that field from part3
    }
    # print('cols_needed'); print(cols_needed)
    # print('list_needed'); str(list_needed)
    
    # ---------------------------- -
    # Merge the data #######
    # ---------------------------- -
    combine <- Reduce(function(x,y) {merge(x, y, by=mergebycolnames)},
                      list_needed
    )
    
    # ---------------------------- -
    # Order the data #########
    # ---------------------------- -
    combine <- combine[order(combine$LOGRECNO) , ]
    rownames(combine) <- NULL
    combinedstates <- rbind(combinedstates, combine)
    # end of 1 state
  }
  return(combinedstates) # a SINGLE data.frame compilation of states and filenumbers
}
