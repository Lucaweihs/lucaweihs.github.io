library(TauStar)
library(MASS)

table1 = function(mVals = seq(100, 300, by=50), sims = 10) {
  fast = numeric(length(mVals))
  slow = numeric(length(mVals))
  for(j in 1:length(mVals)) {
    m = mVals[j]
    cat(paste("Beginning computation using m =", m, "samples.\n"))
    yar = mvrnorm(m, c(0,0), matrix(c(1,0,0,1), nrow=2))
    x = yar[,1]
    y = yar[,2]
    for(i in 1:sims) {
      fast[j] = fast[j] + system.time(tStar(x, y))[1]
      slow[j] = slow[j] + system.time(tStar(x, y, slow=T))[1]
    }
    fast[j] = fast[j]/sims
    slow[j] = slow[j]/sims
    cat(paste("Fast run time =", round(fast[j], 4), "\n"))
    cat(paste("Slow run time =", round(slow[j], 4), "\n"))
    cat("\n")
  }
  mat = rbind(fast, slow)
  rownames(mat) = c("fast", "slow")
  return(mat)
}

table2 = function(mVals = seq(1000, 10000, length=5), sims = 10) {
  runTimes = numeric(length(mVals))
  for(j in 1:length(mVals)) {
    m = mVals[j]
    cat(paste("Beginning computation using m =", m, "samples.\n"))
    yar = mvrnorm(m, c(0,0), matrix(c(1,0,0,1), nrow=2))
    x = yar[,1]
    y = yar[,2]
    for(i in 1:sims) {
      runTimes[j] = runTimes[j] + system.time(tStar(x, y))[1]
    }
    runTimes[j] = runTimes[j]/sims
    cat(paste("Run time =", round(runTimes[j], 4), "\n"))
    cat("\n")
  }
  return(runTimes)
}

table3 = function(n = 1000, reps = 1000, m = 30,
                  resampleSizes = c(200, 400, 800, 1600, 3200, 6400, 12800),
                  seed = 9283) {
  set.seed(seed)
  varPerSampleSize = numeric(length(resampleSizes))
  cat("Beginning computation of sample variance for subsetting procedure.\n\n")
  for(k in 1:length(resampleSizes)) {
    resamples = resampleSizes[k]
    cat("Resample size = ", resamples, "\n")
    
    tStarsSamp = numeric(reps)
    for(i in 1:reps) {
      if(i %% floor(reps / 10) == 0) {
        cat(i, "iterations complete\n")
      }
      normData = mvrnorm(n, c(0,0), matrix(c(1,0,0,1), nrow=2))
      tStarsSamp[i] = tStar(normData[,1], normData[,2], resample=T, numResamples=resamples, sampleSize=m)
    }
    varPerSampleSize[k] = mean(tStarsSamp^2)
    cat("Var = ", varPerSampleSize[k], "\n\n")
  }
  
  cat("Beginning computation of sample variance for t* on all data.\n\n")
  tStars = numeric(reps)
  for(i in 1:reps) {
    if(i %% floor(reps / 10) == 0) {
      cat(i, "iterations complete\n")
    }
    normData = mvrnorm(n, c(0,0), matrix(c(1,0,0,1), nrow=2))
    tStars[i] = tStar(normData[,1], normData[,2])
  }
  varForUStat = mean(tStars^2)
  cat("Var = ", varForUStat, "\n")
  
  return(varPerSampleSize/varForUStat)
}