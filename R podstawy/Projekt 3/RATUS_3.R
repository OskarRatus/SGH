##############################################################################
### data frame
test1 <- data.frame( x = sort( rnorm( 100)), y = cumsum( rnorm( 100)))

### two sets of vectors
test2x <- sort( rnorm( 100))
test2y <- cumsum( rnorm( 100))

test3x <- sort( rnorm( 100))
test3y <- cumsum( rnorm( 100))


##############################################################################
### SUMMARY
##  3 data types (df, default, formula)
#   2 function types (plot, lines)
makePlotFunction <- function(dataType = "default", functionType = "plot", ...){
  if(dataType == "data.frame"){
    if(is.na(match(functionType, c("plot")))) stop("Podana kombinacja nie istnieje.")
    
    function(x){
      if(functionType == "plot"){
        plot(x, ...) 
        
      }
    }
  } else if(dataType == "default"){
    if(is.na(match(functionType, c("plot", "lines")))) stop("Podana kombinacja nie istnieje.")
    
    function(x,y){
      if(functionType == "plot"){
        plot(x, y,  ...) 
        
      }else if(functionType == "lines"){
        lines(x, y,  ...)
        
      } else {
        stop("Podana kombinacja nie istnieje.")
        
      }
    }
  } else if(dataType == "formula"){
    if(is.na(match(functionType, c("plot", "lines")))) stop("Podana kombinacja nie istnieje.")
    
    function(form, data = NULL){
      frm<-formula(form)
      
      if(functionType=="plot"){
        if(!is.null(data)){
          plot(frm, data, ...)
          
        }else{
          plot(frm, ...)
        }
        
      }else if(functionType=="lines"){
        if(!is.null(data)){
          lines(frm, data, ...)
          
        }else{
          lines(frm, ...)
        }
      
      }
    }
  } else {
    stop("Podana kombinacja nie istnieje.")
  }
}



##############################################################################
### INITIALIZATION
## DATA.FRAME
plot_DF <- makePlotFunction(
  dataType = "data.frame",
  functionType = "plot",
  col = "red", pch = 20, type = "o")

# B??AD
lines_DF_ERR <- makePlotFunction(
  dataType = "data.frame",
  functionType = "lines",
  col = "lightblue", pch = 20, type = "o")


## DEFAULT
plot_DEFAULT <- makePlotFunction(
  dataType = "default",
  functionType = "plot",
  col = "red", pch = 21, type = "o")

lines_DEFAULT <- makePlotFunction(
  dataType = "default",
  functionType = "lines",
  col = "lightblue", pch = 22, type = "o")

plot_DEFAULT_ERR <- makePlotFunction(
  dataType = "default",
  functionType = "plot2",
  col = "red", pch = 21, type = "o")


## FUNCTION
plot_FUN <- makePlotFunction(
  dataType = "formula",
  functionType = "plot",
  col = "red", pch = 23, type = "o", xlab = "warto??ci x", ylab = "warto??ci y")

lines_FUN <- makePlotFunction(
  dataType = "formula",
  functionType = "lines",
  col = "lightblue", pch = 24, type = "o", xlab = "warto??ci x", ylab = "warto??ci y")



##############################################################################
### CALL
## DF
plot_DF(test1)
lines_DF(test1) # ERROR

## DEFAULT
plot_DEFAULT(test2x,test2y)
lines_DEFAULT(x = test3x, y = test3y)

plot_DEFAULT(x = test3x, y = test3y)
lines_DEFAULT(test2x,test2y)


## FUNCTION
plot_FUN(y~x, data = test1)
lines_FUN(test3y~test3x)

plot_FUN(test3y~test3x)
lines_FUN(y~x, data = test1)

