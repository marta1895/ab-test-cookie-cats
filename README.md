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