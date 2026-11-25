module

public import Allman2023.FourTaxa.CFDetectable
public import Allman2023.FourTaxa.GenericCF

/-!
# Allman, Baños, Mitchell, Rhodes 2023: `CF`-detectability

TINNiK's Theorem 1 is the `CF`-detectability of 4-blobs of Allman et al. 2023 (their Theorem 1 and
Corollary 1): for generic parameters on a binary network, every induced 4-taxon network with a
4-blob has a non-cut concordance factor, and every one with a cut-edge split has a concordance
factor strictly cut at that split. The proof of TINNiK's Theorem 4 uses it, and, for the centroid,
statement (b) of the proof of Theorem 1 and the deleted networks of its statement (a).

Each result is stated in the source's terms, those of lean4-allman2023 and of the libraries, and
proved from the theorem of lean4-allman2023 named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork
open Allman2023 (CFDetectable IsNonCut deletionMetric)
open scoped Classical

namespace External.Allman2023

variable {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X] {N : RootedNetwork V E X}

/-- **Corollary 1, as `CF`-detectability** (`allman2023:a:cor:largeCFdetect`; TINNiK's Theorem 1):
for a rooted binary phylogenetic network, the numerical parameters at which the network multispecies
coalescent with independent inheritance fails `CF`-detectability on some induced 4-taxon network
form a null set. lean4-allman2023 proves it as `Allman2023.cfDetectable_generic`, from the step of
the proof of Corollary 1 on one 4-taxon network. -/
theorem cfDetectable_generic (hN : N.IsPhylogenetic) (hBin : N.IsBinary) :
    N.IsGenericNull {θ | N.IsMetric θ ∧ ¬ CFDetectable N (nmscCF N θ 0)} :=
  _root_.Allman2023.cfDetectable_generic hN hBin

/-- **Statement (b) of the proof of Theorem 1, on a set of four taxa of a network**
(`allman2023:a:claim:thm1b`): without a cut-edge split on its induced network, the concordance
factor is non-cut for generic parameters. lean4-allman2023 proves it as
`Allman2023.isGenericNull_not_isNonCut`. -/
theorem isGenericNull_not_isNonCut (hN : N.IsPhylogenetic) (hBin : N.IsBinary) {q : Finset X}
    (hq : q.card = 4) (hnt : ¬ IsTreelike N q) :
    IsGenericNull N {θ | N.IsMetric θ ∧ ¬ IsNonCut (nmscCF N θ 0) q} :=
  _root_.Allman2023.isGenericNull_not_isNonCut hN hBin hq hnt

omit [Fintype V] [Fintype X] [DecidableEq X] in
/-- The parameters of the deleted network of statement (a) of the proof of Theorem 1 are
normalized. lean4-allman2023 proves it as `Allman2023.isNormalized_deletionMetric`. -/
theorem isNormalized_deletionMetric (hN : N.IsPhylogenetic) {D : Set E} (hD : N.IsDeletion D)
    (ℓ : E → ℝ) : N.IsNormalized (deletionMetric N D ℓ) :=
  _root_.Allman2023.isNormalized_deletionMetric hN hD ℓ

/-- In statement (a) of the proof of Theorem 1, "`CF_{ab|cd}` can be made as close to 1 as desired":
an arc of length `3` that induces the split of `s` off a deletion makes the concordance factor of `s`
more than `3/4`. lean4-allman2023 proves it as `Allman2023.three_quarters_lt_nmscCF`. -/
theorem three_quarters_lt_nmscCF (hN : N.IsPhylogenetic) {D : Set E} (hD : N.IsDeletion D)
    {ℓ : E → ℝ} (hℓ : ∀ e, 0 ≤ ℓ e) {e : E} (he : ℓ e = 3) {s : QuartetTree X}
    (hs : N.SplitOffAt D e s) : 3 / 4 < nmscCF N (deletionMetric N D ℓ) 0 s :=
  _root_.Allman2023.three_quarters_lt_nmscCF hN hD hℓ he hs

omit [Fintype V] [Fintype E] [Fintype X] in
/-- Deleting more arcs keeps a split. lean4-allman2023 proves it as `Allman2023.splitOffAt_mono`. -/
theorem splitOffAt_mono {D D' : Set E} (hDD : D ⊆ D') {e : E} {s : QuartetTree X}
    (hs : N.SplitOffAt D e s) : N.SplitOffAt D' e s :=
  _root_.Allman2023.splitOffAt_mono hDD hs

end External.Allman2023
