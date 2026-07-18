library(here)
library(stargazer)
library(tidyverse)

n <- 40

tr_effect <- 2

df <- tibble(
  state = rep(letters[1:n], 2),
  year = rep(c(2018, 2022), each = n),
  fct_year = factor(year),
  has_law = c(rep(0, n * 1.5), rep(1, n * 0.5)),
  ever_has_law = rep(c(0, 1, 0, 1), each = n / 2),
  y = rnorm(n) + ever_has_law + tr_effect * has_law)

df <- df |> mutate(y = case_when(year == 2022 ~ y + 0.5, 
                                 TRUE ~ y))

lm_currently_tr <- lm(y ~ fct_year * has_law, data = df)
lm_ever_tr <- lm(y ~ fct_year * ever_has_law, data = df)

stargazer(lm_ever_tr,
          lm_currently_tr,
          dep.var.caption = "Outcome",
          title = "Ever-treated vs. Currently-treated DiD Regressions",
          label = "didtable", 
          covariate.labels = c("2022", "Tr (Ever)", 
                               "2022 x Tr (Ever)", "Tr (Now)",
                               "2022 x Tr (Now)", "(Intercept)"))

ggplot(df, aes(fct_year, y)) + geom_boxplot()

t.test(y ~ fct_year, data = df |> filter(ever_has_law == 1))

t.test(y ~ fct_year, data = df |> filter(ever_has_law == 0))

t.test(y ~ fct_year, data = df |> filter(has_law == 0))

df_summ <- df |> group_by(fct_year, ever_has_law) |> summarise(meany = mean(y))

y18_0 <- df_summ |> ungroup() |>
  filter(fct_year == "2018" & ever_has_law == 0) |> select(meany) |>
  unname() |> unlist()
y22_0 <- df_summ |> ungroup() |>
  filter(fct_year == "2022" & ever_has_law == 0) |> select(meany) |>
  unname() |> unlist()
y18_1 <- df_summ |> ungroup() |>
  filter(fct_year == "2018" & ever_has_law == 1) |> select(meany) |>
  unname() |> unlist()
y22_1 <- df_summ |> ungroup() |>
  filter(fct_year == "2022" & ever_has_law == 1) |> select(meany) |>
  unname() |> unlist()

# DiD estimate = 1:
(y22_1 - y22_0) - (y18_1 - y18_0)

ggplot(df_summ, aes(fct_year, meany, group = ever_has_law)) + 
  geom_point() + 
  labs(x = "Year", y = "Outcome", 
       colour = "Tr (ever)",
       shape = "Tr (ever)") +
  geom_segment(aes(x = "2018",
                   xend = "2022",
                   y = y18_0,
                   yend = y22_0)) + 
  geom_segment(aes(x = "2018",
                   xend = "2022",
                   y = y18_1,
                   yend = y22_1)) +
  geom_point(data = df, 
             mapping = aes(fct_year, y, 
                           colour = factor(ever_has_law),
                           shape = factor(ever_has_law)),
                           alpha = 0.5)

ggsave(here("notes", "figs", "09-did_sim.pdf"))  
               