
#' Function to create title row in LaTeX document.
#'
#' @description
#' This function creates a title row in LaTeX.
#'
#' @param panel The name of the panel (character).
#' @param title The title of the row (character).
#' @param num (numeric).

row_header <- function(panel, title, num) {
  if (!is.character(panel)){
    stop(sprintf("Input `panel` must be character but is %s. \n", class(panel)))
  }
  if (!is.character(title)){
    stop(sprintf("Input `title` must be character but is %s. \n", class(title)))
  }
  if (!is.numeric(num)){
    stop(sprintf("Input `array` must be numeric but is %s. \n", class(num)))
  }
  return(paste0("\\textbf{", panel, "}"," & ",
                sprintf("\\multicolumn{%d}{c}{\\textbf{", num), title, "}} \\\\"))
}



#' Function to make a numerical row in LaTeX document
#'
#' @description
#' This creates a numerical row, with options to treat the row
#'  as a percentage, an estimate with number of stars 
#'  determined by p-value (to indicate significance),
#'  or wrapped in parentheses (like a standard error).
#'
#' @param title The name of the row (character).
#' @param array The array that will be formatted in the row (numeric).
#' @param dec The number of decimal places (numeric).
#' @param percentage (logical)
#' @param se (logical)
#' @param pvalues (numeric)
#' @param spacer LaTeX code for space between rows (character).

row_numeric <- function(title, array, dec = 2, percentage = F, se = F,
                   pvalues = -1, spacer = "\\\\") {
  if (!is.character(title)){
    stop(sprintf("Input `title` must be character but is %s. \n", class(title)))
  }
  if (!is.numeric(array)){
    stop(sprintf("Input `array` must be numeric but is %s. \n", class(array)))
  }
  if (!is.numeric(dec)){
    stop(sprintf("Input `dec` must be numeric but is %s. \n", class(dec)))
  }
  if (!is.logical(percentage)) {
    stop(sprintf("Input `percentage` must be logical but is %s.\n", class(percentage)))
  }
  if (!is.logical(se)) {
    stop(sprintf("Input `se` must be logical but is %s.\n", class(se)))
  }
  if (!is.numeric(pvalues)) {
    stop(sprintf("Input `pvalues` must be numeric but is %s.\n", class(pvalues)))
  }
  if (!is.character(spacer)) {
    stop(sprintf("Input `spacer` must be character but is %s. \n", class(spacer)))
  }
  x <- formatNum(array, dec = dec, percentage = percentage, se = se, pvalues = pvalues)
  y <- paste(paste0(" & ", x), collapse = "")
  return(paste0(title, y, spacer))
}



#' Function to create rows of text in LaTeX table.
#'
#' @description This function creates rows of text (in
#'  characters) in a LaTeX table.
#'
#' @param title The title of the row (character).
#' @param array The array that contains the information
#'  that will be in the row.
#' @param spacer The LaTeX code for spacing between this
#'  row and the next row (character).

row_string <- function(title, array, spacer = "\\\\"){
  if (!is.character(title)){
    stop(sprintf("Input `title` must be character but is %s.\n", class(title)))
  }
  if (!is.character(spacer)){
    stop(sprintf("Input `spacer` must be character but is %s.\n", class(spacer)))
  }
  y <- paste(paste0(" & ", array), collapse = "")
  return(paste0(title, y, spacer))
}

