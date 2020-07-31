### stl2vtk - FUNCTION TO BATCH-CONVERT STL meshes to VTK meshes

stl2vtk <- function(files = NULL, ID = NULL, vtk_path = NULL, print.progress = TRUE){
  if (is.null(files) == TRUE){
    files_list <- dir(getwd(), pattern = "*.stl")
  } else {
    files_list <- files
  }
  if (length(files_list) == 0){
    stop(paste0("Wrong directory. There are no PLY meshes to import."))
  }
  if (is.null(ID) == TRUE){
    ID_vtk <- substr(files_list,1,nchar(files_list)-4)
  } else {
    ID_vtk <- ID
  }
  if (isFALSE(length(files_list) == length(ID_vtk)) == TRUE){
    stop(paste0("The length of the ID vector does not match the length of
                mesh files to be converted."))
  }
  ply_path <- getwd()
  if (is.null(vtk_path) == TRUE){
    vtk_path <- getwd()
  } else {
    vtk_path <- vtk_path
  }
  pb <- txtProgressBar(1, length(files_list), style=3)
  for (i in 1:length(files_list)){
    temp_mesh <- Rvcg::vcgImport(files_list[i])
    freesurferformats::write.fs.surface.vtk(paste0(vtk_path, "/",
                                                   ID_vtk[i],".vtk"),
                                            t(temp_mesh$vb)[,1:3],
                                            t(temp_mesh$it)[,1:3])
    if (print.progress == TRUE) {
      setTxtProgressBar(pb, i)
    }
    rm(temp_mesh)
  }
}
