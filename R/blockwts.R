#' @name blockwts2020
#' @docType data
#' @title 2020 Decennial Census block group weights
#' 
#' @description 
#'   A data.table with    blockwt, and 
#'   blockid or blockfips, 
#'   bgid or bgfips
#'   used by doaggregate() to summarize the block group score of the 
#'   average person in the buffer, as the population weighted mean
#'   of blockgroup scores of all the blocks in the buffer.
#'   
#' @details  This is drawn from blocks2020 dataset 
#' 
#'  \preformatted{
#'   blockfips is the 15 character Census Bureau FIPS code for each Census block
#'   blockid will be a unique integer ID 1 through total number of blocks, 
#'     to be used as a more efficient indexing than a FIPS code is.
#'   
#'   bgfips from blocks2020 is the 12 character Census Bureau FIPS code 
#'     for the parent blockgroup (i.e., the one containing the given block).
#'     and bgfips is used to join to a blockgroup dataset to get indicator scores.
#'   bgid will be a unique integer ID 1 through total number of unique blockgroups,
#'     to be used as a more efficient indexing than a FIPS code is.
#'   
#'   blockwt is the block's population weight, 
#'   calculated as the block population as a fraction of the parent blockgroup pop.
#'   Based on the latest decennial Census table of population count for each block.
#' 
#'   This table of weights can be used for calculating the 
#'   weighted mean or sum of each blockgroup score for a buffer 
#'   where only some blocks of any given blockgroup are in the buffer.
#'   The sum of weights from some blocks tells you 
#'   what fraction of its whole parent blockgroup's population count
#'   is in those blocks (the ones found inside a buffer, for example).
#'  }
#'
#'   See \url{https:\\www.epa.gov\ejscreen}
NULL
