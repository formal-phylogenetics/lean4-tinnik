module

public import Mathlib.Basic.Real.Basic
public import Mathlib.Tactic.FieldSimp
public import Mathlib.Tactic.LinearCombination
public import Mathlib.Tactic.Linarith
public import Mathlib.Tactic.Positivity

/-!
# The closest point of a line through the origin

The point of the line `y = γ x` closest to `(z₁, z₂)` has abscissa `(z₁ + γ z₂) / (1 + γ²)`. The proof
of Proposition 5 (`Tinnik.AppendixC.LikelihoodRatio`) measures distances to the cut-model lines this
way.
-/

@[expose] public section

namespace Real

/-- The closest point to `(z₁, z₂)` on the line `y = γ x`. -/
theorem line_projection_minimizes (γ z₁ z₂ : ℝ) :
    let x₀ := (z₁ + γ * z₂) / (1 + γ ^ 2)
    ∀ x : ℝ, (z₁ - x₀) ^ 2 + (z₂ - γ * x₀) ^ 2 ≤ (z₁ - x) ^ 2 + (z₂ - γ * x) ^ 2 := by
  intro x₀ x
  have hpos : 0 < 1 + γ ^ 2 := by positivity
  have hid : (z₁ - x) ^ 2 + (z₂ - γ * x) ^ 2 =
      (z₁ - x₀) ^ 2 + (z₂ - γ * x₀) ^ 2 + (1 + γ ^ 2) * (x - x₀) ^ 2 := by
    have hx₀ : (1 + γ ^ 2) * x₀ = z₁ + γ * z₂ := by
      simp only [x₀]
      field_simp
    clear_value x₀
    linear_combination (2 * x - 2 * x₀) * hx₀
  rw [hid]
  have : 0 ≤ (1 + γ ^ 2) * (x - x₀) ^ 2 := by positivity
  linarith

end Real
