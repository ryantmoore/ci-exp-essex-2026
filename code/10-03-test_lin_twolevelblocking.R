library(DeclareDesign)
library(tidyverse)

# Lin with block IDs vs block variables -----------------------------------
# Two-levels of blocking --------------------------------------------------

# Model ------------------------------------------------------------------------
# vary tr prob and te:
U1 <- declare_model(
  preparer = add_level(N = 40, 
                       prob = rep(.5, N),
                       tau_p = (1:40) / 10),
  risk_group = add_level(N = 3,
                    prob = c(.5, .7, .9),
                    tau_rg = c(4, 2, 0)))

U1 <- U1 + declare_model(block = str_c(preparer, risk_group))

U1 <- U1 + declare_model(  # Add individ covariate varying by blocks:
  indiv = add_level(N = 30, 
                    e = rnorm(N) + as.numeric(block) / 2e4, 
                    Y_Z_0 = e + rnorm(N, sd = 1),
                    Y_Z_1 = e + tau_p + tau_rg + rnorm(N, sd = 1)))

# prob constant, TE varies:
U2 <- declare_model(
  preparer = add_level(N = 40, 
                       prob = rep(.5, N),
                       tau_p = (1:40) / 10),
  risk_group = add_level(N = 3,
                         prob = c(.5, .5, .5),
                         tau_rg = c(4, 2, 0)))

U2 <- U2 + declare_model(block = str_c(preparer, risk_group))

U2 <- U2 + declare_model(  # Add individ covariate varying by blocks:
  indiv = add_level(N = 30, 
                    e = rnorm(N) + as.numeric(block) / 2e4, 
                    Y_Z_0 = e + rnorm(N, sd = 1),
                    Y_Z_1 = e + tau_p + tau_rg + rnorm(N, sd = 1)))

# prob varies, TE constant:
U4 <- declare_model(
  preparer = add_level(N = 40, 
                       prob = rep(.5, N),
                       tau_p = rep(2, N)),
  risk_group = add_level(N = 3,
                         prob = c(.5, .7, .9),
                         tau_rg = c(2, 2, 2)))

U4 <- U4 + declare_model(block = str_c(preparer, risk_group))

U4 <- U4 + declare_model(  # Add individ covariate varying by blocks:
  indiv = add_level(N = 30, 
                    e = rnorm(N) + as.numeric(block) / 2e4, 
                    Y_Z_0 = e + rnorm(N, sd = 1),
                    Y_Z_1 = e + tau_p + tau_rg + rnorm(N, sd = 1)))


# U3 <- declare_model(block = add_level(N = 3,
#                                       prob = c(.5, .5, .5),
#                                       tau = c(2, 2, 2)),
#                     # Add individ covariate varying by blocks:
#                     indiv = add_level(N = 100, e = rnorm(N) - as.numeric(block), 
#                                       Y_Z_0 = e + rnorm(N, sd = .5),
#                                       Y_Z_1 = e + tau + rnorm(N, sd = .5)))
# 

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
Z_vary <- declare_assignment(Z = block_ra(blocks = block, block_prob = seq(.5, .9, length.out = 120)), legacy = FALSE)
Z_const <- declare_assignment(Z = block_ra(blocks = block, block_prob = rep(.5, 120)), legacy = FALSE)

R <- declare_measurement(Y = reveal_outcomes(Y ~ Z))

# Answer Strategy --------------------------------------------------------------
A0 <- declare_estimator(Y ~ Z, inquiry = Q,  
                        model =  lm_robust, label = "A0: Naive (Pooled)")
A1 <- declare_estimator(Y ~ Z + block, inquiry = Q,  
                        model =  lm_robust, label = "A1: LSDV")
A2 <- declare_estimator(Y ~ Z, blocks = block, inquiry = Q,  
                        model =  difference_in_means, label = "A2: Blocked DIM")

A3 <- declare_estimator(Y ~ Z, model = lm_lin, 
                        covariates = ~ e,
                        inquiry = Q,
                        label = "A3: Lin Block VARS")

A4 <- declare_estimator(Y ~ Z, covariates = ~ block, inquiry = Q,
                        model = lm_lin,
                        label = "A4: Lin Block IDs")

A5 <- declare_estimator(Y ~ Z, covariates = ~ block + e, inquiry = Q,
                        model = lm_lin,
                        label = "A5: Lin Block VARS + IDs")


# Design -----------------------------------------------------------------------

design1 <- U1 + Z_vary + Q + R + A0 + A1 + A2 + A3 + A4 + A5
design2 <- U2 + Z_const + Q + R + A0 + A1 + A2 + A3 + A4 + A5
#design3 <- U3 + Z_const + Q + R + A0 + A1 + A2 + A3 + A4 + A5
design4 <- U4 + Z_vary + Q + R + A0 + A1 + A2 + A3 + A4 + A5
# design5 <- U5 + Z_vary + Q + R + A0 + A1 + A2 + A3 + A4 + A5

#diagnose_design(design1, sims = 1000, bootstrap_sims = 200)
#diagnose_design(design2, sims = 1000, bootstrap_sims = 200)
#diagnose_design(design3, sims = 1000, bootstrap_sims = 200)
#diagnose_design(design4, sims = 1000, bootstrap_sims = 200)
# diagnose_design(design5, sims = 1000, bootstrap_sims = 200)

# (Takes a minute...):
# diag_des <- diagnose_designs(design1, design2, design4,
#                              sims = 1000,
#                              bootstrap_sims = 200)

# See 10 slides for this figure:
diag_des$diagnosands_df %>%
 ggplot(aes(bias, estimator_label)) +
   geom_point() +
   geom_vline(xintercept = 0,
              colour = "red",
              linetype = "dashed") +
 facet_wrap(~ design_label)

#ggsave("10-bias-twolevelblocking.pdf")
