# Problem set 1

## Vojtěch Pohanka

### Exercise 2.1.

a)  Y~i~(0) denotes the potential outcome for unit i under the control condition/ when d = 0, that is the untreated potential outcome.

b)  Y~i~(0) \| D~i~ = 1 refers to the untreated potential outcome for unit i that would be treated under a hypothetical allocation of treatments, while Y~i~(0) \| d~i~ = 1 is the untreated potential outcome for a unit that actually received treatment in a study. So D~i~ denotes treatment status in a hypothetical allocation while d~i~ denotes actually observed treatment status.

c)  Y~i~(0) is simply the untreated potential outcome for unit i, while Y~i~(0) \| D~i~ = 0 is the untreated potential outcome for unit i that would not receive treatment in a hypothetical allocation of treatments, that is for a unit i that would be in the control group.

d)  Y~i~(0) \| D~i~ = 1 refers to the untreated potential outcome for unit assigned to the hypothetical treatment group while Y~i~(0) \| D~i~ = 0 is the untreated potential outcome for unit i assigned to the hypothetical control group.

e)  E[Y~i~(0)] is the expected untreated potential outcome for unit i. E[Y~i~(0) \| D~i~ = 1] is the expected untreated potential outcome for a unit i that is in the hypothetical treatment group.

f)  The reason is that under random assignment, treatment status D~i~ unrelated to potential outcomes. Therefore, the selection bias term E[Y~i~(0) \| D~i~ = 1] - E[Y~i~(0) \| D~i~ = 0] cancels itself out since the expectation of untreated potential outcomes for the treatment group E[Y~i~(0) \| D~i~ = 1] and the control group E[Y~i~(0) \| D~i~ = 1] have the same value.

### Exercise 2.10.

a)  When participants in the treatment group are informed that the goal of the study is to see if newspapers increase political interest, this may in and of itself affect their behavior and interest in politics through different mechanisms than the treatment itself. In this case, the potential outcomes conditional on the value of treatment assignment z are not the same, that is Y~i~(1, d) = Y~i~(0, d) does **not** hold.

b)  This is a violation of the SUTVA or non-interference assumption. If some units outside the treatment group start receiving the treatment, the randomization breaks down and the potential outcomes are no longer independent of treatment status. E[Y~i~(0) \| d~i~ = 1] = E[Y~i~(0) \| d~i~ = 0] will not hold.

### Exercise 2.12

a)  Due to self-selection into reading. The reading group is fundamentally different from the non-reading group, with different baseline levels of propensity to violence.

b)  If assignment to treatment leads to sitting in an enclosed space away from others for three hours a day, and if assignment to control entails going about the usual routine, then this is likely to influence violence through a different mechanism than through the reading itself. Specifically, the inmates assigned to treatment might simply have less chances to be violent with prison staff. Therefore, Y~i~(1, d) = Y~i~(0, d) does **not** hold.

c)  The assumption of non-interference here is that the reading habits of prisoners in the control group are not affected by the fact that other prisoners are going to the library for three hours a day. Another form of interference could be that other prisoners being in the library would affect the violence levels of control group prisoners.

d)  In the context of the prison study, the key assumption for the validity of the finding of a negative effect of reading on violence is that the treatment administration did not affect the violence levels of individuals in the control group.
