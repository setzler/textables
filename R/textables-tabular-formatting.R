
#' Function to begin table within LaTeX document
#'
#' @description
#' This function begins a tabular within a LaTeX document.
#'
#' @param alignments This argument indicates the alignment to
#'  be used in each column and the vertical lines to insert.
#'  See https://en.wikibooks.org/wiki/LaTeX/Tables for more
#'  information (character).
#'

tabular_begin <- function(alignments) {
  if (!is.character(alignments)){
    stop(sprintf("Input `alignments` must be character but is %s.\n", class(alignments)))
  }
  return(paste0("\\begin{tabular}{", alignments, "}"))
}

#' Function to end tabular within LaTeX document
#'
#' @description
#' This function ends a table within a LaTeX document.
#'

tabular_end <- function() {
  return("\\end{tabular}")
}


#' Function to return toprule in LaTeX.
#'
#' @description
#' This function adds a toprule line in LaTeX.
#'

rule_top <- function() {
  return("\\toprule")
}



#' Function to return midrule in LaTeX.
#'
#' @description
#' This function adds a midrule line in LaTeX.
#'

rule_mid <- function() {
  return("\\midrule")
}


#' Function to return bottomrule in LaTeX.
#'
#' @description
#' This function adds a bottomrule line in LaTeX.
#'

rule_bottom <- function() {
  return("\\bottomrule")
}


#' Function to draw partial horizontal line in LaTeX.
#'
#' @description
#' This function draws horizontal lines across the columns specified.
#'
#' @param start The column where the line begins (numeric).
#' @param stop The column where the line ends (numeric).
#'

rule_mid_partial <- function(start, stop) {
  if (!is.numeric(start)){
    stop(sprintf("Input `start` must be character but is %s.\n", class(start)))
  }
  if (!is.numeric(stop)){
    stop(sprintf("Input `stop` must be character but is %s.\n", class(stop)))
  }
  return(sprintf("\\cline{%s-%s}", start, stop))
}





#' Function to begin table within LaTeX document
#'
#' @description
#' This function begins a tabular within a LaTeX document.
#'
#' @param alignments This argument indicates the alignment to
#'  be used in each column and the vertical lines to insert.
#'  See https://en.wikibooks.org/wiki/LaTeX/Tables for more
#'  information (character).
#'

tabular_topbottom <- function(tabular,alignments) {
  tabular = c(
    tabular_begin(alignments),
    tabular,
    tabular_end()
  )
  return(tabular)
}



#' Function to begin table within LaTeX document
#'
#' @description
#' This function begins a tabular within a LaTeX document.
#'
#' @param alignments This argument indicates the alignment to
#'  be used in each column and the vertical lines to insert.
#'  See https://en.wikibooks.org/wiki/LaTeX/Tables for more
#'  information (character).
#'

tabular_topbottom_pretty <- function(tabular,alignments) {
  tabular = c(
    tabular_begin(alignments),
    rule_top(),
    rule_mid(),
    tabular,
    rule_mid(),
    rule_bottom(),
    tabular_end()
  )
  return(tabular)
}


