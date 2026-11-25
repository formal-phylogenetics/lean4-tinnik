module

public import Mathlib.Data.Finset.Powerset
public import Mathlib.Data.Fintype.Powerset

/-!
# Families of sets of four

A family of sets of four elements of a finite type `X` has at most `C(|X|, 4)` members. The counts of
the B-quartet inference algorithm (`Tinnik.Algorithms.Counts`) bound the B-quartets this way.
-/

@[expose] public section

namespace Finset

/-- A family of sets of four elements has at most `C(N, 4)` members. -/
theorem card_le_choose_of_forall_card_eq_four {X : Type*} [Fintype X] {S : Finset (Finset X)}
    (hS : ∀ q ∈ S, q.card = 4) : S.card ≤ (Fintype.card X).choose 4 := by
  classical
  have : S ⊆ powersetCard 4 univ := fun q hq => mem_powersetCard.mpr ⟨subset_univ q, hS q hq⟩
  simpa [card_powersetCard] using card_le_card this

end Finset
