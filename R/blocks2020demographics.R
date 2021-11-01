#' Census 2020 block data for US - race ethnicity variables
#' @name blocks2020demographics
#' @docType data
#' @description
#'   see \url{https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf}
#' @details see Census website for details
#'   See \link{census2020_read} and
#'    \link{census_col_names_map} and \link{census2020_clean} for how this was created.
#'   \preformatted{
#'          fipsblock ST pop hisp nhwa nhba nhaiana nhaa nhnhpia nhotheralone nhmulti arealand areawater housingunits
#'  1 020130001001000 AK   0    0    0    0       0    0       0            0       0        0 107112112            0
#'  2 020130001001001 AK   0    0    0    0       0    0       0            0       0        0 162527154            0
#'  3 020130001001002 AK   0    0    0    0       0    0       0            0       0  5220020     50039            0
#'
#'  Has 15-digit FIPS code for each Census block,
#'  block population count,
#'  land and water area,
#'  housing units count,
#'  2-character State abbreviation,
#'  and a few race ethnicity variables that add up to population total:
#'  Count of Hispanic or Latino
#'  White alone (of one race), Not Hispanic or Latino
#'  Black or African American alone (of one race), Not Hispanic or Latino,
#'  etc.
#'  }
#'  See \link{census_col_names_map} for definitions.
#'
#'
NULL
