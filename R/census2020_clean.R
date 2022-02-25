#' start to clean up download block data 
#'
#' Renames variables (columns) based on census_col_names_map
#'   Drops columns not needed. 
#'   Returns it in data.table format. 
#'   
#'   This is part of how the output of census2020_read() 
#'   can be cleaned up and split into smaller data files,
#'   to be used in EJAM. After this did script in blockdata_prep2020.R
#'   
#' @param x data from census2020_read()
#' @param cols_to_keep optional, which (renamed) columns to retain and return
#'
census2020_clean <- function(x, cols_to_keep=c('blockfips', 'lat', 'lon', 'pop')) {

  # # get rid of these variables - do not really need them
  # x$LOGRECNO <- NULL
  # x$POP100 <- NULL

  # change to friendlier variable names using data file that maps old to new names.
  
  colnames(x) <- census_col_names_map$Rname[match(colnames(x), census_col_names_map$ftpname)]

  # could Add 2-character abbreviation for State
  # x$ST <- lookup_states$ST[match(substr(x$blockfips,1,2), lookup_states$FIPS.ST)]

  # we will remove blocks with zero population since they are more than 1 in 4 blocks.
  # x <- c[x$pop != 0, ]  # 
  # wastes space, but might be simpler to 
  # keep them to ensure matches always found between sites2blocks$blockfips and blockwts$blockfips
  
  
  # keep only needed columns. Also were available:
  # arealand areawater housingunits
  # hisp nhwa nhba  nhaiana nhaa nhnhpia nhotheralone nhmulti
  ## confirmed race ethnic subgroups add up to pop total count exactly in every block:
  # but we will not use any of that here.
  # sum_across_groups = rowSums(x[,c('hisp', 'nhwa' , 'nhba','nhaiana','nhaa','nhnhpia', 'nhotheralone', 'nhmulti')])
  # all.equal(sum_across_groups, x$pop)
  # # get rid of these variables - do not really need them
  # x$nonhisp <- NULL
  # x$nhalone <- NULL
  
  
  if (!all(cols_to_keep %in% colnames(x))) {stop('some of specified column names are not available. Check census_col_names_map and columns added in this source code')}
  x <- x[ , cols_to_keep]

  x <- data.table::as.data.table(x, key = 'blockfips')

  return(x)
  
  ## You could plot the US using these block points:
  # here <- sample(1:nrow(x),10^5)
  # plot(x$lon[here], x$lat[here], pch='.', xlim = c(-180,-60)) # map looks bad if you include the tiny bit of AK that is around +179 instead of -179 longitude
  
  
}


