MyRandomWalk <- function(f, x0, max_iter, d){
  n <- length(x0)
  
  out <- list(f_opt = f(x0),
              x_opt = x0,
              f_hist = f(x0),
              x_hist = x0)
  
  out$x_hist[1] <- x0
  out$f_hist[1] <- f(x0)
  
  for (i in 1 : max_iter) {
    x0 <- x0 + runif(n = n, min = -d, max = d)
    out$f_hist[i+1] <- f(x0)
    out$x_hist[i+1] <- x0
    if(f(x0) < out$f_opt){
      out$f_opt <- f(x0)
      out$x_opt <- x0
    }
  }
  
  return(out)
}


