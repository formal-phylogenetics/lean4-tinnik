module

public import Tinnik.Defs
public import Tinnik.Consistency.Theorem4
public import Phylogenetics.NMSC.Inheritance

/-!
# The Challenge's definitions are the library's

The Challenge states its theorem on the definitions of `Tinnik.Defs` (namespace `Tinnik.Model`),
written in Mathlib's vocabulary. The library states it on those of `Phylogenetics`, `PhyloNetwork`
and `TreeOfBlobs`. This module proves that the two agree: most are equal by definition, once a
network of the Challenge is read as one of the library (`Network.toRooted`) and its parameters as the
library's (`Params.toMetric`).

* `Network.isPhylogenetic_iff`, `Network.isBinary_iff`, `Network.isMetric_iff`: the networks and
  their parameters.
* `Network.isGenericNull_iff`: null sets of parameters.
* `Network.geneTreeDist_eq`: the network multispecies coalescent with independent inheritance
  (`geneTreeDist … 0`).
* `Network.treeOfBlobs_eq`: the tree of blobs.
* `isExactBuilder_iff`, `isMLSelection_iff`, `iidProb_eq`, `quartetCount_eq`, `tinnik_eq`: the
  algorithm and its samples.
-/

@[expose] public noncomputable section

open Finset Phylogenetics Phylogenetics.RootedNetwork
open scoped Classical

namespace Tinnik.Model

variable {V E X : Type*}

/-- A graph of the Challenge as a graph of the library. -/
def Digraph.toDM (G : Digraph V E) : DirectedMultigraph V E := ⟨G.source, G.target⟩

/-- A network of the Challenge as a network of the library. -/
def Network.toRooted (N : Network V E X) : RootedNetwork V E X := ⟨N.graph.toDM, N.root, N.leaf⟩

/-- Parameters of the Challenge as parameters of the library. -/
def Params.toMetric (θ : Params E) : MetricData E := ⟨θ.length, θ.inheritance⟩

/-- Parameters of the library as parameters of the Challenge. -/
def ofMetric (θ : MetricData E) : Params E := ⟨θ.length, θ.inheritance⟩

@[simp] theorem toMetric_ofMetric (θ : MetricData E) : (ofMetric θ).toMetric = θ := rfl

@[simp] theorem ofMetric_toMetric (θ : Params E) : ofMetric θ.toMetric = θ := rfl

/-! ### Networks -/

namespace Network

variable (N : Network V E X)

/-- Rooted phylogenetic networks are the library's. -/
theorem isPhylogenetic_iff : N.IsPhylogenetic ↔ N.toRooted.IsPhylogenetic := by
  constructor
  · rintro ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩
    exact ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩
  · rintro ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩
    exact ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩

/-- Binary networks are the library's. -/
theorem isBinary_iff : N.IsBinary ↔ N.toRooted.IsBinary := Iff.rfl

/-- Valid parameters are the library's. -/
theorem isMetric_iff [Fintype E] (θ : Params E) : N.IsMetric θ ↔ N.toRooted.IsMetric θ.toMetric :=
  Iff.rfl

theorem isHybridArc_iff (e : E) : N.IsHybridArc e ↔ N.toRooted.IsHybridArc e := Iff.rfl

/-- Null sets of parameters are the library's, through `Params.toMetric`. -/
theorem isGenericNull_iff [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
    (A : Set (MetricData E)) :
    N.IsGenericNull (Params.toMetric ⁻¹' A) ↔ N.toRooted.IsGenericNull A := by
  have hset : ∀ d : V → E,
      {x : (E → ℝ) × (E → ℝ) | ∃ θ ∈ Params.toMetric ⁻¹' A, N.IsMetric θ ∧ θ.length = x.1 ∧
        ∀ e, N.IsHybridArc e → e ≠ d (N.graph.target e) → θ.inheritance e = x.2 e} =
      {x | ∃ θ ∈ A, N.toRooted.IsMetric θ ∧ θ.length = x.1 ∧
        ∀ e, N.toRooted.IsHybridArc e → e ≠ d (N.toRooted.graph.target e) →
          θ.inheritance e = x.2 e} := by
    intro d
    ext x
    constructor
    · rintro ⟨θ, hA, hθ, hl, hi⟩
      exact ⟨θ.toMetric, hA, hθ, hl, hi⟩
    · rintro ⟨θ, hA, hθ, hl, hi⟩
      exact ⟨ofMetric θ, hA, hθ, hl, hi⟩
  unfold IsGenericNull RootedNetwork.IsGenericNull
  simp only [hset]
  rfl

/-- The tree of blobs of the Challenge is the library's. -/
theorem treeOfBlobs_eq [Fintype X] [DecidableEq X] :
    N.treeOfBlobs = Phylogenetics.treeOfBlobs N.toRooted := rfl

/-! ### The coalescent -/

variable [Fintype V] [Fintype E] [Fintype X] [DecidableEq X] (θ : Params E)

omit [Fintype V] in
theorem arrivingForest_eq (top : E → Finset (Finset X)) (v : V) :
    N.arrivingForest top v = Phylogenetics.arrivingForest N.toRooted top v := rfl

omit [Fintype V] in
/-- The Challenge's allocation `∏ r, γ (a r)` is the library's `allocationWeight 0`. -/
theorem allocationFactor_eq (F : Finset (Finset X)) (v : V) (bot : E → Finset (Finset X)) :
    N.allocationFactor θ F v bot =
      Phylogenetics.allocationFactor N.toRooted θ.toMetric 0 F v bot := by
  unfold allocationFactor Phylogenetics.allocationFactor
  refine Finset.sum_congr rfl fun a _ => ?_
  exact ite_congr rfl (fun _ => (allocationWeight_rho_zero (γ := fun e :
    {e // N.toRooted.graph.target e = v} => θ.toMetric.inheritance e.val) a).symm) fun _ => rfl

theorem historyWeight_eq (bot top : E → Finset (Finset X)) :
    N.historyWeight θ bot top = Phylogenetics.historyWeight N.toRooted θ.toMetric 0 bot top := by
  unfold historyWeight Phylogenetics.historyWeight
  simp only [allocationFactor_eq, arrivingForest_eq]
  rfl

/-- **The network multispecies coalescent** of the Challenge is the library's, with independent
inheritance. -/
theorem geneTreeDist_eq (G : Finset (Finset X)) :
    N.geneTreeDist θ G = Phylogenetics.geneTreeDist N.toRooted θ.toMetric 0 G := by
  unfold geneTreeDist Phylogenetics.geneTreeDist
  simp only [historyWeight_eq, arrivingForest_eq]
  rfl

end Network

/-! ### The algorithm and its samples -/

section Algorithm

variable [Fintype X] [DecidableEq X]

omit [Fintype X] in
/-- The sets of four taxa that the B-quartet Inference Algorithm infers are the library's. -/
theorem bInferred_iff (B₀ : Set (Finset X)) (τ : Set (QuartetTree X)) (q : Finset X) :
    BInferred B₀ τ q ↔ Phylogenetics.BInferred B₀ τ q := by
  constructor
  · intro h
    induction h with
    | base q hq => exact .base q hq
    | ruleB a b c d e t q h5 _ _ ht _ hq ih₁ ih₂ ih₃ => exact .ruleB a b c d e t q h5 ih₁ ih₂ ht ih₃ hq
    | ruleT a b c d e s q h5 _ _ hs hst hsep hq ih₁ ih₂ => exact .ruleT a b c d e s q h5 ih₁ ih₂ hs hst hsep hq
  · intro h
    induction h with
    | base q hq => exact .base q hq
    | ruleB a b c d e t q h5 _ _ ht _ hq ih₁ ih₂ ih₃ => exact .ruleB a b c d e t q h5 ih₁ ih₂ ht ih₃ hq
    | ruleT a b c d e s q h5 _ _ hs hst hsep hq ih₁ ih₂ => exact .ruleT a b c d e s q h5 ih₁ ih₂ hs hst hsep hq

/-- Exact tree builders are the library's. -/
theorem isExactBuilder_iff (M : TreeBuilder X) : IsExactBuilder M ↔ Phylogenetics.IsExactBuilder M :=
  Iff.rfl

/-- Selections of maximum likelihood topologies are the library's. -/
theorem isMLSelection_iff (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) :
    IsMLSelection ml ↔ Phylogenetics.IsMLSelection ml := Iff.rfl

/-- Independent samples are the library's. -/
theorem iidProb_eq {Γ : Type*} [Fintype Γ] (dist : Γ → ℝ) (n : ℕ) (Ev : (Fin n → Γ) → Prop) :
    iidProb dist n Ev = Phylogenetics.iidProb dist n Ev := rfl

omit [Fintype X] in
/-- Counts of quartet trees are the library's. -/
theorem quartetCount_eq {Γ : Type*} [Fintype Γ] {n : ℕ} (sides : Γ → Finset (Finset X))
    (ω : Fin n → Γ) : quartetCount sides ω = Phylogenetics.quartetCount sides ω := rfl

/-- **The TINNiK algorithm** of the Challenge is the library's. -/
theorem tinnik_eq (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) (α β δ : ℝ)
    (M : TreeBuilder X) (c : QuartetTree X → ℝ) :
    tinnik ml α β δ M c = Phylogenetics.tinnik ml α β δ M c := by
  have hB : {q | BInferred (testedB ml α β c) (testedT ml α β c) q} =
      {q | Phylogenetics.BInferred (Phylogenetics.testedB ml α β c) (Phylogenetics.testedT ml α β c) q} :=
    Set.ext fun q => bInferred_iff _ _ q
  simp only [tinnik, Phylogenetics.tinnik]
  rw [hB]
  rfl

end Algorithm

end Tinnik.Model
