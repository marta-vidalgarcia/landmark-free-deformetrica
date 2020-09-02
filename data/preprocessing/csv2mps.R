#### csv2mps - CONVERT CSV LM FILES TO MPS
#' @name csv2mps
#' @title csv2mps
#'
#' @description
#'   Converts several landmark CSV files to *.mps files.
#'
#' @usage
#'   csv2mps(files = NULL, dir = NULL, ID = NULL)
#'
#' @param files an optional variable with a subset of CSV files in a directory
#' @param dir optional variable that selects the directory. the default (NULL) is the current directory
#' @param ID optional vector with IDs for saving the *.mps files
#'
#' @details
#'   Imports multiple CSV files with landmarks for each specimen and saves them as *.mps files.
#'
#' @author Marta Vidal-Garcia
#'
#' @examples
#'
#' csv2mps(files = NULL, ID = c("spec1", "spec2"))
#'
#' @export
#'

csv2mps <- function(files = NULL, dir = NULL, ID = NULL){
  if (is.null(dir) == TRUE) {
    path <- getwd()
    old_path <- getwd()
  } else {
    path <- dir
    old_path <- getwd()
    setwd(path)
  }
  if (is.null(files) == TRUE){
    files_list <- dir(getwd(), pattern = "*.csv")
  }
  else {
    files_list <- files
  }
  arrayLMs <- array(numeric(),c(length(count.fields(files_list[1], skip = 1)), 3, length(files_list)))
  for (i in 1: length(files_list)){
    arrayLMs[,1,i] <- read.csv(files_list[i], header = T)[,1]
    arrayLMs[,2,i] <- read.csv(files_list[i], header = T)[,2]
    arrayLMs[,3,i] <- read.csv(files_list[i], header = T)[,3]
  }
  dimnames(arrayLMs)[[3]] <- gsub(".csv", "", files_list)

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
