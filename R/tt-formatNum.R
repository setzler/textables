

#' Function to do format numbers within LaTeX document.
#'
#' @description
#' This function formats numbers in a table within a
#'  LaTeX document.
#'
#' @param x The number(s) to be formatted (numeric).
#' @param dec Number of decimal places (numeric).
#' @param big.mark Used as mark within large numbers; normally,
#'  a comma (as in 1,201,390) (character).
#' @param percentage (logical)
#' @param se (logical)
#' @param pvalues (numeric)

tt_formatNum <- function(x, dec = 4, big.mark = ",", percentage = F, se = F, pvalues = -1) {
  if (!is.numeric(x)) {
    stop(sprintf("Input `x` must be numeric but is %s.\n", class(x)))
  }
  if (!is.numeric(dec)) {
    stop(sprintf("Input `dec` must be numeric but is %s.\n", class(dec)))
  }
  if (!is.character(big.mark)) {
    stop(sprintf("Input `big.mark` must be character but is %s. \n", class(big.mark)))
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
  
  x <- round(x, dec)
  y <- trimws(format(x, big.mark = ",", nsmall = dec, digits = dec,
                     scientific = F))
  if (sum(percentage) != 0 & sum(percentage) == 1 & length(percentage) == 1) {
    y <- paste0(y, "\\%")
  }
  if (sum(se) != 0 & sum(se) == 1 & length(se) == 1) {
    y <- paste0("(", y, ")")
  }
  if (sum(percentage) != 0 & sum(percentage) >= 1 & length(percentage) == length(x) & length(percentage) > 1) {
    for (i in 1:length(x)) {
      if (percentage[i] == 1) {
        y[i] <- paste0(y[i], "\\%")
      }
    }
  }
  if (sum(se) != 0 & sum(se) >= 1 & length(se) == length(x) & length(se) > 1) {
    for (i in 1:length(x)) {
      if (se[i] == 1) {
        y[i] <- paste0("(", y[i], ")")
      }
    }
  }
  if (length(pvalues) == length(x) & max(pvalues) >= 0 & min(pvalues) <= 1) {
    for (i in 1:length(x)) {
      if (!is.na(pvalues[i])) {
        if (pvalues[i] <= .01) {
          y[i] <- paste0(y[i], "*")
        }
        if (pvalues[i] <= .05) {
          y[i] <- paste0(y[i], "*")
        }
        if (pvalues[i] <= .1) {
          y[i] <- paste0(y[i], "*")
        }
      }
    }
  }
  y[grep("NA", y)] <- rep("", 2)
  return(y)
}
