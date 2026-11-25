module

public import Tinnik.Bridge.Model
public import Tinnik.Consistency.Theorem4

/-!
# The main result on the Challenge's definitions

Theorem 4, as the Challenge states it on the definitions of `Tinnik.Defs`, proved from the paper's
library (`Tinnik.theorem4`) through the bridges of `Tinnik.Bridge.Model`.
-/

@[expose] public noncomputable section

open Filter Topology Phylogenetics Phylogenetics.RootedNetwork

namespace Tinnik.Model

/-- **Theorem 4**, on the Challenge's definitions. -/
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
  obtain ⟨A, hA, h⟩ :=
    Tinnik.theorem4 ((Network.isPhylogenetic_iff N).mp hN) hX ((Network.isBinary_iff N).mp hBin)
  refine ⟨Params.toMetric ⁻¹' A, (N.isGenericNull_iff A).mpr hA, fun θ hθ hθA => ?_⟩
  obtain ⟨α, hα, hαpos, hrest⟩ := h θ.toMetric ((N.isMetric_iff θ).mp hθ) hθA
  refine ⟨α, hα, hαpos, fun β δ hβ hδ hδ₂ M hM ml hml => ?_⟩
  have key := hrest β δ hβ hδ hδ₂ M ((isExactBuilder_iff M).mp hM) ml ((isMLSelection_iff ml).mp hml)
  have hdist : N.geneTreeDist θ = Phylogenetics.geneTreeDist N.toRooted θ.toMetric 0 :=
    funext (N.geneTreeDist_eq θ)
  refine key.congr fun m => ?_
  rw [hdist, iidProb_eq]
  refine congrArg _ (funext fun ω => ?_)
  rw [tinnik_eq, quartetCount_eq, Network.treeOfBlobs_eq]
  rfl

end Tinnik.Model
