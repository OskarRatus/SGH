SteepestDescent <- function(f, x, max_iter, gridSize = 10000){
  nDim <- length(x)
  
  out <- list(x_hist = matrix(NA, nrow = max_iter, ncol = nDim), 
              f_hist = rep(NA, max_iter), 
              x_opt = x, 
              f_opt = f(x))
  
  out$x_hist[1, ] <- x
  out$f_hist[1] <- f(x)
  
  for (i in 2 : max_iter) {
    x <- LineSearch(f, x, -nGrad(f, x), gridSize)
    out$x_hist[i,] <- x
    out$f_hist[i] <- f(x)
    if (f(x) < out$f_opt) {
      out$f_opt <- f(x)
      out$x_opt <- x
    }
  }
  return(out)
}

LineSearch <- function(f, x0, s, gridSize){
  for (i in 1 : gridSize) {
    d <- i /gridSize
    x_new <- x0 + d * s
    if (f(x_new) < f(x0)) {
      x0 <- x_new
    }
  }
  return(x0)
}
