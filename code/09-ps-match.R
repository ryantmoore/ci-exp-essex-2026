# The Propensity Score
# Ryan T. Moore
# First: 2019-02-26
# Last: 2023-08-03


# Preliminaries -----------------------------------------------------------

library(ggplot2)
library(Matching)
library(tidyverse)

data("lalonde")

count(lalonde, treat)


# Calculating the Propensity Score ----------------------------------------

# Dehejia and Wahba, 1999:

glm_ps <- glm(treat ~ age + educ + black + hisp +
                married + nodegr + re74 + re75,
              data = lalonde, family = binomial(link = "logit"))

lalonde$ps <- glm_ps$fitted.values

ggplot(lalonde, aes(x = ps)) + geom_histogram() + xlab("Probability of Being Treated")

ggplot(lalonde, aes(x = ps, fill = as.factor(treat))) +
  geom_histogram() + xlab("Probability of Being Treated")

ggplot(lalonde, aes(x = ps, color = as.factor(treat))) +
  geom_density() + xlab("Probability of Being Treated")

ggplot(lalonde, aes(x = ps)) + geom_density() +
  facet_wrap(~ treat, scales = "free") + xlab("Probability of Being Treated")

# Moderately low propensities:
lalonde %>% filter((ps > .31) & (ps < .34)) %>% arrange(desc(ps))

# Moderately low and moderately high propensities:
lalonde %>% filter(((ps > .29) & (ps < .32)) |
                     (ps > .59) & (ps < .60)) %>%
  arrange(desc(ps))


# Checking Balance --------------------------------------------------------

cont_covs <- c("age", "educ", "re74", "re75")

par(mfrow = c(2, 2))
for(i in cont_covs){
  qqplot(lalonde[, i][lalonde$treat == 0],
         lalonde[, i][lalonde$treat == 1],
         xlab = "Control", ylab = "Treated", main = i)
  abline(0, 1, col = "red")
}

binary_covs <- c("black", "hisp", "married", "nodegr")

par(mfrow = c(2, 2))
for(i in binary_covs){
  cov_table <- table(lalonde[, i], lalonde$treat)
  mosaicplot(cov_table, xlab = i, ylab = "Treatment", main = "")
}

set.seed(731)
MatchBalance(treat ~ age + educ + re74 + re75,
             data = lalonde)


# Matching on the Propensity Score ----------------------------------------

lalonde_match <- Match(Tr = lalonde$treat,
                       X = lalonde$ps)

summary(lalonde_match)


# Checking Balance --------------------------------------------------------

MatchBalance(treat ~ age + educ + re74 + re75,
             data = lalonde,
             match.out = lalonde_match)


# Estimate the ATE --------------------------------------------------------

# Only when design is finished!

lalonde_match <- Match(Tr = lalonde$treat, X = lalonde$ps,
                       Y = lalonde$re78, estimand = "ATE")

summary(lalonde_match)


# Alternative: feed Match() data directly:

lalonde_match <- Match(Tr = lalonde$treat,
                       X = lalonde[ c("age", "educ", "re74", "re75")],
                       Y = lalonde$re78, estimand = "ATE")

summary(lalonde_match)

# Restrict to region of common support:

lalonde_match <- Match(Tr = lalonde$treat,
                       X = lalonde[ c("age", "educ", "re74", "re75")],
                       Y = lalonde$re78, estimand = "ATE",
                       CommonSupport = TRUE)

summary(lalonde_match)



# Example 2 ---------------------------------------------------------------

# Gerber and Green, 2000; Imai, 2005:

data("GerberGreenImai")

ggi <- GerberGreenImai

glm_ps <- glm(phone ~ AGE + PERSONS + MAJORPTY + VOTE96.1,
              data = ggi, family = binomial(link = "logit"))

ggi$ps <- glm_ps$fitted.values

ggplot(ggi, aes(x = ps)) + geom_histogram()

ggplot(ggi, aes(x = ps, fill = as.factor(phone))) + geom_histogram()

ggplot(ggi, aes(x = ps, color = as.factor(phone))) + geom_density()

ggplot(ggi, aes(x = ps)) + geom_density() +
  facet_wrap(~ phone, scales = "free")



# Excercise ---------------------------------------------------------------

# 1. Get the data leaders.csv from our GitHub site,
# and store as "leaders"

leaders <- read_csv("~/Documents/github/ci-exp-essex-2023/data/09-leaders.csv")

# 2. Examine a summary of the data, and the head() of the dataframe.

summary(leaders)
head(leaders)

# 3. These data describe several assassination attempts on national
# leaders, and the outcomes thereafter.  If the success of an attempt is
# "as if randomized", at least conditional on covariates, perhaps
# we can estimate the importance of specific leaders (or at least
# "successful" attempts) on democracy and conflict.  Variable "dies"
# is coded 1 if the assassination attempt was successful.

# Describe the covariate balance in this study.

ggplot(leaders, aes(x = age, color = as.factor(dies))) +
  geom_density()

ggplot(leaders, aes(x = year, color = as.factor(dies))) +
  geom_density()

ggplot(leaders, aes(x = politybefore, color = as.factor(dies))) +
  geom_density()

MatchBalance(dies ~ year + age + politybefore,
             data = leaders)

# 4. Estimate the propensity score using year, age, and politybefore.

ps_out <- glm(dies ~ year + age + politybefore,
              data = leaders, family = binomial(link = "logit"))

leaders$ps <- ps_out$fitted.values

# 5. Match on the propensity score, and examine the balance of the
# matched set.

match_out <- Match(Tr = leaders$dies, X = leaders$ps)

MatchBalance(dies ~ year + age + politybefore,
             data = leaders,
             match.out = match_out)

# This matching makes balance worse on year,
# better on age and politybefore.
# I'll omit year and reestimate.

ps_out <- glm(dies ~ age + politybefore,
              data = leaders, family = binomial(link = "logit"))

leaders$ps <- ps_out$fitted.values


# 6. Estimate the treatment effect of a successful attempt on polityafter,
# using both the unmatched and matched sets.

# Unadjusted:

lm(polityafter ~ dies, data = leaders)$coef["dies"]

match_out_outcome <- Match(Y = leaders$polityafter,
                           Tr = leaders$dies,
                           X = leaders$ps,
                           estimand = "ATE")

summary(match_out_outcome)


# Adjusted

lm(polityafter ~ dies + year + age + politybefore,
   data = leaders)$coef["dies"]

match_out_outcome <- Match(Y = leaders$polityafter,
                           Tr = leaders$dies,
                           X = leaders$ps,
                           Z = leaders[, c("age", "politybefore")],
                           estimand = "ATE",
                           BiasAdjust = TRUE)

summary(match_out_outcome)

# Subclassifying on the Propensity Score ----------------------------------

# Algorithms for Matching -------------------------------------------------

# Match

# GenMatch

# optmatch

# exactMatch

# matchit

# ...
