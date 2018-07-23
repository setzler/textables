

## tt_row_vspace(2) should change the ending of the last row

# testing
test.latble <- function() {
  
  # ------ simple constructions and combinations ----- #
  rr <- tt_numeric_row(1:10)
  rr <- tt_numeric_column(1:10)
  rr <- tt_numeric_column(1:10) %&% tt_numeric_column(1:10)
  rr <- tt_numeric_column(1:10) %&% tt_numeric_column(1:10) %&% tt_numeric_column(1:10)
  rr <- tt_numeric_row(1:10) + tt_numeric_row(1:10) + tt_numeric_row(1:10)
  
  
  # ----- example with a data.table -------- #
  # exmaple which uses data and grouped columns
  require(data.table)
  data <- data.table(v1 = rnorm(5), v2 = rnorm(5), v3 = rnorm(5), v4 = rnorm(5))
  
  tt <-
    tt_text_row(c("G1", "G2"), c(2, 2)) +
    tt_text_row(c("v1", "v2", "v3", "v2+v3")) +
    tt_rule_mid_partial(list(c(1, 2), c(3, 4))) +
    with(data[1:2], (tt_numeric_column(v1) %&% tt_numeric_column(v2) %&% tt_numeric_column(v3)) %&% tt_numeric_column(v2 + v3)) +
    tt_rule_mid() +
    with(data[3:5], (tt_numeric_column(v1) %&% tt_numeric_column(v2) %&% tt_numeric_column(v3)) %&% tt_numeric_column(v2 + v3))
  
  print(tt)
}

