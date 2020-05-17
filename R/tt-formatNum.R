

#' This function formats numbers in a table within a LaTeX document.
#' @param x The number(s) to be formatted (numeric).
#' @param dec Number of decimal places (numeric).
#' @param big.mark Used as mark within large numbers; normally, a comma (as in 1,201,390) (character).
#' @param percentage (logical)
#' @param dollar (logical)
#' @param se (logical)
#' @param pvalues (numeric)
#' @param surround (string) allows to surround the results with text
#' @export
tt_formatNum <- function(x, dec = 4, big.mark = ",", percentage = F, dollar = F, se = F, pvalues = NULL, surround = "") {

  # check types
  assertNumeric(x)
  assertNumeric(dec)
  if (!is.null(pvalues)) {
    assertNumeric(pvalues, len = length(x), lower = 0, upper = 1)
  }
  assertLogical(percentage)
  assertLogical(dollar)
  assertLogical(se)
  assertCharacter(big.mark, len = 1)

  # account for length
  if (length(dec) > 1) {
    assert(length(x) == length(dec))
  } else {
    dec <- rep(dec, length(x))
  }

  if (length(percentage) > 1) {
    assert(length(x) == length(percentage))
  } else {
    percentage <- rep(percentage, length(x))
  }

  if (length(dollar) > 1) {
    assert(length(x) == length(dollar))
  } else {
    dollar <- rep(dollar, length(x))
  }

  if (length(se) > 1) {
    assert(length(x) == length(se))
  } else {
    se <- rep(se, length(x))
  }

  y <- NULL
  for (itera in 1:length(x)) {
    if (!is.na(x[itera])) {
      val <- round(x[itera], digits = dec[itera])
      val <- format(val, big.mark = ",", nsmall = dec[itera], digits = dec[itera], scientific = F)
      val <- trimws(val)
      if (percentage[itera]) {
        val <- paste0(val, "\\%")
      }
      if (dollar[itera]) {
        val <- paste0("\\$", val)
      }
      if (se[itera]) {
        val <- paste0("(", val, ")")
      }
      if (!is.null(pvalues)) {
        if (pvalues[itera] <= .01) {
          val <- paste0(val, "*")
        }
        if (pvalues[itera] <= .05) {
          val <- paste0(val, "*")
        }
        if (pvalues[itera] <= .1) {
          val <- paste0(val, "*")
        }
      }
    } else {
      val <- ""
    }
    y <- c(y, val)
  }

  if (str_length(surround) > 1) {
    y <- sprintf(surround, y)
  }

  return(y)
}
