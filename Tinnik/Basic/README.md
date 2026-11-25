# General mathematics

Lemmas that say nothing about phylogenetics, filed by field as Mathlib files them and named as
Mathlib would name them, in Mathlib's namespaces, so that they can be contributed to Mathlib. They
import only Mathlib.

| File | Contents | Where it could go |
| --- | --- | --- |
| [`Data/Nat/Choose/Basic.lean`](Data/Nat/Choose/Basic.lean) | Pascal's rule unrolled: `C(x + k, k)` as `C(x + k - 1, k)` plus the coefficients below it, for `k = 2, 3, 4` ([`Nat.add_two_choose_two_eq`](Data/Nat/Choose/Basic.lean#L37), [`Nat.add_three_choose_three_eq`](Data/Nat/Choose/Basic.lean#L28), [`Nat.add_four_choose_four_eq`](Data/Nat/Choose/Basic.lean#L18)), which the index of a set of four taxa in lex order uses | `Mathlib/Data/Nat/Choose/Basic.lean` |
| [`Data/List/Basic.lean`](Data/List/Basic.lean) | a property kept by every step of a left fold holds at its end ([`List.foldl_induction`](Data/List/Basic.lean#L17)), for the invariants of the passes of the B-quartet Inference Algorithm | `Mathlib/Data/List/Basic.lean` |
| [`Data/Finset/Powerset.lean`](Data/Finset/Powerset.lean) | a family of sets of four elements of a finite type has at most `C(N, 4)` members ([`Finset.card_le_choose_of_forall_card_eq_four`](Data/Finset/Powerset.lean#L18)) | `Mathlib/Data/Finset/Powerset.lean` |
| [`Analysis/SpecialFunctions/Trigonometric/Basic.lean`](Analysis/SpecialFunctions/Trigonometric/Basic.lean) | `-tan (π / 2 + x) = tan (π / 2 - x)` and `tan (π / 2 - α) = cos α / sin α` ([`Real.neg_tan_pi_div_two_add`](Analysis/SpecialFunctions/Trigonometric/Basic.lean#L17), [`Real.tan_pi_div_two_sub_eq_cos_div_sin`](Analysis/SpecialFunctions/Trigonometric/Basic.lean#L21)), for the sectors of the proof of Proposition 6 | `Mathlib/Analysis/SpecialFunctions/Trigonometric/Basic.lean` |
| [`Algebra/Order/Field/Basic.lean`](Algebra/Order/Field/Basic.lean) | the point of the line `y = γ x` closest to `(z₁, z₂)` ([`Real.line_projection_minimizes`](Algebra/Order/Field/Basic.lean#L22)), for the distances to the cut-model lines in the proof of Proposition 5 | `Mathlib/Analysis/InnerProductSpace/Projection/Basic.lean`, as a special case |

Some general facts stay where they are used, because they rest on the paper's notation: the
rotations and polar densities of the figures of Proposition 6 ([`Tinnik.Prop6.rotate_two_mul_β₀`](../AppendixC/Proposition6.lean#L462),
[`Tinnik.Prop6.polarDensity_rotated_pi_div_two_add`](../AppendixC/Proposition6.lean#L281), …), and the sets of four taxa that share three
taxa, with their labels ([`Tinnik.exists_labels`](../Algorithms/Counts.lean#L287), [`Tinnik.labels_of_card_five`](../Algorithms/Counts.lean#L240)).

Before adding a lemma, search Mathlib and lean4-phylogenetics (`Phylogenetics/ForMathlib/`): a
lemma that a second repository of the collection needs moves up the tree, to the lowest node above
both (lean4-phylogenetics, docs/CONVENTIONS.md, Section 4).
