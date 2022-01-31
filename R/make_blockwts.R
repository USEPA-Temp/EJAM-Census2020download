#' Make blockwts, the block weights table from decennial census pop counts
#'
#' @description This only has to be done once for the decennial Census, and saved as a dataset.
#'    Using a new decennial Census table of population count for each block, 
#'   calculate for each block its weight which is its pop as a fraction of the parent blockgroup pop.
#'   The resulting table of weights can be used for calculating the weighted mean of each blockgroup score
#'   for a buffer where only some blocks of any given blockgroup are in the buffer.
#'   The sum of weights from some blocks tells you what fraction of its whole parent blockgroup's population count
#'   is in those blocks (the ones found inside a buffer, for example).
#'   Need bgfips or bgid for join of these weights to bgstats, a blockgroup dataset to get indicator scores.
#'   
#'   Using integer blockid instead of blockfips and dropping blockfips column
#'   would reduce memory usage to about 1/3 as much. 
#'   
#'   This is used to take blocks2020.rda and create blockwts2020.rda files for packages.
#' 
#' @param blockfips Census Bureau FIPS code for each Census block, as 15-character string for each block
#' @param pop Population count in the block, per latest decennial census.
#' 
#' @return Returns a data.table  with blockfips (key), bgfips (secondary key), and blockwt columns.
#' @export
#'
#' @examples \dontrun{
#' blockwts <- make_blockwts(census2020download::blocks2020$blockfips, census2020download::blocks2020$pop)
#' attr(blockwts, 'year') <- 2020
#' saveRDS(blockwts2020, file = file.path(getwd(),'data/blockwts2020.rda'))
#' }
make_blockwts <- function(blockfips, pop) {
  
  blockwts <- data.table::data.table(blockfips=blockfips, pop=pop)
  blockwts[ , bgfips := substr(blockfips, 1, 12)] # bgfips has 12 characters
  #blockwts[ , bgid    := seq_along(unique(bgfips)), by=bgfips] 
  #blockwts[ , blockid := seq_along(blockfips)] 
  # then should save just 
  
  data.table::setkey(blockwts, key = c('blockfips', 'bgfips')) # alters data.frame by reference to use it as a data.table without making a copy of it. invisibly returns dt
  blockwts[ , parentbgpop := sum(pop), by=bgfips]
  blockwts[ , blockwt := pop / parentbgpop]
  blockwts[is.na(blockwt), blockwt := 0]   # check that this fixes division by zero when parentbgpop is 0
  
  return(blockwts[ , c('blockfips', 'bgfips', 'blockwt')]) 
  # return(blockwts[ , c('blockid', 'bgfips', 'blockwt')]) # 
  # blockid and maybe bgid -- may add those later to optimize memory usage
  # blockid is more efficient than blockfips, and can just use blockid to join sites2blocks and blockwts,
  # if retain blocks2020id2fips as the way to get back to full blockfips.
  # Keeping just bgid and dropping bgfips is an idea, but then bgstats has to have bgid too, 
  # and it is easier to have bgstats use just bgfips?
}
       