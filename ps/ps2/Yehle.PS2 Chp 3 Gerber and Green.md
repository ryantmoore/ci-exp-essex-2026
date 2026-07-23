## Exercise 3.1
(a) Standard error refers to how close the experiment is to recovering the true ATE, so it's a statistic of sampling variability. In order to calculate the standard error, we need the square root of the average squared *standard deviation* (how wide the data are spread around the mean)

(b) Randomization inference tests the sharp null by calculating a distribution of p values for all (or a very large number) possible random assignment given how the experiment was actually conducted. Then you compare your observed mean (or some other test statistic like median) to the distribution from the inference tests.

(c) A confidence interval is the "probability statement about the range of values within which a parameter is located" (Gerber and Green, 67). A 95% confidence interval are the range where researchers have a .95 probability of 95% likelihood of identifying the true ATE.

(d) Complete random assignment is when each individual is completely independently and randomly assigned. Block random assignment, on the other hand, involves putting the participants into groups and then randomizing within that group. Cluster random assignment randomizes at a higher level (like state, classroom, province) and then all individuals in those clusters are randomly treated.

(e) Balanced designs means that the sample size does not vary with the potential outcomes, so the difference in means estimator is unbiased. In other words, the weight of each individual towards their treatment mean is not equal so some individuals' outcomes would matter more (smaller n in the denominator produces smaller movement on the numerator where all the outcomes are added together).

## Exercise 3.5
(a) assuming 1 village is treated here are all the estimated difference in means

| village unit treated | diff in means |
| -------------------- | ------------- |
| 1                    | .83           |
| 2                    | 0             |
| 3                    | 15            |
| 4                    | .84           |
| 5                    | 4.2           |
| 6                    | 0             |
| 7                    | 15            |

(b) there appears to be some rounding error but this above averages to 5.12 and the true ATE according to the difference in the real treatment effects (and table) is 5

