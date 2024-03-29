
tt_block <- function(nrow = 0, ncol = 0, row_list = list(), row_ending = list(), allow_rbind = TRUE) {
  block <- list(ncol = ncol, nrow = nrow, row_list = row_list, row_ending = row_ending, allow_rbind = allow_rbind)
  class(block) <- list("tt_block", "tt_")
  return(block)
}

# Creates a numeric row
#' @export
tt_numeric_row <- function(value, cspan = rep(1, length(value)), center = rep("c", length(value)), ...) {
  value <- tt_formatNum(value, ...)

  I <- which(cspan > 1)
  value[I] <- sprintf("\\multicolumn{%i}{%s}{%s}", cspan[I], center[I], value[I])

  row_list <- list()
  row_list[[1]] <- value

  ending <- list(rep("\\\\", length(row_list)))
  row_ending <- list()
  row_ending[[1]] <- ending

  tt_block(sum(cspan), length(cspan), row_list, row_ending = ending)
}

# Creates a numeric column
#' @export
tt_numeric_column <- function(value, ...) {
  row_list <- list()
  row_ending <- list()
  for (i in 1:length(value)) {
    row_list[[i]] <- list(tt_formatNum(value[[i]], ...))
    row_ending[[i]] <- list("\\\\")
  }

  tt_block(length(value), 1, row_list, row_ending, TRUE)
}


# creates a text row, with multicolumn support
#' @export
tt_text_row <- function(value = list(), cspan = rep(1, length(value)), center = rep("c", length(value)), surround = "") {
  
  if (str_length(surround) > 1) {
    value <- sprintf(surround, value)
  }
  
  
  I <- which(cspan > 1)
  value[I] <- sprintf("\\multicolumn{%i}{%s}{%s}", cspan[I], center[I], value[I])

  row_list <- list()
  row_list[[1]] <- value

  ending <- list(rep("\\\\", length(row_list)))
  row_ending <- list()
  row_ending[[1]] <- ending

  tt_block(sum(cspan), length(cspan), row_list, row_ending = ending)
}



# Creates a text column
#' @export
tt_text_column <- function(value) {
  row_list <- list()
  row_ending <- list()
  for (i in 1:length(value)) {
    row_list[[i]] <- list(value[[i]])
    row_ending[[i]] <- list("\\\\")
  }

  tt_block(length(value), 1, row_list, row_ending, TRUE)
}



# creates a top rule
#' @export
tt_rule_top <- function() {
  tt_block(1, 1, list(c("\\toprule")), list(c("")), FALSE)
}

# creates a full midrule
#' @export
tt_rule_mid <- function() {
  tt_block(1, 1, list(c("\\midrule")), list(c("")), FALSE)
}

# creates a full midrule
#' @export
midrule <- function() {
  tt_rule_mid()
}

# creates a bottom rule
#' @export
tt_rule_bottom <- function() {
  tt_block(1, 1, list(c("\\bottomrule")), list(c("")), FALSE)
}

# creates one (or many) partial midrule(s)
#' @export
tt_rule_mid_partial <- function(int) {
  str <- ""
  for (i in 1:length(int)) {
    str <- sprintf("%s \\cmidrule(lr){%i-%i}", str, int[[i]][[1]], int[[i]][[2]])
  }
  tt_block(1, 1, list(c(str)), list(c("")), FALSE)
}

# creates one (or many) partial midrule(s)
#' @export
midrulep <- function(int) {
  tt_rule_mid_partial(int)
}


# adds vertical space between rows
#' @export
tt_spacer_row <- function(str) {
  res <- list(str = sprintf("\\\\[%ipt]", str))
  class(res) <- list("tt_mod_ending", "tt_")
  res
}

# adds vertical space between rows
#' @export
vspace <- function(str) {
  return(tt_spacer_row(str))
}


# cbind for blocks
`%:%` <- function(e1, e2, ...) {
  # if we are given 2 cells
  if (("tt_block" %in% class(e1)) && ("tt_block" %in% class(e2))) {
    # cat("block & block\n")

    # @fixme, check that number of row matches

    block <- tt_block()

    # merge the cells row by row 
    block$row_list[[1]] <- c(e1$row_list[[1]], e2$row_list[[1]])  # we used to loop here, unclear why
    block$row_ending <- e2$row_ending # take the right ending
    block$ncol <- e1$ncol + e2$ncol
    block$nrow <- e1$nrow
    return(block)
  }
}

# rbind for blocks
`+.tt_` <- function(e1, e2, ...) {
  if (("tt_block" %in% class(e1)) && ("tt_block" %in% class(e2))) {
    # cat("block + block\n")
    # we just concat the rows and take the max number of columns
    e1$ncol <- pmax(e1$ncol, e2$ncol)
    e1$row_list <- c(e1$row_list, e2$row_list)
    e1$row_ending <- c(e1$row_ending, e2$row_ending)
    e1$nrow <- e1$nrow + e2$nrow
    return(e1)
  }

  if (("tt_block" %in% class(e1)) && ("tt_mod_ending" %in% class(e2))) {
    e1$row_ending[[length(e1$row_ending)]] <- e2$str
    return(e1)
  }
}


#' Convert the textable object to a LaTeX tabular.
#' @export
tt_tabularize <- function(tt, header = rep("r", tt$ncol),
                          pretty_rules = F, left_align_first = F) {
  if (pretty_rules) {
    tt <- tt_rule_top() + tt_rule_mid() + tt + tt_rule_mid() + tt_rule_bottom()
  }

  if (left_align_first) {
    header <- c("l", rep("r", tt$ncol - 1))
  }

  tabular <- sprintf("\\begin{tabular}{%s}", paste(header, collapse = ""))

  for (i in 1:length(tt$row_list)) {
    tabular <- c(
      tabular,
      paste(paste(tt$row_list[[i]], collapse = " & "), tt$row_ending[[i]])
    )
  }

  tabular <- c(tabular, "\\end{tabular}")

  # append comment with date of creation
  tabular <- c(sprintf("%% created using textables on %s", format(Sys.time(), "%a %b %d %X %Y")), tabular)

  return(tabular)
}


#' Shortcut with auto switch for creating rows
#' @export
TR <- function(content, ...) {
  input <- content
  # extract first element
  if (length(input) == "list") {
    input <- content[[1]]
  }

  if (typeof(input) %in% c("character")) {
    return(tt_text_row(content, ...))
  } else {
    return(tt_numeric_row(content, ...))
  }
}



print.tt_block <- function(tt) {
  tabular <- tt_tabularize(tt)
  cat(paste(tabular, collapse = "\n"))
}


#' Save a textable object to .tex, with stand_alone option
#' @export
tt_save <- function(tabular, filename, stand_alone = F) {
  if (stand_alone) {
    tabular <- c(
      "\\documentclass{standalone}",
      "\\usepackage{booktabs}",
      "\\usepackage{graphicx}",
      "\\usepackage{multirow}",
      "\\usepackage{amssymb}",
      "\\usepackage{amsmath}",
      "\\usepackage{pifont}",
      "\\usepackage{xcolor}",
      "\\usepackage[margin=1in]{geometry}",
      "\\begin{document}",
      tabular,
      "\\end{document}"
    )
  }
  openfile <- file(filename)
  writeLines(tabular, openfile)
  close(openfile)
}

#' Compile a textable object to a pdf file
#' @export
TS <- function(tab, file, header, pretty_rules = T, output_path = getwd(), stand_alone=TRUE, compile_tex=TRUE) {
  tab <- tt_tabularize(tab, pretty_rules = pretty_rules, header = header)
  current_wd <- getwd()
  setwd(output_path)
  filename <- paste0(file, ".tex")
  if(stand_alone){
    tt_save(tab, filename = filename, stand_alone = TRUE)
    if(compile_tex){
      texi2pdf(file = filename, clean = TRUE) 
    }
  }
  if(!stand_alone){
    tt_save(tab, filename = filename, stand_alone = FALSE)
  }
  setwd(current_wd)
}
