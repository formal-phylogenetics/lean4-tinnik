module

public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

/-!
# The tangent near `π / 2`

Two identities of the tangent that the proof of Proposition 6 (`Tinnik.AppendixC.Proposition6`)
uses to place the sectors of its integrals.
-/

@[expose] public section

namespace Real

/-- `-tan (π / 2 + x) = tan (π / 2 - x)`. -/
theorem neg_tan_pi_div_two_add (x : ℝ) : -tan (π / 2 + x) = tan (π / 2 - x) := by
  rw [show π / 2 + x = π - (π / 2 - x) by ring, tan_pi_sub, neg_neg]

/-- `tan (π / 2 - α) = cos α / sin α`. -/
theorem tan_pi_div_two_sub_eq_cos_div_sin (α : ℝ) : tan (π / 2 - α) = cos α / sin α := by
  rw [tan_eq_sin_div_cos, sin_pi_div_two_sub, cos_pi_div_two_sub]

end Real
