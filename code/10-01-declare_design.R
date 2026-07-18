library(DeclareDesign)
library(tidyverse)

model <- declare_model(N = 20,
                       U = rnorm(N),
                       tau = rnorm(N, mean = 1, sd = 0.1),
                       Z = rbinom(N, 1, prob = 0.5),
                       potential_outcomes(Y ~ tau * Z + U))

inq <- declare_inquiry(PATE = mean(Y_Z_1 - Y_Z_0))

samp <- declare_sampling(S = complete_rs(N, n = N / 2), 
                         legacy = FALSE)

dat <- declare_assignment(Z = complete_ra(N, prob = .4), 
                          legacy = FALSE)

meas <- declare_measurement(Y = reveal_outcomes(Y ~ Z))

ans <- declare_estimator(Y ~ Z, .method = lm_robust, inquiry = "PATE")

des <- model + inq + samp + dat + meas + ans

diagnose_design(des)

# Redesign with different sample sizes:
# (Must set sampling n = n.)

samp <- declare_sampling(S = complete_rs(N, n = n), legacy = FALSE)

des <- model + inq + samp + dat + meas + ans

diagnose_design(redesign(des, n = c(8, 18)))


# Iterate over several parameters -----------------------------------------

# Create designer:
simple_designer <- function(pop_size = 100, effect_size, samp_size) {
  declare_model(
    N = pop_size,
    U = rnorm(N),
    potential_outcomes(Y ~ effect_size * Z + U)
  ) +
    declare_inquiry(PATE = mean(Y_Z_1 - Y_Z_0)) +
    declare_sampling(S = complete_rs(N, n = samp_size), legacy = FALSE) +
    declare_assignment(
      Z = complete_ra(N, prob = 0.5), legacy = FALSE
    ) +
    declare_measurement(Y = reveal_outcomes(Y ~ Z)) +
    declare_estimator(
      Y ~ Z, .method = difference_in_means, inquiry = "PATE"
    )
}

ss <- c(10, 20, 30)
tes <- c(.5, 1.5, 3)

# Create designs:
designs <- expand_design(
  simple_designer,
  samp_size = c(10, 20, 30),
  effect_size = c(.5, 1.5, 3)
  )

# Diagnose them:
diag_des <- diagnose_design(designs)

# Sample sizes and TEs not stored:
diag_des$diagnosands_df |> head(4) |> select(1:7)



# Plot:

# Power by Effect Size:
diag_des$diagnosands_df %>%
  ggplot(aes(effect_size, power)) +
  facet_wrap(~ samp_size) +
  geom_point() +
  geom_smooth()

# Power by Sample Size:
diag_des$diagnosands_df %>%
  ggplot(aes(samp_size, power)) +
  facet_wrap(~ effect_size) +
  geom_point() +
  geom_smooth()



# Diffs of designs or diagnoses -------------------------------------------

compare_designs(designs[[1]], designs[[2]])
compare_diagnoses(designs[[3]], designs[[6]])

