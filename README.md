textables
================
Bradley Setzler

Description
-----------

This is a package that helps construct a highly customized LaTeX table in R. The key functions for creating table rows are:

-   `row_numeric`: many options to control numerical formatting.
    -   control decimal places with`dec` argument (e.g., `dec=3` for 3 decimal places);
    -   add parentheses (like standard errors) with `se=T`;
    -   add percentage symbols with `percentage=T`;
    -   add significance stars based on p-values with `pvalues` (e.g., `pvalues=c(0.005,0.05)` would add 3 stars and 2 stars, respectively).
-   `row_string`: simple row of strings.
-   `row_header`: row that spans all columns except the first.

Example
-------

### 1. Install and load the package

``` r
library(textables)
```

### 2. Construct example regression output

``` r
library(data.table)
```

    ## Warning: package 'data.table' was built under R version 3.3.2

``` r
dd <- data.table(
    group = c("Full Sample", "Subsample"), 
    coef = c(1.2, 3.42),
    se = c(.6, .481), 
    p = c(.051, .0), 
    N = c(1234567, 891011)
  )

print(dd)
```

    ##          group coef    se     p       N
    ## 1: Full Sample 1.20 0.600 0.051 1234567
    ## 2:   Subsample 3.42 0.481 0.000  891011

### 3. Set up the table columns/alignment

``` r
alignments <- "lcc"
number_columns <- nchar(alignments)
```

### 4. Make a row with group names using `row_string`

``` r
group_headers = row_string(" ", dd$group)

print(group_headers)
```

    ## [1] "  & Full Sample & Subsample\\\\"

### 5. Three ways to use `row_numeric`, controlling decimals

#### 5.1 Make a row with coefficients and stars using `row_numeric`

``` r
coefficients = row_numeric("Effect of X on Y", dd$coef, pvalues = dd$p, dec = 3)

print(coefficients)
```

    ## [1] "Effect of X on Y & 1.200* & 3.420***\\\\"

#### 5.2 Make a row with standard errors using `row_numeric`

``` r
standard_errors = row_numeric(" ", dd$se, dec = 3, se = T)

print(standard_errors)
```

    ## [1] "  & (0.600) & (0.481)\\\\"

#### 5.3 Make a row with integers using `row_numeric`

``` r
sample_size = row_numeric("Sample Size (1,000)", dd$N / 1000, dec = 0)

print(sample_size)
```

    ## [1] "Sample Size (1,000) & 1,235 & 891\\\\"

Note that commas are added automatically.

### 6. Make a header row to span the columns with `header_row`

``` r
header_across_columns = row_header(" ", "Results at the Worker-level", number_columns - 1)

print(header_across_columns)
```

    ## [1] "\\textbf{ } & \\multicolumn{2}{c}{\\textbf{Results at the Worker-level}} \\\\"

### 7. Put all of the pieces together, separating with mid-rules

``` r
tabular <- c(
  header_across_columns,
  group_headers,
  rule_mid_partial(2, number_columns),
  coefficients,
  standard_errors,
  rule_mid(),
  sample_size
)

print(tabular)
```

    ## [1] "\\textbf{ } & \\multicolumn{2}{c}{\\textbf{Results at the Worker-level}} \\\\"
    ## [2] "  & Full Sample & Subsample\\\\"                                              
    ## [3] "\\cline{2-3}"                                                                 
    ## [4] "Effect of X on Y & 1.200* & 3.420***\\\\"                                     
    ## [5] "  & (0.600) & (0.481)\\\\"                                                    
    ## [6] "\\midrule"                                                                    
    ## [7] "Sample Size (1,000) & 1,235 & 891\\\\"

### 8. Add begin/end with pretty rules

``` r
tabular = tabular_topbottom_pretty(tabular,alignments)

print(tabular)
```

    ##  [1] "\\begin{tabular}{lcc}"                                                        
    ##  [2] "\\toprule"                                                                    
    ##  [3] "\\midrule"                                                                    
    ##  [4] "\\textbf{ } & \\multicolumn{2}{c}{\\textbf{Results at the Worker-level}} \\\\"
    ##  [5] "  & Full Sample & Subsample\\\\"                                              
    ##  [6] "\\cline{2-3}"                                                                 
    ##  [7] "Effect of X on Y & 1.200* & 3.420***\\\\"                                     
    ##  [8] "  & (0.600) & (0.481)\\\\"                                                    
    ##  [9] "\\midrule"                                                                    
    ## [10] "Sample Size (1,000) & 1,235 & 891\\\\"                                        
    ## [11] "\\midrule"                                                                    
    ## [12] "\\bottomrule"                                                                 
    ## [13] "\\end{tabular}"

There is also `tabular_topbottom` that does not add the pretty rules.

### 9. Export as .tex file

Use the `stand_alone` option to wrap the table in begin/end document commands so that the table can be compiled directly by LaTeX.

``` r
write_tex(tabular,filename='example.tex',stand_alone=T)
```

    ## NULL

``` r
system("pdflatex example.tex")
```

See example.pdf, which was compiled by this `system` command.
