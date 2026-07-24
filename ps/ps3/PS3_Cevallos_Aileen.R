#PS3


#5.c. 
#Standard deviation of the 7 estimates

estimates <- c(-0.8, 0, 15.83, 0.83, 4.17, 0, 15)
mean_estimates <- mean(estimates)
mean_estimates
sd <- sd(estimates)
sd

#SE of Y1 and Y0
y0 <- c(10, 15, 20, 20, 10, 15, 15)
var(y0)
y1 <- c(15, 15, 30, 15, 20, 15, 30)
var(y1)
N <- length(y0)
N
m <- 1
N-m
var_y0 <- sd(y0)
var_y0
var_y1 <- sd(y1)
var_y1

cov_y0_y1 <- cov(y0, y1)
cov_y0_y1

SE <- sqrt(1/(N-1)*(((m*var_y0)/N-m) + (((N-m)*var_y1)/m) + (2*cov_y0_y1)))
SE

#is SE the same as sd?
SE== sd
round(SE, 1)== round (sd, 1)

#5.d. 
#To minimize sampling variability, a greater share of people have to be allocated to the group that has higher natural variance. 
#The Variance of Y(1) (50) is much higher than the Variance of Y(0) (16.66). 
#Which means that when we allocate more subjects to the Y(1) group, the sampling variability gets smaller. 

y0 <- c(10, 15, 20, 20, 10, 15, 15)
var(y0)
y1 <- c(15, 15, 30, 15, 20, 15, 30)
var(y1)

#5.e.

