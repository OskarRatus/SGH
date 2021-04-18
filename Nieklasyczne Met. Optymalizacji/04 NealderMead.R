NealderMead <- function(f, x0, int_step = 1.05, refl = 1, expan = 2, max_iter){
  
  # f = ObjFun
  # x0 = c(0,0)
  # int_step = .9
  # refl = 1
  # expan = 2
  # outsid = 0.5
  # insid = 0.5
  # max_iter = 10
  # n <- length(x0)
  # x <- matrix(x0, nrow = n + 1, ncol = n, byrow = T )
  
  n <- length(x0)
  x <- matrix(x0, nrow = n + 1, ncol = n, byrow = T )
  
  out <- list(x_hist = matrix(NA, nrow = max_iter, ncol = n), 
              f_hist = rep(NA, max_iter), 
              x_opt = x, 
              f_opt = f(x),
              simp_hist = matrix(NA, nrow = max_iter * 3, ncol = n))
  
  
  # initialize simplex
  x <- x + rbind(rep(0, n), diag(n) * int_step)
  
  # termination loop
  for (k in 1:max_iter) {
    # sort
    fv <- apply(x, 1, f)
    x  <- x[sort(fv, index.return = T)$ix,]
    fv <- sort(fv)
     # lines(x = x[,1], y = x[,2])
    
    #
    out$x_hist[k,] <- x[1,]
    out$f_hist[k]  <- fv[1]
    out$simp_hist[seq(3 * k - 2, 3 * k),] <- x[1:3,1:2]
    if (fv[1] < out$f_opt) { # to chyba nie jest konieczne bo algorytm nie mo¿e pogorszyæ funkcji
      out$x_opt <- x[1,]
      out$f_opt <- fv[1]    
    }
    
    # REFLECTION
    pg <- apply(x[1:2,1:2], 2, mean)
    pr <-  pg + refl * (pg - x[3,])
    fr <- f(pr)
    
    # main loop
    if (fr < fv[3]) {
      pe <- pg + expan * (pg - x[3,])
      fe <- f(pe)
      
      if (fe < fr) {
        # EXTENTION
        x[3,] <- pe
        
      }else{
        # REFLECTION
        x[3,] <- pr
        
      }
    }else{ # fr => fv[3,]
      c_1    <- apply(rbind(x[3,], pg), 2, mean)
      c_2    <- apply(rbind(pr, pg), 2, mean)
      c_temp <- rbind(c_1, c_2) 
      c      <- c_temp[which.min(c(f(c_1), f(c_2))),]
      fc     <- f(c)
      
      if (fc < fv[3]) {
        # CONTRACTION
        x[3,] <- c
        
      }else{
        # SHRINK
        s <- apply(rbind(x[3,], x[1,]), 2, mean)
        x[2,] <- s
        x[3,] <- pg
        
      }
    }
    
  }
  
  return(out)
}  

