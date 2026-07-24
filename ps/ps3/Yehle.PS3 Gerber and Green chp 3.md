## Exercise 3.5
(c) 

| village unit treated | diff in means | average | SD   |
| -------------------- | ------------- | ------- | ---- |
| 1                    | .83           | 15.7    | 3.45 |
| 2                    | 0             | 15      | 4.08 |
| 3                    | 15            | 16.43   | 6.90 |
| 4                    | .84           | 14.23   | 3.45 |
| 5                    | 4.2           | 16.43   | 3.78 |
| 6                    | 0             | 15      | 4.08 |
| 7                    | 15            | 17.14   | 6.99 |
For example the calculation for sd for village 1 is
$x=15.7$ 
$sqrt(((15-x)^2+(15-x)^2+(20-x)^2+(20-x)^2+(10-x)^2+(15-x)^2+(15-x)^2)/6)$ 
Then to calculate the standard error, I sum the square of deviations then average the squared deviation by 1/7. 
sum((3.45-5)^2+(4.08-5)^2+(6.90-5)^2+(3.45-5)^2+(3.78-5)^2+(4.08-5)^2+(6.99-5)^2)
sqrt((1/7)*15.56)

The standard error from this approach is 1.49.

(d) The treated potential outcomes have more variance than the untreated potential outcomes, so therefore increasing the number of treated decreases the standard error

(e) The extension of what I previously wrote means that nearly all variance of treatment would be accounted for 6 of 7 villages were treated, so the standard error would be very small. 

