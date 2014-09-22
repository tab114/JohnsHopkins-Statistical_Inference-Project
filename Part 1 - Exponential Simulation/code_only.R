## Generating 1000 simulations of 40 exponential values with rate = 0.2, 
# and calculating the expected and observed summary statistics (mean, median, sd, SE):

lambda = 0.2
n = 40 # the size of the sample 
noSim = 1000 # the number of simulations
meanExp = 1/lambda # Expexted average of the exponential distribution
mediaExp = meanExp
sdExp = 1/lambda # Expected standard deviation of the exponential 
se = sdExp/sqrt(n)  # Theoretical standard error - Expected sd of the exponential means.

set.seed(10) # Creating 10000 means of 40 values
values <- matrix(rexp(noSim * n, rate=0.2), nrow = noSim) # matrix of 40(values) x 1000(simulations)

means <- apply(values, MARGIN = 1, mean) # means of each simulation
seSim <- sd(means)  # standard error of the simulations - observed sd of the simulated means
meanSim <- mean(means) # observed mean of the simulated exponential means
mediaSim <- mean(means) # observed median of the simulated exponential means 

### Histogram
  
  library(ggplot2)
  dat2 = data.frame(means)
  g <- ggplot(dat2, aes(x=means)) + geom_histogram(alpha = .20, binwidth=0.15, colour = "black", 
                                                   fill="blue", aes(y = ..density..))
  g <- g + xlab("Sample Means") + ylab("Frequency") + ggtitle("Distribution of Sample Means")
  g <- g + geom_vline(xintercept = meanExp, size = 1)
  g + stat_function(fun = dnorm, args = c(mean=meanExp, sd=se), size=1)
  
  # If I want frequencies in the Y-axis instead of densities I could do the following to 
  # overlay the normal curve:
  
  g <- ggplot(dat2, aes(x=means)) + geom_histogram(alpha = .20, binwidth=0.15, colour = "black")
  g <- g + xlab("Sample Means") + ylab("Frequency") + ggtitle("Distribution of Sample Means")
  g <- g + geom_vline(xintercept = meanExp, size = 1)
  
      # Generate scaled data from a normal distribution
      # x-axis
      x <- seq(meanExp-4*se, meanExp+4*se,length=100)  #length (-4,4) theoretical standard errors from the mean
      #y-axis
      y <- dnorm(x, mean=meanExp, sd = se) # generate 100 normal density values.
      y = y*noSim*0.15   #adjust the normal values to the Frequencies. 0.2 stands for the binwidth. 
      xy=data.frame(cbind(x,y))
  
  # Overlay the normal curve in the histogram
  g + geom_point(data = xy, aes(x = x, y = y, colour = 'Normal')) 


### QQ-Plot

ggplot(dat2, aes(sample = means)) + stat_qq() + geom_abline(aes(intercept = mean(means), slope=1))
# or if I want both axis to be in tha same scale
ggplot(dat2, aes(sample = means - 5)) + stat_qq() + geom_abline()


### 95% Confidence Interval for the mean (1/lambda) of any simulated exponential 
# distribution with n=40 values

CI <- meanExp +c(-1,1) * 1.96 * se/sqrt(n)
