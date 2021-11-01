#' clean up download block data
#'
#' @param x data from census2020_read()
#'
#' @return same as input but drops some columns, renames some columns, etc.
#' @export
#'
census2020_clean <- function(x) {

  # THIS IS PART OF HOW I CLEANED UP THE RESULTS OF census2020_read()
  # TO CREATE THE blocks2020.rdata DATASET IN THIS PACKAGE

  # get rid of these variables - do not really need them
  x$LOGRECNO <- NULL
  x$POP100 <- NULL

  # change to friendlier variable names
  colnames(x) <- census_col_names_map$Rname[match(colnames(x), census_col_names_map$ftpname)]

  # get rid of these variables - do not really need them
  x$nonhisp <- NULL
  x$nhalone <- NULL

  ## You could plot the US using these block points:
  # here <- sample(1:nrow(x),10^5)
  # plot(x$lon[here], x$lat[here], pch='.', xlim = c(-180,-60)) # map looks bad if you include the tiny bit of AK that is around +179 instead of -179 longitude

  ## confirmed race ethnic subgroups add up to pop total count exactly in every block:
  # sum_across_groups = rowSums(x[,c('hisp', 'nhwa' , 'nhba','nhaiana','nhaa','nhnhpia', 'nhotheralone', 'nhmulti')])
  # all.equal(sum_across_groups, x$pop)

  # x$ST <- ejanalysis::get.state.info(substr(x$fipsblock,1,2), fields = 'ST')$ST # slow but works
  x$ST <- lookup_states$ST[match(substr(x$fipsblock,1,2), lookup_states$FIPS.ST)]

  # Then can save with some or all of these columns.

  return(x)
}


