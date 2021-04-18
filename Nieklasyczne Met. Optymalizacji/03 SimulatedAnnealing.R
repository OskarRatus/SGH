SimulatedAnnealing <- function(f, x, d, t, alfa, iter_max){
  n <- length(x)
  
  # Output setup
  out <- list(f_opt =  f(x),
              x_opt =  x,
              f_hist = rep(NA, iter_max),
              x_hist = matrix(NA, nrow = iter_max, ncol = n),
              a_fun =  rep(NA, iter_max),
              t_hist = rep(NA, iter_max)
              )
  
  out$f_hist[1]  <- f(x)
  out$x_hist[1,] <- x
  
  for (i in 2 : iter_max) {
    # Step 1 Candidate initialisation
    x_new <- x + runif(n, min = -d, max = d)
    
    # Step 2 Accteptance rule (Metropolis)
    out$a_fun[i] <- min(1, exp(-(f(x_new) - f(x)) / t))
    
    countAccepted = 1
    if (runif(1) < out$a_fun[i]) {
      x <- x_new
      countAccepted <- countAccepted + 1
    }
    
    # Step 3 Temperature change 
    t <- t * alfa
    
    # # Temp change if:
    # # 1. 12*n perturbations accepted
    # # 2. 100*n perturbation attempted
    # if (countAccepted%%12*n == 0 | i%%100*n == 0) {
    #   t <- t * alfa
    # }
    
    # Search history
    if (f(x) < out$f_opt) {
      out$f_opt <- f(x)
      out$x_opt <- x
    }
    
    out$f_hist[i]   <- f(x)
    out$x_hist[i, ] <- x
    out$t_hist[i]   <- t
  }
  
  return(out)
}