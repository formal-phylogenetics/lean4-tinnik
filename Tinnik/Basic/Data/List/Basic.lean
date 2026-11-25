module

public import Mathlib.Data.List.Basic

/-!
# An invariant of a left fold

A property kept by each step of a left fold holds at its end. The counts of the B-quartet inference
algorithm (`Tinnik.Algorithms.Counts`) prove the invariants of its passes this way.
-/

@[expose] public section

namespace List

/-- An invariant of a fold. -/
theorem foldl_induction {α β : Type*} {f : α → β → α} {P : α → Prop} {l : List β}
    (hf : ∀ a, ∀ b ∈ l, P a → P (f a b)) {a : α} (h : P a) : P (l.foldl f a) := by
  induction l generalizing a with
  | nil => exact h
  | cons b l ih =>
    exact ih (fun a' b' hb' => hf a' b' (List.mem_cons_of_mem _ hb')) (hf a b List.mem_cons_self h)

end List
