# Problem set 3

## Vojtěch Pohanka

### Exercise 3.5

c.  Here are, again, our estimates from the 7 different possible designs where only a single village receives the treatment.

| Treated village | estimated ATE |
|-----------------|---------------|
| Village 1       | -0.8333333    |
| Village 2       | 0             |
| Village 3       | 15.83333      |
| Village 4       | 0.8333333     |
| Village 5       | 4.166667      |
| Village 6       | 0             |
| Village 7       | 15            |

We can calculate the standard deviation in our sample of randomisations as:

$$SD = \sqrt{\frac{1}{N-1}\sum_{j=1}^{N}(\hat\theta_j - \bar\theta{x})^2}$$

Where $\hat\theta_j$ is a single ATE estimate for a given randomisation $j$ and $\bar\theta{x}$ is the mean of our ATE estimates.

Filling in our obtained estimates, we get the following:

$$SD = \sqrt{\frac{1}{6}((-0.8333333 - 5)^2 + (0 - 5)^2 + (15.83333 - 5)^2 + (0.8333333 - 5)^2 + (4.166667 - 5)^2 + (0 - 5)^2 + (15 - 5)^2)} \approx 7.3$$

Using the full schedule of potential outcomes, we can also fill in the standard error formula in equation 3.4

$$SE = \sqrt{\frac{1}{N-1}\left[\frac{m \cdot \mathrm{Var}(Y_i(0))}{N-m} + \frac{(N-m) \cdot \mathrm{Var}(Y_i(1))}{m} + 2\,\mathrm{Cov}(Y_i(0), Y_i(1))\right]}$$

$$SE = \sqrt{\frac{1}{7-1}\left[\frac{1 \cdot (16.7)}{7-1} + \frac{(7-1) \cdot (50)}{1} + 2 * 8.3\right]}$$

$$SE = \sqrt{\frac{1}{6}\left[\frac{16.7}{6} + \frac{300}{1} + 16.6666 \right]} \approx 7.3 $$

d.  Using the standard error equation from above again, we can see how the standard error would change if we would increase the number of treated units to two, that is filling in $m = 2$:

$$SE = \sqrt{\frac{1}{7-1}\left[\frac{2 \cdot (16.7)}{7-2} + \frac{(7-2) \cdot (50)}{2} + 2 * 8.3\right]} \approx 5$$

While increasing the treatment group size increased the size of the $\frac{m \cdot \mathrm{Var}(Y_i(0))}{N-m}$ term, it also decreased the $\frac{(N-m) \cdot \mathrm{Var}(Y_i(1))}{m}$ term by a much greater amount in absolute terms. Since the covariance term as well as $N$ remained constant, this led to an overall decrease in the standard error from about 7.3 to about 5.

e.  Further increasing the number of treated villages to 6 would also reduce the standard error compared to the designs with 1 or 2 treated units:

$$SE = \sqrt{\frac{1}{7-1}\left[\frac{6 \cdot (16.7)}{7-6} + \frac{(7-6) \cdot (50)}{6} + 2 * 8.3\right]} \approx 4.6$$