#### tag2mps - CONVERT TAG LM FILES TO MPS
#' @name tag2mps
#' @title tag2mps
#'
#' @description
#'   Converts several landmark TAG files (from the software MINC toolkit) to *.mps files.
#'
#' @usage
#'   tag2mps(files = NULL, dir = NULL, ID = NULL)
#'
#' @param files an optional variable with a subset of TAG files in a directory
#' @param dir optional variable that selects the directory. the default (NULL) is the current directory
#' @param ID optional vector with IDs for saving the *.mps files
#' @param propagated Optional argument indicating if the landmarks have been propagated (extra line). The default is FALSE.
#'
#' @details
#'   Imports multiple TXT files (without a header) with landmarks for each specimen and saves them as *.mps files.
#'
#' @author Marta Vidal-Garcia
#'
#' @examples
#'
#' tag2mps(files = NULL, ID = c("spec1", "spec2"))
#'
#' @export
#'

tag2mps <- function(files = NULL, dir = NULL, ID = NULL, propagated = FALSE) {
  if (is.null(dir) == TRUE) {
    path <- getwd()
    old_path <- getwd()
  } else {
    path <- dir
    old_path <- getwd()
    setwd(path)
  }
  if (is.null(files) == TRUE){
    files_list <- dir(getwd(), pattern = "*.tag")
  }
  else {
    files_list <- files
  }
  n_land <- vector("numeric", length=length(files_list))
  for (i in 1:length(files_list)){
    if (isTRUE(propagated) == TRUE){
      n_land[i] <- length(count.fields(files_list[[i]])) -4
    }
    else {
      n_land[i] <- length(count.fields(files_list[[i]])) -3 # doublecheck if this should be 3
    }
  }
  if (length(unique(n_land))!=1){
    stop("Specimens have different number of landmarks.")
  }
  arrayLMs <- array(data = NA, dim = c(n_land[1], 3, length(files_list)))
  dimnames(arrayLMs)[[3]] <- gsub(".tag", "", files_list)
  if (isTRUE(propagated) == TRUE){
    for (i in 1:length(files_list)){
      arrayLMs[,1,i] <- suppressWarnings(read.table(file = files_list[[i]], skip = 5, sep = " ", header=F))[, 1]
      arrayLMs[,2,i] <- suppressWarnings(read.table(file = files_list[[i]], skip = 5, sep = " ", header=F))[, 2]
      arrayLMs[,3,i] <- suppressWarnings(read.table(file = files_list[[i]], skip = 5, sep = " ", header=F))[, 3]
    }
  }
  else{
    for (i in 1:length(files_list)){
      arrayLMs[,1,i] <- suppressWarnings(read.table(file = files_list[[i]], skip = 4, sep = " ", header=F))[, 2]
      arrayLMs[,2,i] <- suppressWarnings(read.table(file = files_list[[i]], skip = 4, sep = " ", header=F))[, 3]
      arrayLMs[,3,i] <- suppressWarnings(read.table(file = files_list[[i]], skip = 4, sep = " ", header=F))[, 4]
    }
  }

  if (is.null(ID) == TRUE) {
    dimnames_mps <- dimnames(arrayLMs)[[3]]
  } else {
    dimnames_mps <- ID
  }
  if (is.null(dimnames_mps) == TRUE) {
    stop("There are no ID names for saving the *.mps files")
  }
  if (length(dimnames_mps) != dim(arrayLMs)[3]) {
    stop("ID vector has different length than the number of specimens in the landmark array.")
  }
  for (i in 1:dim(arrayLMs)[3]){
    file_mps <- file(paste0(dimnames_mps[i], ".mps"))
    min_x <- min(arrayLMs[,1,i])
    min_y <- min(arrayLMs[,2,i])
    min_z <- min(arrayLMs[,3,i])
    max_x <- max(arrayLMs[,1,i])
    max_y <- max(arrayLMs[,2,i])
    max_z <- max(arrayLMs[,3,i])
    landmarks <- character()
    for (j in 1:dim(arrayLMs)[1]){
      landmarks <- c(landmarks, "            <point>", paste0("                <id>", (j-1), "</id>"),
                     "                <specification>0</specification>", paste0("                <x>", arrayLMs[j,1,i], "</x>"),
                     paste0("                <y>", arrayLMs[j,2,i], "</y>"),
                     paste0("                <z>", arrayLMs[j,3,i], "</z>"), "            </point>")
    }
    writeLines(c('<?xml version="1.0" encoding="UTF-8" ?>', "<point_set_file>", "    <file_version>0.1</file_version>",
                 "    <point_set>", "        <time_series>","            <time_series_id>0</time_series_id>",
                 '            <Geometry3D ImageGeometry=\"false\" FrameOfReferenceID=\"0\">',
                 '                <IndexToWorld type="Matrix3x3" m_0_0="1" m_0_1="0" m_0_2="0" m_1_0="0" m_1_1="1" m_1_2="0" m_2_0="0" m_2_1="0" m_2_2="1" />',
                 '                <Offset type=\"Vector3D\" x=\"0\" y=\"0\" z=\"0\" />', "                <Bounds>",
                 paste0('                    <Min type="Vector3D" x=', '"', min_x, '"', ' y=', '"', min_y, '"', ' z=', '"', min_z,'"',  ' />'),
                 paste0('                    <Max type="Vector3D" x=', '"', max_x, '"', ' y=', '"', max_y, '"', ' z=', '"', max_z, '"', ' />'),
                 "                </Bounds>", "            </Geometry3D>", landmarks,
                 "        </time_series>", "    </point_set>", "</point_set_file>"), file_mps)
    close(file_mps)
    rm(landmarks, file_mps)
  }
  setwd(old_path)
}
