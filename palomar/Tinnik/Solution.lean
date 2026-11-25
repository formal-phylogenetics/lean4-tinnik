module

public import Tinnik.Bridge.Statements
public import Tinnik.Algorithms.Counts
public import Tinnik.Algorithms.LexIndex
public import Tinnik.AppendixC.OpenCutModel
public import Tinnik.AppendixC.Proposition6
public import Tinnik.Consistency.AllmanOutline
public import Tinnik.Consistency.MissingTaxa
public import Tinnik.Consistency.NJ
public import Tinnik.Consistency.T3
public import Tinnik.External.StudierKeppler1988.Lemma

/-! # TINNiK (Allman, Baños, Mitchell, Rhodes 2024): the proof of the statement of record

Restates the theorem of `Tinnik.Challenge` word for word, in the namespace `TinnikChallenge`, and
proves it from the library, through the bridges of `Tinnik.Bridge` between the Challenge's
definitions and the library's. It is the entry point of the library. -/

public section

namespace TinnikChallenge

open Tinnik.Model Filter Topology

/-- **Theorem 4.** For generic numerical parameters on a binary rooted phylogenetic network on at
least four taxa, there is a sequence of levels `α_m → 0` of the cut test such that, for any level
`β > 0` of the star test, any cutoff `0 ≤ δ < 2`, any exact distance method `M` and any selection
`ml` of maximum likelihood topologies, the TINNiK algorithm on `m` independent gene trees from the
network multispecies coalescent returns the tree of blobs with probability tending to one as `m`
grows. -/
theorem theorem4 {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
    {N : Network V E X} (hN : N.IsPhylogenetic) (hBin : N.IsBinary) (hX : 4 ≤ Fintype.card X) :
    ∃ A : Set (Params E), N.IsGenericNull A ∧
      ∀ θ, N.IsMetric θ → θ ∉ A →
        ∃ α : ℕ → ℝ, Tendsto α atTop (𝓝 0) ∧ (∀ m, 0 < α m) ∧
          ∀ (β δ : ℝ), 0 < β → 0 ≤ δ → δ < 2 →
          ∀ (M : TreeBuilder X), IsExactBuilder M →
          ∀ (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X), IsMLSelection ml →
            Tendsto (fun m => iidProb (N.geneTreeDist θ) m fun ω =>
              tinnik ml (α m) β δ M (quartetCount unroot ω) = N.treeOfBlobs) atTop (𝓝 1) := by
  exact Tinnik.Model.theorem4 hN hBin hX

end TinnikChallenge

end
