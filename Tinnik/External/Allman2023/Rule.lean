module

public import Allman2023.LargeNetworks.Rule
public import Allman2023.LargeNetworks.CutOrder

/-!
# Allman, Baños, Mitchell, Rhodes 2023: the B-quartet inference rule and its closure

TINNiK's Theorems 2 and 3 are the B-quartet inference rule of Allman et al. 2023 (their Theorem 2)
and the combinatorial part of their Theorem 3. TINNiK's B-quartet Inference Algorithm computes the
closure of the sets it judges B-quartets under the rule; on the sets of four taxa with no cut-edge
split on their induced networks, and the cut-edge splits of the others, that closure is exactly the
set of B-quartets. With the cut-edge splits of the induced networks, these are what the proof of
TINNiK's Theorem 4 uses to read the tree of blobs from correct tests.

Each result is stated in the source's terms, those of lean4-allman2023 and of the libraries, and
proved from the theorem of lean4-allman2023 named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork
open scoped Classical

namespace External.Allman2023

section Rule

variable {V E X : Type*} [Fintype X] [DecidableEq X] {N : RootedNetwork V E X}

/-- **Theorem 2, the rule, applied repeatedly** (`allman2023:a:thm:infrule`; TINNiK's Theorem 2):
everything the rule infers from the sets of four taxa with no cut-edge split on their induced
networks, and the cut-edge splits of the others, is a B-quartet. lean4-allman2023 proves it as
`Allman2023.closure_sound`, from its form of the rule `Allman2023.rule_core`. -/
theorem closure_sound (hN : N.IsPhylogenetic) {q : Finset X}
    (h : BInferred {q' | q'.card = 4 ∧ ¬ IsTreelike N q'} {s | InducedCutSplit N s} q) :
    IsBQuartet N q :=
  _root_.Allman2023.closure_sound hN h

/-- **Theorem 3, its combinatorial part** (`allman2023:a:thm:infer`; TINNiK's Theorem 3): the closure
under the rule reaches every B-quartet, at any degree. lean4-allman2023 proves it as
`Allman2023.closure_complete`. -/
theorem closure_complete (hN : N.IsPhylogenetic) {q : Finset X} (hq : q.card = 4)
    (hB : IsBQuartet N q) :
    BInferred {q' | q'.card = 4 ∧ ¬ IsTreelike N q'} {s | InducedCutSplit N s} q :=
  _root_.Allman2023.closure_complete hN hq hB

/-- A quartet tree displayed on the tree of blobs is a cut-edge split of its induced network.
lean4-allman2023 proves it as `Allman2023.inducedCutSplit_of_displays`. -/
theorem inducedCutSplit_of_displays (hN : N.IsPhylogenetic) {s : QuartetTree X}
    (h : Displays (treeOfBlobs N) s) : InducedCutSplit N s :=
  _root_.Allman2023.inducedCutSplit_of_displays hN h

/-- The quartet trees displayed on the tree of blobs are the cut-edge splits of the induced networks
on the sets of four taxa that are not B-quartets. lean4-allman2023 proves it as
`Allman2023.displays_treeOfBlobs_iff`. -/
theorem displays_treeOfBlobs_iff (hN : N.IsPhylogenetic) (s : QuartetTree X) :
    Displays (treeOfBlobs N) s ↔ InducedCutSplit N s ∧ ¬ IsBQuartet N s.taxa :=
  _root_.Allman2023.displays_treeOfBlobs_iff hN s

end Rule

section CutOrder

variable {V E X : Type*} [DecidableEq X] {N : RootedNetwork V E X}

/-- A set of four taxa has at most one quartet tree that is a cut-edge split of its induced network.
lean4-allman2023 proves it as `Allman2023.inducedCutSplit_unique`. -/
theorem inducedCutSplit_unique (hN : N.IsPhylogenetic) {s s' : QuartetTree X}
    (hs : InducedCutSplit N s) (hs' : InducedCutSplit N s') (h : s.taxa = s'.taxa) : s = s' :=
  _root_.Allman2023.inducedCutSplit_unique hN hs hs' h

/-- A cut-edge split of the induced network is a split off the empty deletion. lean4-allman2023
proves it as `Allman2023.inducedCutSplit_iff_exists_splitOffAt`. -/
theorem inducedCutSplit_iff_exists_splitOffAt (hN : N.IsPhylogenetic) (s : QuartetTree X) :
    InducedCutSplit N s ↔ ∃ e, N.SplitOffAt ∅ e s :=
  _root_.Allman2023.inducedCutSplit_iff_exists_splitOffAt hN s

end CutOrder

end External.Allman2023
