#' @name quaddata
#' @docType data
#' @title quad tree data on locations of US Census blocks 
#' @seealso blockquadtree
#' @description 
#'   This has selected columns from Census block dataset.
#' \preformatted{
#' 
#'   Code that created blockdata, quaddata, blockquadtree:
#'     (also localtree has to be created during runtime. 
#'     cannot be saved as data file beforehand)
#'   
#'   blockdata <- 0
#'   quaddata <- blockdata[ , .(BLOCK_X, BLOCK_Z, BLOCK_Y, blockid)]
#'   blockquadtree <- SearchTrees::createTree(quaddata, treeType = "quad", dataType = "point")
#'   
#'   2020 data format:
#'   
#'   str(quaddata) 
#'   Classes ‘data.table’ and 'data.frame':	5806512 obs. of  4 variables:
#'      $ BLOCK_X: num  205 205 204 204 204 ...
#'    $ BLOCK_Z: num  2125 2125 2125 2126 2126 ...
#'    $ BLOCK_Y: num  -3334 -3334 -3334 -3334 -3334 ...
#'    $ blockid: int  1 2 3 4 5 6 7 8 9 10 ...
#'    - attr(*, ".internal.selfref")=<externalptr> 
#'      - attr(*, "year")= num 2020
#' }
#' 
NULL
