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

## Decision rule (defined before analysis)
- If gate_40 has significantly higher retention_7 → recommend moving the gate to level 40
- If gate_40 has significantly lower retention_7 → recommend keeping the gate at level 30
- If the difference is not significant → keep the gate at level 30 (current version).
  Without evidence that gate_40 is better, there is no reason to change the game.

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