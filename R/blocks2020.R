#' Census 2020 block data for US - a few useful variables
#' @name blocks2020
#' @docType data
#' @description
#'   see \url{https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf}
#'   
#'   blocks2020 file has Puerto Rico but not Island Territories (USVI/Guam/Mariana/Samoa)
#'   With PR, sum(blocks2020$pop) is  334735155
#'   without Puerto Rico, sum(blocks2020$pop[blocks2020$ST != 'PR']) is 331449281
#'   which matches US Census 2020 population 331,449,281 found here: 
#'   \link{https://www.census.gov/quickfacts/fact/table/US/POP010220#POP010220}
#'   
#' @details see Census website for details
#'   See \link{census2020_read} and
#'    \link{census_col_names_map} and \link{census2020_clean} for how this was created.
#'   \preformatted{
#'   
#'  The 2020 Census blocks dataset here has these fields:
#'  
#'  blockfips 15-digit FIPS code for each Census block
#'    
#'  blockid may be included later, an integer unique ID to use as a key 
#'    (once compressed as .rda file, only slightly less disk space 
#'      if only keep blockid column not blockfips, but file size of .rda is 129.4 MB vs 133.9 MB, <5% cut)
#'      But memory usage is very different: about 218 MB instead of 717 MB:
#'    tables()
#'                NAME      NROW NCOL  MB                  COLS       KEY
#'   1:     blocks2020 8,174,955    4 717 blockfips,lat,lon,pop blockfips
#'   2: blocks2020byid 8,174,955    4 218   lat,lon,pop,blockid   blockid
#'  
#'  pop   block population count, and latitude, longitude of internal point
#'    from Decennial Census
#'    
#'  lat and lon are latitude and longitude of block internal point from Census, decimal degrees
#'    
#'  
#'  
#'  
#'  The 2010 blocks dataset had all these fields:
#'    # names(blockdata)
#'   [1] "BLOCKID"            "BLOCKGROUPFIPS"    ***
#'   [3] "STUSAB"             "STATE"             
#'   [5] "COUNTY"             "TRACT"             
#'   [7] "BLKGRP"             "BLOCK"             
#'   [9] "POP100"             "HU100"             ***
#'   [11] "INTPTLAT"           "INTPTLON"         *** 
#'   [13] "BLOCK_LAT_RAD"      "BLOCK_LONG_RAD"    
#'   [15] "BLOCK_X"            "BLOCK_Y"           
#'   [17] "BLOCK_Z"            "ID"                
#'   [19] "GRID_X"             "GRID_Y"            
#'   [21] "GRID_Z"             "Census2010Totalpop"
#'   
#'  }
#'  For details on FIPS, see 
#'  \url{https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html}
NULL
