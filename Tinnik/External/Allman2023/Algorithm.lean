module

public import Allman2023.MainResult.Algorithm
public import Allman2023.Networks.Bridges

/-!
# Allman, Baños, Mitchell, Rhodes 2023: the outline of an algorithm in Section 5

Section 5 of Allman et al. 2023 outlines the algorithm that TINNiK develops, and its Definition 1
and Definition 11 give the binary networks and the reduced unrooted tree of blobs `T_rd(𝒩⁻)` in
which the outline's claim of consistency is stated. TINNiK's algorithm and the outline use the
quartet distance of Rhodes 2020 on the closure under the B-quartet inference rule.

Each result is stated in the source's terms, those of lean4-allman2023 and of the libraries, and
proved from the theorem of lean4-allman2023 named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork
open Allman2023 (IsBinaryNetwork Trd)
open scoped Classical

namespace External.Allman2023

section Algorithm

variable {X : Type*} [DecidableEq X]

/-- The closure under the rule holds only of sets of four taxa, when the sets it starts from are.
lean4-allman2023 proves it as `Allman2023.Algorithm.card_of_bInferred`. -/
theorem card_of_bInferred {B₀ : Set (Finset X)} {τ : Set (QuartetTree X)}
    (hB₀ : ∀ q ∈ B₀, q.card = 4) {q : Finset X} (h : BInferred B₀ τ q) : q.card = 4 :=
  _root_.Allman2023.Algorithm.card_of_bInferred hB₀ h

variable [Fintype X]

/-- The quartet distance depends only on the sets of four taxa in its first argument.
lean4-allman2023 proves it as `Allman2023.Algorithm.quartetDistance_congr`. -/
theorem quartetDistance_congr {Bq Bq' : Set (Finset X)} {τ : Set (QuartetTree X)}
    (h1 : ∀ q : Finset X, q.card = 4 → (q ∈ Bq ↔ q ∈ Bq')) (x y : X) :
    quartetDistance Bq τ x y = quartetDistance Bq' τ x y :=
  _root_.Allman2023.Algorithm.quartetDistance_congr h1 x y

end Algorithm

section Networks

variable {V E X : Type*} {N : RootedNetwork V E X}

/-- A network of Definition 1 is a rooted phylogenetic network. lean4-allman2023 proves it as
`Allman2023.IsBinaryNetwork.isPhylogenetic`. -/
theorem isPhylogenetic_of_isBinaryNetwork (hN : IsBinaryNetwork N) : N.IsPhylogenetic :=
  hN.isPhylogenetic

/-- A network of Definition 1 is binary. lean4-allman2023 proves it as
`Allman2023.IsBinaryNetwork.isBinary`. -/
theorem isBinary_of_isBinaryNetwork (hN : IsBinaryNetwork N) : N.IsBinary :=
  hN.isBinary

/-- The splits of the reduced unrooted tree of blobs `T_rd(𝒩⁻)` of Definition 11 are the sides of the
cut edges of the network with a taxon on each side. lean4-allman2023 proves it as
`Allman2023.Bridges.splits_Trd`. -/
theorem splits_Trd [Fintype X] [DecidableEq X] (hN : IsBinaryNetwork N) (hX : Nontrivial X) :
    (Trd hN hX).splits = treeOfBlobs N :=
  _root_.Allman2023.Bridges.splits_Trd hN hX

end Networks

end External.Allman2023
