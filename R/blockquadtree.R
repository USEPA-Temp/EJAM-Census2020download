#' @name blockquadtree
#' @docType data
#' @title quad tree format data on locations of US Census 2020 blocks
#' 
#' @description  Used to quickly find which of these block points
#'  are nearby a specified facility or site with circular buffer. 
#'  
#'  \preformatted{
#' 
#'   Formal class 'QuadTree' [package "SearchTrees"] with 7 slots
#'   ..@ ref      :<externalptr> 
#'   ..@ numNodes : int 5173
#'   ..@ dataNodes: int 3294
#'   ..@ maxDepth : int 7
#'   ..@ maxBucket: int 48705
#'   ..@ totalData: int 5806512
#'   ..@ dataType : chr "point"
#'   ..$ data  :<externalptr> 
#'   ..$ points: int 5806512
#'   ..$ year  : num 2020
#'   #  code in blockdata_prep2020, created quaddata and blockquadtree: 
#'   
#'   quaddata <- blockdata[ , .(BLOCK_X, BLOCK_Z, BLOCK_Y, blockid)]
#'   blockquadtree <- SearchTrees::createTree(quaddata, treeType = "quad", dataType = "point")
#'   
#'   }
NULL
