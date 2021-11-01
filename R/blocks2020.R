#' Census 2020 block data for US - a few useful variables
#' @name blocks2020
#' @docType data
#' @description
#'   see \url{https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf}
#' @details see Census website for details
#'   See \link{census2020_read} and
#'    \link{census_col_names_map} and \link{census2020_clean} for how this was created.
#'   \preformatted{
#'  Has 15-digit FIPS code for each Census block,
#'  block population count, and latitude, longitude of internal point.
#'          fipsblock ST      lat       lon pop
#'  1 020130001001000 AK 55.43308 -162.7241   0
#'  2 020130001001001 AK 55.28475 -163.0098   0
#'  3 020130001001002 AK 55.39261 -162.7549   0
#'
#'  }
#'
NULL
