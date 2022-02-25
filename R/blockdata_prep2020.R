blockdata_prep2020 <- function(dt, vintage = 2020) {
  
  # This (SCRIPT) was used to clean up Census block data to use in EJAM 
  #  e.g. after census2020_download, _unzip, _read, _clean
  # and could use for 2010 Census also
  
  ############################################################################### #
  # Notes on the tables created here, saved as .rda files  ####
  #
  # blockquadtree, quaddata, blockid2fips, blockwts 
  # 
  # Also might want to save elsewhere something with all these in 1 file:
  # blockfips, blockid; lat, lon ; blockwt; 
  # blockpop; bgfips, bgid?.  Such as was in blocks2020.rda 
  # 
  # And might even want to save elsewhere more columns, as in the blockdata table up to 2/2022:
  # blockfips, blockpop2010, 
  # bgfips, bgpop2010, blockwt,
  # INTPTLAT, INTPTLON,  BLOCK_LAT_RAD, BLOCK_LONG_RAD  
  # BLOCK_X, BLOCK_Y, BLOCK_Z ID,    GRID_X, GRID_Y, GRID_Z 
  # STUSAB 
  ############################################################## #
  
  
# see blockdata-package for the 2010 datasets
  
  ############################################################## #
  # The Census 2020 data:#########################
  #
  #    > round(file.info(list.files())[,1,drop=F]/1e6,1)
  #               approx MB file size
  # quaddata.rda             125.2
  # blockwts.rda              29.0
  # blockid2fips.rda          15.8
  # blockquadtree.rda          0.0

  #  head(blockid2fips,2); str(blockid2fips)
  #  head(quaddata,2); str(quaddata)
  #  str(blockquadtree,2)
  #  head(blockwts,2); str(blockwts)
  ## head(blockpoints,2); str(blockpoints)
  
  # > head(blockid2fips)
  #    blockid       blockfips
  # 1:       1 010010201001000
  # 2:       2 010010201001001
  
  # > str(blockid2fips)
  # Classes ‘data.table’ and 'data.frame':	5806512 obs. of  2 variables:
  #   $ blockid  : int  1 2 3 4 5 6 7 8 9 10 ...
  #   $ blockfips: chr  "010010201001000" "010010201001001" "010010201001002" "010010201001003" ...
  #   - attr(*, ".internal.selfref")=<externalptr> 
  #   - attr(*, "sorted")= chr [1:2] "blockid" "blockfips"
  #   - attr(*, "year")= num 2020
  
  # > head(quaddata)
  #     BLOCK_X  BLOCK_Z   BLOCK_Y blockid
  # 1: 205.0423 2125.461 -3333.775       1
  # 2: 204.9796 2125.314 -3333.872       2
  #
  # > str(quaddata)
  # Classes ‘data.table’ and 'data.frame':	5806512 obs. of  4 variables:
  # $ BLOCK_X: num  205 205 204 204 204 ...
  # $ BLOCK_Z: num  2125 2125 2125 2126 2126 ...
  # $ BLOCK_Y: num  -3334 -3334 -3334 -3334 -3334 ...
  # $ blockid: int  1 2 3 4 5 6 7 8 9 10 ...
  #   - attr(*, ".internal.selfref")=<externalptr> 
  #   - attr(*, "year")= num 2020
  
  # > str(blockquadtree)
  # Formal class 'QuadTree' [package "SearchTrees"] with 7 slots
  # ..@ ref      :<externalptr> 
  # ..@ numNodes : int 5173
  # ..@ dataNodes: int 3294
  # ..@ maxDepth : int 7
  # ..@ maxBucket: int 48705
  # ..@ totalData: int 5806512
  # ..@ dataType : chr "point"
  # ..$ data  :<externalptr> 
  # ..$ points: int 5806512
  # ..$ year  : num 2020
  
  # > head(blockwts)
  #    blockid       bgfips    blockwt
  # 1:       1 010010201001 0.03652174
  # 2:       2 010010201001 0.05913043
  # 
  # > str(blockwts)
  # Classes ‘data.table’ and 'data.frame':	5806512 obs. of  3 variables:
  #   $ blockid: int  1 2 3 4 5 6 7 8 9 10 ...
  #   $ bgfips : chr  "010010201001" "010010201001" "010010201001" "010010201001" ...
  #   $ blockwt: num  0.0365 0.0591 0.0504 0.0296 0.0122 ...
  #   - attr(*, ".internal.selfref")=<externalptr> 
  #   - attr(*, "sorted")= chr [1:2] "blockid" "bgfips"
  #   - attr(*, "year")= num 2020
  
  # > str(blockpoints)  *******  NOT ACTUALLY SAVED YET IN PACKAGE ****
  # 
  # Classes ‘data.table’ and 'data.frame':	xxxxx obs. of  3 variables:
  # $ blockid: int  1 2 3 4 5 6 7 8 9 10 ...
  # $ lat    : num  xxx
  # $ lon    : num  xxxx
  #   - attr(*, ".internal.selfref")=<externalptr> 
  #   - attr(*, "sorted")= chr [1:3] "blockid" "lat" "lon"
  #   - attr(*, "year")= num 2020
  ############################################################## #
  
  
  
  
  # start ###########
  
  if (!data.table::is.data.table(dt)) {data.table::setDT(dt)}
  blocks <- data.table::copy(dt) # make a copy just in case, to preclude inadvertently altering by reference the original data.table that was passed to this function via dt.
  rm(dt); gc()
  
  ############################################################################### #
  #  VINTAGE #### 
  #                                             vintage <- 2020 
  data.table::setattr(blocks, 'year', vintage)
  
  ############################################################################### #
  ##  Notes on vintage: 2010 vs 2020 Census block boundaries and FIPS ####
  # 
  # *** PROBLEM trying to use Census 2020 dataset before EJSCREEN adopts it: 
  # Not exactly right to use Census 2020 weights and lat/lon for buffering unless EJSCREEN does too.
  # Many of the CENSUS 2020 GEOGRAPHIC boundaries and also a few FIPS 
  # do not match those in EJSCREEN through Jan 2022; same with EJSCREEN 2.0 released Feb 2022. bg20, bg21.
  #
  # Boundaries changed: 
  #   Census 2020 more accurately reflects where people now live, 
  #   but bgstats from EJSCREEN represent the old boundaries of a bg and can differ from new ones. 
  #   Census 2010 vs 2020 boundaries are documented here: 
  #   https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.html#blkgrp
  #   https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.html#t10t20 
  # 
  # FIPS changed in Alaska: 
  #   Small problem in part of Alaska where buffering and/or getting bgstats 
  #   would fail using census 2020. 
  #   ****  One Alaska county FIPS (containing 11 blockgroups) in EJSCREEN through March 2022,
  #   is not in Census 2020: Valdez-Cordova Census Area, Alaska     bg20$FIPS.COUNTY == '02261'   
  #   population 9,301 per ACS 2014-2018
  #   **** TWO NEW Alaska COUNTIES with NINE blockgroups with 1,533 blocks 
  #   population 9,719 per Census 2020
  #   are in Census 2020  not in EJSCREEN through March 2022.
  #    c("02063", "02066")
  #   "020630002001" "020630002002" "020630003001" "020630003002" "020630003003" "020630003004" "020630003005" "020660001001" "020660001002"
  ############################################################################### #
  
  ############################################################################### #
  #  RENAME POPULATION FIELD  ----
  
  if (!('blockpop' %in% names(blocks))) {
    if ('pop' %in% names(blocks)) {
      data.table::setnames(x = blocks, old = 'pop', new = 'blockpop')
    } else {
      if ('POP100' %in% names(blocks)) {
        data.table::setnames(x = blocks, old = 'POP100', new = 'blockpop')
      } else {stop('assumes a column named pop or POP100')}
    }
  }
  # blocks[ , `:=`(pop = as.integer(pop))]
  
  ############################################################################### #
  #  DROP UNPOPULATED BLOCKS ----
  
  blocks <- blocks[blockpop != 0, ] 

  ############################################################################### #
  ##  Notes on dropping blocks with zero pop (no residents) ####
  #
  # In Census 2020:  1,393 blockgroups had 0 pop in every block, due to 12,922 of the 2,368,443 blocks with 0 pop.
  # We prob do not need to retain blockgroups with zero population in blocks datasets if they are in ejscreen/others, to ensure merges dont seem to have problems.
  # Not sure we want to keep or drop blocks with zero pop when at least other blocks in bg have pop
  # ...  Efficient to drop. complicated if have to retain zero pop blocks only when needed to have a blockgroup appear at all,
  # just cannot locate those block points in buffering, but 
  # cannot think of why they might be needed for proximity analysis of nearby residents (or find their zero wts)
  #
  # blocks[ , .(tot=sum(blockwt)), by=bgfips][,.(min=min(tot,na.rm = T), max=max(tot,na.rm = T), nas=sum(is.na(tot)))]
  # min max  nas    # 1:   1   1 1393
  # > dim(blocks)   # [1] 8174955       5
  # > blocks[ blockpop == 0, .N] # [1] 2368443
  # > blocks[ blockpop != 0, .N]   # [1] 5806512
  # > blocks[ is.na(blockpop), .N]   # [1] 0
  # > blocks[ is.na(blockpop), .N] / NROW(blocks)   # [1] 0
  # > blocks[ blockpop == 0, .N]/ NROW(blocks)   # [1] 0.2897194
  
  ############################################################################### #
  #  ADD blockid, bgfips COLUMNS ####
  
  # Census Bureau explanation of FIPS:
  # blockid: 15-character code that is the concatenation of fields consisting of the 
  # 2-character state FIPS code, the 
  # 3-character county FIPS code, [5 total define a county] the 
  # 6-character census tract code, [11 total define a tract] and the  
  #    [and 12 total define a blockgroup, which uses 1 digit more than a tract]
  # 4-character tabulation block code. [15 total define a block]
  
  blocks[, blockid := seq.int(length.out = NROW(blocks))] # used to be ID not blockid
  blocks[, bgfips := substr(blockfips, 1, 12)] # for merging blockgroup indicators to buffered blocks later on
  data.table::setkey(blocks, blockid, bgfips)
  
  ############################################################################### #
  #  CREATE WEIGHTS for blockwts data.table, with blockid blockwt bgfips ####
  #  where blockwt is the blocks share of parent blockgroup census pop count
  blocks[ , bgpop := sum(blockpop), by=bgfips] # Census count population total of parent blockgroup gets saved with each block temporarily
  blocks[ , bgpop := as.integer(bgpop)] # had to be in a separate line for some reason
  blocks[ , blockwt := blockpop / bgpop] # ok if the ones with zero population were already removed
  blocks[is.na(blockwt), blockwt := 0] 
  # In Census 2020:  1,393 blockgroups had 0 pop in every block, due to 12,922 of the 2,368,443 blocks with 0 pop.
  blockwts <- blocks[, .(blockid, bgfips, blockwt)]
  data.table::setkey(blockwts, blockid, bgfips)
  data.table::setattr(blockwts, 'year', vintage)
  
  ## Save blockwts  ####
  usethis::use_data(blockwts, overwrite = TRUE)
  # rm(blockwts); gc() 
  
  ############################################################################### #
  #  CREATE blockid2fips data.table, with blockid blockfips #### 
  blockid2fips <- data.table::copy(blocks)
  blockid2fips <- blockid2fips[ , .(blockid, blockfips)] # keep only 2 columns
  data.table::setkey(blockid2fips, blockid, blockfips)
  data.table::setattr(blockid2fips, 'year', vintage)
  
  ## Save blockid2fips  ####
  usethis::use_data(blockid2fips, overwrite = TRUE)
  # rm(blockid2fips); gc() 
  
  ############################################################################### #
  # CREATE  blockpoints, a data.table with blockid lat lon #### 
  # data.table::setnames(x = blocks, old = 'INTPTLAT', new = 'lat')
  # data.table::setnames(x = blocks, old = 'INTPTLON', new = 'lon')
  blockpoints <- blocks[, .(blockid, lat, lon)]
  data.table::setkey(blockpoints, blockid, lat, lon)
  data.table::setattr(blockpoints, 'year', vintage)

  ## Save blockpoints ?? not essential but nice to keep lat lon ####
  usethis::use_data(blockpoints, overwrite = TRUE)
  
  
  #  CREATE quaddata, blockquadtree for fast search for nearby block points ####
  #
  ########### convert blockdata lat lon to XYZ units ########## #
  earthRadius_miles <- 3959 # in case it is not already in global envt
  radians_per_degree <- pi / 180
  
  blockpoints[,"BLOCK_LAT_RAD"]  <- blockpoints$lat * radians_per_degree
  blockpoints[,"BLOCK_LONG_RAD"] <- blockpoints$lon * radians_per_degree
  coslat <- cos(blockpoints$BLOCK_LAT_RAD)
  blockpoints[,"BLOCK_X"] <- earthRadius_miles * coslat * cos(blockpoints$BLOCK_LONG_RAD)
  blockpoints[,"BLOCK_Y"] <- earthRadius_miles * coslat * sin(blockpoints$BLOCK_LONG_RAD)
  blockpoints[,"BLOCK_Z"] <- earthRadius_miles * sin(blockpoints$BLOCK_LAT_RAD)
  
  quaddata <- blockpoints[ , .(BLOCK_X, BLOCK_Z, BLOCK_Y, blockid)] # lowercase blockid now for new doaggregate
  
  rm(blockpoints); gc()
  
  # setnames(quaddata, old = 'blockid', new = 'BLOCKID') # getrelevant.... still expects upper case
  blockquadtree <- SearchTrees::createTree(quaddata, treeType = "quad", dataType = "point")
  data.table::setattr(quaddata, 'year', vintage)
  data.table::setattr(blockquadtree, 'year', vintage)
  
  ## Save quaddata, blockquadtree  ####
  usethis::use_data(quaddata, overwrite = TRUE)
  usethis::use_data(blockquadtree, overwrite = TRUE)

  ############################################################################### #
  
  # Return larger table invisibly? ####
  invisible(blocks)
  ############################################################################### #
  
}

