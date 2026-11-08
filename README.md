# A/B Test: Cookie Cats

## Background
Cookie Cats is a mobile puzzle game. As players progress, they reach gates:
points where they must wait or make an in-app purchase to continue.

In this A/B test, the first gate was moved from level 30 to level 40.
Each player was randomly assigned to one of two groups when they installed the game:
- gate_30: control (gate at level 30)
- gate_40: test (gate at level 40)

The dataset contains 90,189 players who installed the game while the test was running.

## Business question
Does moving the first gate from level 30 to level 40 change player retention?

## Hypotheses
- H0: retention is the same in gate_30 and gate_40
- H1: retention is different (two-sided test, because moving the gate could also decrease retention)

## Metrics
- Primary metric: retention_7 (did the player come back 7 days after install).
  It shows long-term engagement, and many players reach the gate only after day 1.
- Secondary metrics: retention_1, sum_gamerounds
- Guardrail: not available (no revenue data)

  ## Test design
- Unit: player (each player is in one group only)
- Groups: gate_30 (control), gate_40 (test)
- Sample size: 90,188 players after cleaning
- Significance level: α = 0.05 for the primary metric
- Secondary metrics: α = 0.025 each (Bonferroni correction for 2 extra tests)

| Metric | Type | Test |
|---|---|---|
| retention_7 (primary) | true/false | two-proportion z-test |
| retention_1 | true/false | two-proportion z-test |
| sum_gamerounds | skewed count | Mann-Whitney U test |

Why Mann-Whitney for game rounds: the data is heavily skewed (median 16, mean 51),
so a test based on averages would be driven by a few very active players.

## Minimum detectable effect (MDE)
- Baseline 7-day retention (both groups together): 18.61%
- With ~44,700 players per group, α = 0.05 (two-sided) and 80% power,
  the smallest difference this test can reliably detect is **0.73 percentage points**
  (3.9% relative to the baseline).
- If the real effect is smaller than this, the test will probably not detect it.
  A non-significant result means "no difference larger than ~0.7 points",
  not "no difference at all".

  ## Decision rule (defined before analysis)
- If gate_40 has significantly higher retention_7 → recommend moving the gate to level 40
- If gate_40 has significantly lower retention_7 → recommend keeping the gate at level 30
- If the difference is not significant → keep the gate at level 30 (current version).
  Without evidence that gate_40 is better, there is no reason to change the game.

## Data quality notes
- No duplicate players and no missing values.
- Sample ratio check: gate_40 has 45,489 players and gate_30 has 44,700 (expected 45,094.5 each with a 50/50 split). Chi-square p = 0.0086.
  This is above the SRM threshold of 0.001, so the split is not considered broken, but the imbalance is probably not just random noise. The cause can't be checked (no install dates or platform data). Results should be read with some caution.
- 3,994 players (4.4%) played 0 rounds. They were kept: they were randomized at install and are part of the tested population.
- 111 zero-round players (0.12%) have retention = True, which is inconsistent.
  They were kept because it's not possible to tell which column is wrong.
- 1 player with 49,854 rounds was removed as a data error
  (impossible number of rounds and inconsistent with retention_1 = False).
- Sources disagree on whether sum_gamerounds covers the first 7 or 14 days after install.