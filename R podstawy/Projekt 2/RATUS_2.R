library(ggplot2)
library(dplyr)

randomPolytope2D <- function(a=0, b=0, r=1, n=3){
  # a <- 0          # x hook
  # b <- 0          # y hook
  # r <- 1          # size
  # n <- 3          # no of vertices
  x = rep(NA, n) # x coords
  y <- rep(NA, n) # y coords
  
  for (i in 1:n) {
    rnd <- runif(1,0,1)
    x[i] = a + r  * sin(i * 2 * pi / n + rnd) 
    y[i] = b + r  * cos(i * 2 * pi / n + rnd) 
    
  }
  tab <- data.frame(x,y)
  
  return(tab) 
}


plotPoly <- function(tab, addNew = FALSE,  ...){
  if(addNew == TRUE){
    tab%>% polygon(...)
  } else {
    tab %>% plot(cex=0, axes = F, ann = F) 
    tab%>% polygon(...)
  }

}


p1 <- randomPolytope2D(n = 4)
p2 <- randomPolytope2D(a=1, b=1, n=3)
p3 <- randomPolytope2D(n=6)
plotPoly( p3, xlim = c( -10, 10), ylim = c( -10, 10),
          col = rgb( 0, 0, 1, .2), border = rgb( 0, 0, 1), density = 10, angle = 45)
plotPoly( p1, add = TRUE, col = rgb( 1, 0, 0, .8), border = "red")
plotPoly( p2, add = TRUE, col = rgb( 0, 0, 1, .2), border = "blue")

