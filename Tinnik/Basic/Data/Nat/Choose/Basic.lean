module

public import Mathlib.Data.Nat.Choose.Basic
public import Mathlib.Tactic.Ring

/-!
# Pascal's rule, unrolled

`C(x + k, k)` as the sum of `C(x + k - 1, k)` and the binomial coefficients `C(x + j - 1, j)` below it,
for `k = 2, 3, 4`. The index of a set of four taxa in lex order (`Tinnik.Algorithms.LexIndex`) uses them.
-/

@[expose] public section

namespace Nat

/-- Pascal's rule, down to the last term: `C(x + 4, 4) = C(x + 3, 4) + C(x + 2, 3) + C(x + 1, 2) + C(x, 1) + 1`. -/
theorem add_four_choose_four_eq (x : ℕ) :
    (x + 4).choose 4 = (x + 3).choose 4 + (x + 2).choose 3 + (x + 1).choose 2 + x.choose 1 + 1 := by
  have h₁ : (x + 4).choose 4 = (x + 3).choose 3 + (x + 3).choose 4 := Nat.choose_succ_succ (x + 3) 3
  have h₂ : (x + 3).choose 3 = (x + 2).choose 2 + (x + 2).choose 3 := Nat.choose_succ_succ (x + 2) 2
  have h₃ : (x + 2).choose 2 = (x + 1).choose 1 + (x + 1).choose 2 := Nat.choose_succ_succ (x + 1) 1
  have h₄ : (x + 1).choose 1 = x + 1 := Nat.choose_one_right _
  have h₅ : x.choose 1 = x := Nat.choose_one_right _
  omega

/-- `C(x + 3, 3) = C(x + 2, 3) + C(x + 1, 2) + C(x, 1) + 1`. -/
theorem add_three_choose_three_eq (x : ℕ) :
    (x + 3).choose 3 = (x + 2).choose 3 + (x + 1).choose 2 + x.choose 1 + 1 := by
  have h₂ : (x + 3).choose 3 = (x + 2).choose 2 + (x + 2).choose 3 := Nat.choose_succ_succ (x + 2) 2
  have h₃ : (x + 2).choose 2 = (x + 1).choose 1 + (x + 1).choose 2 := Nat.choose_succ_succ (x + 1) 1
  have h₄ : (x + 1).choose 1 = x + 1 := Nat.choose_one_right _
  have h₅ : x.choose 1 = x := Nat.choose_one_right _
  omega

/-- `C(x + 2, 2) = C(x + 1, 2) + C(x, 1) + 1`. -/
theorem add_two_choose_two_eq (x : ℕ) : (x + 2).choose 2 = (x + 1).choose 2 + x.choose 1 + 1 := by
  have h₃ : (x + 2).choose 2 = (x + 1).choose 1 + (x + 1).choose 2 := Nat.choose_succ_succ (x + 1) 1
  have h₄ : (x + 1).choose 1 = x + 1 := Nat.choose_one_right _
  have h₅ : x.choose 1 = x := Nat.choose_one_right _
  omega

end Nat
