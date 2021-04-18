# Gradient Numeryczny
nGrad <- function(f, x, h = 10^-6){
  nDim <- length(x)
  out <- rep(NA, nDim)
  
  for(i in 1 : nDim){
    I <- rep(0, nDim)
    I[i] <- 1
    out[i] <- (f(x + I*h) - f(x - I*h)) / (2*h)
  }
  return(out)
}



GradientDescent <- function(f, x, a, iter_max){
  nDim <- length(x)
  out <- list(x_hist = matrix(NA, nrow = iter_max, ncol = nDim), 
              f_hist = rep(NA, iter_max), 
              x_opt = x, 
              f_opt = f(x), 
              t_eval = NA)
  
  out$x_hist[1, ] <- x
  out$f_hist[1] <- f(x)
  
  for(i in 2 : iter_max){
    x <- x - a * nGrad(f, x)
    out$x_hist[i,] <- x  
    out$f_hist[i] <- f(x)
    if (f(x) < out$f_opt){
      out$x_opt <- x
      out$f_opt <- f(x)
    }
  }
  return(out)
}
