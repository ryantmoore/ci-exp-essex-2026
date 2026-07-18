library(DeclareDesign)
library(tidyverse)

model <- declare_model(N = 100,
                       U = rnorm(N, mean = 5),
                       Uc = U - mean(U),
                       tau = rnorm(N, mean = 1, sd = 0.1),
                       Z = rbinom(N, 1, prob = 0.5),
                       potential_outcomes(Y ~ tau * Z + U))

inq <- declare_inquiry(PATE = mean(Y_Z_1 - Y_Z_0))

samp <- declare_sampling(S = complete_rs(N, n = N / 2), legacy = FALSE)

dat <- declare_assignment(Z = complete_ra(N, prob = .4), legacy = FALSE)

meas <- declare_measurement(Y = reveal_outcomes(Y ~ Z))

ans <- declare_estimator(Y ~ Z, .method = lm_lin, 
                         covariates = ~ U, inquiry = "PATE")

des <- model + inq + samp + dat + meas + ans

diagnose_design(des)

ans <- declare_estimator(Y ~ Z, .method = lm_lin, 
                         covariates = ~ Uc, inquiry = "PATE")

des <- model + inq + samp + dat + meas + ans

diagnose_design(des)


# DID tests ---------------------------------------------------------------


tau <- 5

df <- tibble(id = 1:100,
             x = rnorm(100, mean = 4),
             xc = x - mean(x),
             Tr = rbinom(100, 1, prob = .5),
             pre = tau * Tr + x + rnorm(100),
             post = pre + 1 + rnorm(100))

vars <- c("pre", "post")

df <- df |> pivot_longer(cols = all_of(vars),
                         names_to = "when",
                         values_to = "Y") |>
  mutate(post = if_else(when == "post", 1, 0))

lm_robust(Y ~ Tr + post + x + Tr:post + Tr:post:xc, data = df)

lm_robust(Y ~ Tr + post + x + Tr:post + Tr:post:xc + post:xc + Tr:xc, data = df)

lm_robust(Y ~ Tr + post + xc + Tr:post + Tr:post:xc, data = df)

lm_robust(Y ~ Tr + post + xc + Tr:post + Tr:post:xc + post:xc + Tr:xc, data = df) |> 
  tidy() 



# Lin with block IDs vs block variables -----------------------------------

# Model ------------------------------------------------------------------------
U1 <- declare_model(block = add_level(N = 3,
                                     prob = c(.5, .7, .9),
                                     tau = c(4, 2, 0)),
                   # Add individ covariate varying by blocks:
                   indiv = add_level(N = 100, e = rnorm(N) - as.numeric(block), 
                                     Y_Z_0 = e + rnorm(N, sd = .5),
                                     Y_Z_1 = e + tau + rnorm(N, sd = .5)))

U2 <- declare_model(block = add_level(N = 3,
                                      prob = c(.5, .5, .5),
                                      tau = c(4, 2, 0)),
                    # Add individ covariate varying by blocks:
                    indiv = add_level(N = 100, e = rnorm(N) - as.numeric(block), 
                                      Y_Z_0 = e + rnorm(N, sd = .5),
                                      Y_Z_1 = e + tau + rnorm(N, sd = .5)))


U3 <- declare_model(block = add_level(N = 3,
                                      prob = c(.5, .5, .5),
                                      tau = c(2, 2, 2)),
                    # Add individ covariate varying by blocks:
                    indiv = add_level(N = 100, e = rnorm(N) - as.numeric(block), 
                                      Y_Z_0 = e + rnorm(N, sd = .5),
                                      Y_Z_1 = e + tau + rnorm(N, sd = .5)))

U4 <- declare_model(block = add_level(N = 3,
                                      prob = c(.5, .7, .9),
                                      tau = c(2, 2, 2)),
                    # Add individ covariate varying by blocks:
                    indiv = add_level(N = 100, e = rnorm(N) - as.numeric(block), 
                                      Y_Z_0 = e + rnorm(N, sd = .5),
                                      Y_Z_1 = e + tau + rnorm(N, sd = .5)))

# U5 <- declare_model(block = add_level(N = 3,
#                                       prob = c(.5, .7, .9),
#                                       tau = c(4, 2, 0)),
#                     # Blocks don't affect outcomes:
#                     indiv = add_level(N = 100, e = rnorm(N), 
#                                       Y_Z_0 = e + rnorm(N, sd = .5),
#                                       Y_Z_1 = e + tau + rnorm(N, sd = .5)))




# Inquiry ----------------------------------------------------------------------
Q <- declare_inquiry(ATE = mean(Y_Z_1 - Y_Z_0))

# Data Strategy ----------------------------------------------------------------
Z_vary <- declare_assignment(Z = block_ra(blocks = block, block_prob = c(.5, .7, .9)), legacy = FALSE)
Z_const <- declare_assignment(Z = block_ra(blocks = block, block_prob = c(.5, .5, .5)), legacy = FALSE)

R <- declare_measurement(Y = reveal_outcomes(Y ~ Z))

# Answer Strategy --------------------------------------------------------------
A0 <- declare_estimator(Y ~ Z, inquiry = Q,  
                        .method =  lm_robust, label = "A0: Naive (Pooled)")
A1 <- declare_estimator(Y ~ Z + block, inquiry = Q,  
                        .method =  lm_robust, label = "A1: LSDV")
A2 <- declare_estimator(Y ~ Z, blocks = block, inquiry = Q,  
                        .method =  difference_in_means, label = "A2: Blocked DIM")

A3 <- declare_estimator(Y ~ Z, model = lm_lin, 
                        covariates = ~ e,
                        inquiry = Q,
                        label = "A3: Lin Block VARS")

A4 <- declare_estimator(Y ~ Z, covariates = ~ block, inquiry = Q,
                        .method = lm_lin,
                        label = "A4: Lin Block IDs")

A5 <- declare_estimator(Y ~ Z, covariates = ~ block + e, inquiry = Q,
                        .method = lm_lin,
                        label = "A5: Lin Block VARS + IDs")


# Design -----------------------------------------------------------------------

design1 <- U1 + Z_vary + Q + R + A0 + A1 + A2 + A3 + A4 + A5
design2 <- U2 + Z_const + Q + R + A0 + A1 + A2 + A3 + A4 + A5
design3 <- U3 + Z_const + Q + R + A0 + A1 + A2 + A3 + A4 + A5
design4 <- U4 + Z_vary + Q + R + A0 + A1 + A2 + A3 + A4 + A5
# design5 <- U5 + Z_vary + Q + R + A0 + A1 + A2 + A3 + A4 + A5


diagnose_design(design1, sims = 1000, bootstrap_sims = 500)
diagnose_design(design2, sims = 1000, bootstrap_sims = 500)
diagnose_design(design3, sims = 1000, bootstrap_sims = 500)
diagnose_design(design4, sims = 1000, bootstrap_sims = 500)
# diagnose_design(design5, sims = 1000, bootstrap_sims = 500)

diag_des <- diagnose_designs(design1, design2, design3, design4,
                             sims = 1000,
                             bootstrap_sims = 500)


# Plot:

# Estimator bias, by DGP:
diag_des$diagnosands_df %>%
  ggplot(aes(bias, estimator_label)) +
  geom_point() + 
  geom_vline(xintercept = 0,
             colour = "red", 
             linetype = "dashed") + 
  facet_wrap(~ design_label)
