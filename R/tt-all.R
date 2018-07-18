# use %&% for cbind (this might not even be needed)
# use + for everything else 
# the main object is a block: a grid of cells and a set of line ending rules
# blocks should have ending rules and on %&% it uses the second one (this seems easy)
# some blocks can't be used with %&% like midrule (or perhaps only with another midrule)
# some functions can modify the last ending rule of the previous block tt_row_vspace("2pt")
#
# then we need a bunch of tt_block_* functions to do everything we want.
# the basic ones that can be used are tt_block_num, tt_block_vnum, tt_block_hnum and same with text.

# tt_cell <- function(value="unkown",cspan=1,make_block=FALSE) {
#   cell = list(value=round(value,2),nrow=length(value),ncol=length(cspan))
#   
#   if (make_block==FALSE) {
#     class(cell) = list("tt_cell","tt_")
#   } else {
#     class(cell) = list("tt_block","tt_")
#   }
#   
#   return(cell)    
# }

# a block should be a combination of rows, each rows with 
# a given number of cells. This can be constructed from columns
tt_block <- function(nrow=0,ncol=0,row_list=list(),row_ending=list(),allow_rbind=TRUE) {
  block = list(ncol=ncol,nrow=nrow,row_list=row_list,row_ending=row_ending,allow_rbind=allow_rbind)
  class(block) = list("tt_block","tt_")
  return(block)  
}

# a vertical block
tt_block_vnum <- function(value,round=2) {
  
  row_list = list()
  row_ending = list()
  for (i in 1:length(value)) {
    row_list[[i]] = list(paste(round(value[[i]],round)))
    row_ending[[i]] = list("\\\\")
  }
  
  tt_block(length(value),1,row_list, row_ending,TRUE)
}

tt_block_hnum <- function(value,round=2) {
  tt_block(1,length(value),list(paste(round(value,round)) ), list(c("\\\\")),TRUE)
}


# creates a full midrule
tt_midrule <- function() {
  tt_block(1,1,list( c("\\midrule") ), list(c("")),FALSE)
}

# creates a partial
tt_cmidrule <- function(int) {
  str = ""
  for (i in 1:length(int)) {
    str = sprintf("%s \\cmidrule(lr){%i-%i}",str,int[[i]][[1]],int[[i]][[2]])
  }
  tt_block(1,1,list(c(str)),list(c("")),FALSE)
}

# creates a text multicolumn
tt_block_vtext <- function(value=list(),cspan=rep(1,length(value))) {
  
  I = which(cspan>1)
  value[I] = sprintf("\\multicolumn{%i}{c}{%s}",cspan[I],value[I]) 
  
  row_list = list()
  row_list[[1]] = value
  
  ending = list(rep("\\\\",length(row_list)))
  row_ending = list()
  row_ending[[1]] = ending
  
  tt_block(sum(cspan),1,row_list,row_ending=ending)
}

# cbind for blocks
`%&%` <- function(e1, e2, ...){
  # if we are given 2 cells
  if ( (class(e1)=="tt_block") && (class(e2)=="tt_block")) {
    cat("block & block\n")
    
    # @fixme, check that number of row matches
    
    block          = tt_block()
    
    # merge the cells row by row
    for (i in 1:e1$nrow) {
      block$row_list[[i]] = c(e1$row_list[[i]],e2$row_list[[i]])
    }
    block$row_ending = e2$row_ending # take the right ending
    block$ncol       = e1$ncol + e2$ncol
    block$nrow       = e1$nrow
    return(block)
  }
}

# rbind for blocks
`+.tt_` <- function(e1, e2, ...){
  if ( (class(e1)=="tt_block") && (class(e2)=="tt_block")) {
    cat("block + block\n")
    # we just concat the rows and take the max number of columns
    e1$ncol = pmax(e1$ncol,e2$ncol)
    e1$row_list = c(e1$row_list,e2$row_list)
    e1$row_ending = c(e1$row_ending,e2$row_ending)
    e1$nrow = e1$nrow + e2$nrow
    return(e1)
  }
}






print.tt_block <- function(tt,header=rep("r",tt$ncol)) {
  
  cat(sprintf("\\begin{tabular}{%s}\n",paste(header,collapse = "")))
  cat("\\toprule\n")
  for (i in 1:length(tt$row_list)) {
    cat(paste(paste(tt$row_list[[i]],collapse = " & "), tt$row_ending[[i]],"\n"))
  }
  cat("\\bottomrule\n")
  cat("\\end{tabular}\n")
  
}



## tt_row_vspace("2pt") should change the ending of the last row

# testing
test.latble <- function() {
  require(magrittr)
  
  # ------ simple constructions and combinations ----- #
  rr = tt_block_hnum(1:10)
  rr = tt_block_vnum(1:10)
  rr = tt_block_vnum(1:10) %&% tt_block_vnum(1:10)
  rr = tt_block_vnum(1:10) %&% tt_block_vnum(1:10)%&% tt_block_vnum(1:10)  
  rr = tt_block_hnum(1:10) + tt_block_hnum(1:10) + tt_block_hnum(1:10)  
  
  
  # ----- example with a data.table -------- #  
  # exmaple which uses data and grouped columns
  require(data.table)
  data = data.table(v1=rnorm(5),v2=rnorm(5),v3=rnorm(5),v4=rnorm(5))
  
  tt = 
    tt_block_vtext(c("G1","G2"),c(2,2)) +
    tt_block_vtext(c("v1","v2","v3","v2+v3")) + 
    tt_cmidrule(list( c(1,2),c(3,4) )) +
    with(data[1:2], (tt_block_vnum(v1) %&% tt_block_vnum(v2) %&% tt_block_vnum(v3)) %&% tt_block_vnum(v2+v3)) +
    tt_midrule() +
    with(data[3:5], (tt_block_vnum(v1) %&% tt_block_vnum(v2) %&% tt_block_vnum(v3)) %&% tt_block_vnum(v2+v3))
  
  print(tt)  
  
  
}
