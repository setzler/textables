
#' Function to begin LaTeX document
#'
#' @description
#' This function begins a LaTeX document.
#'

document_begin <- function() {
  return(c(
    "\\documentclass{article}",
    "\\usepackage{booktabs}",
    "\\usepackage{graphicx}",
    "\\usepackage[margin=1in]{geometry}",
    "\\begin{document}"
  ))
}

#' Function to end LaTeX document
#'
#' @description
#' This function ends a LaTeX document.
#'

document_end <- function() {
  return("\\end{document}")
}


#' Function to end LaTeX document
#'
#' @description
#' This function ends a LaTeX document.
#' 
#' @param tabular A tabular object in LaTeX.
#' @param filename Name of file (ending in .tex).
#' @param stand_alone Allows the tabular to be compiled directly by latex.
#'

write_tex <- function(tabular,filename,stand_alone=F){
  if(stand_alone){
    tabular <- c(document_begin(), tabular, document_end())
  }
  openfile <- file(filename)
  writeLines(tabular, openfile)
  close(openfile)
  return(NULL)
}



