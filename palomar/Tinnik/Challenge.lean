module

public import Mathlib.Analysis.Normed.Algebra.MatrixExponential
public import Mathlib.Analysis.SpecialFunctions.Log.Basic
public import Mathlib.Analysis.SpecialFunctions.Sqrt
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Arctan
public import Mathlib.Data.Fintype.Powerset
public import Mathlib.Data.Set.Card
public import Mathlib.MeasureTheory.Constructions.Pi
public import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
public import Mathlib.MeasureTheory.Measure.Prod
public import Mathlib.Probability.Distributions.Gaussian.Real
public import Mathlib.Topology.Instances.Matrix

/-!
# TINNiK (Allman, Baños, Mitchell, Rhodes 2024): the main result

E. S. Allman, H. Baños, J. D. Mitchell, J. A. Rhodes, *TINNiK: inference of the tree of blobs of a
species network under the coalescent model*, Algorithms Mol. Biol. 19 (2024), 23: Theorem 4, the
statistical consistency of the TINNiK algorithm. This is the statement of record, with a `sorry`
proof; `Tinnik.Solution` proves it under the same name. The definitions are copied from
`Tinnik/Defs.lean` by `scripts/sync_challenge_defs.py`, and this module imports only Mathlib.

## Conventions

* A `Network V E X` is a directed multigraph on the vertices `V` with named arcs `E`, a root, and the
  vertex of each taxon of `X`. `IsPhylogenetic` is a rooted phylogenetic network: finite, acyclic, its
  root of in-degree zero reaching every vertex, and its vertices of out-degree zero exactly the
  vertices of the taxa, bijectively, each of in-degree one. `IsBinary`: the root has out-degree two
  and every other vertex that is not a leaf has degree three. Parallel arcs are allowed.
* `Params E` gives each arc a length, in coalescent units, and an inheritance probability.
  `IsMetric`: tree arcs have positive length and inheritance probability one, hybrid arcs (into a
  vertex of in-degree at least two) non-negative length and positive inheritance probability, and the
  inheritance probabilities into each such vertex sum to one.
* `IsGenericNull A`: the parameters of `A` that are valid form a Lebesgue-null set, in the coordinates
  given by all arc lengths and, at each vertex of in-degree at least two, the inheritance probabilities
  of all its entering arcs but one, for every choice of the arc left out. Theorem 4 holds outside such
  a set: "for generic numerical parameters".
* `geneTreeDist θ G` is the probability, under the network multispecies coalescent with independent
  inheritance at the hybrid vertices, of the rooted gene tree `G`, given by its clusters, with one
  lineage per taxon: Kingman's coalescent along each arc, for its length, and above the root, for an
  infinite time (`kingmanTransition`, `kingmanAbsorption`, the exponential of the generator and its
  limit), and an independent choice of parent arc for each lineage at a hybrid vertex.
  `iidProb dist m Ev` is the probability that `m` independent draws from `dist` lie in `Ev`.
* An unrooted tree on the taxa is given by the sides of its splits, and a quartet tree `ab|cd` by the
  pair of its cherries; `Displays T s` says that a split of `T` restricts to `s`. `quartetCount unroot
  ω s` is the number of the gene trees of the sample `ω` that display `s`. `treeOfBlobs` is the tree
  of blobs, by its splits: the sides of the cut edges of the network with a taxon on each side.
* The tests on the counts `c` of the three quartet trees on four taxa: the star test, by the likelihood
  ratio against `χ²₂` (`starPValue`), and the cut test of Appendix C (`cutPValue`), whose p-value is the
  upper tail of the distribution of Proposition 5 at the likelihood ratio statistic `cutStat`, with
  `φ` estimated on the line of the maximum likelihood topology. `IsMLSelection ml`: `ml c q` is a
  maximum likelihood topology on the four taxa `q`, one with the least statistic of its line.
* `tinnik ml α β δ M c` is the algorithm's output on the quartet counts `c`: the sets of four taxa on
  which the star test does not reject at level `β` or the cut test rejects at level `α` (`testedB`),
  closed under the B-quartet inference rule (`BInferred`); the quartet distance of Rhodes (2020) built
  from them and from the maximum likelihood topologies of the other sets (`quartetDistance`); the tree
  that the distance method `M` builds from it; and the contraction of its internal edges of weight
  less than `δ` or not positive. `IsExactBuilder M`: from the metric of a tree with positive edge
  weights, `M` returns a tree resolving it with the same weights, its other edges of weight at most
  zero, as neighbor joining does.
-/

-- BEGIN SHARED DEFINITIONS

/-! ## Networks

A rooted network is a directed multigraph with named arcs (two arcs may join the same two vertices),
a root and a labelling of the taxa by vertices. Its numerical parameters are a length for every arc,
in coalescent units, and an inheritance probability for every arc. -/

@[expose] public noncomputable section

open Finset MeasureTheory ProbabilityTheory
open scoped Classical

namespace Tinnik.Model

/-- A directed multigraph: each arc `e` goes from `source e` to `target e`. -/
structure Digraph (V E : Type*) where
  source : E → V
  target : E → V

namespace Digraph

variable {V E : Type*} (G : Digraph V E)

/-- An arc leads from `u` to `v`. -/
def Adj (u v : V) : Prop := ∃ e, G.source e = u ∧ G.target e = v

/-- A directed path, possibly empty, leads from `u` to `v`. -/
def Reaches : V → V → Prop := Relation.ReflTransGen G.Adj

/-- No nonempty directed path from a vertex to itself. -/
def IsAcyclic : Prop := ∀ v, ¬ Relation.TransGen G.Adj v v

/-- The number of arcs entering `v`. -/
def indegree (v : V) : ℕ := {e | G.target e = v}.ncard

/-- The number of arcs leaving `v`. -/
def outdegree (v : V) : ℕ := {e | G.source e = v}.ncard

/-- The arc `e` crosses the bipartition `S | Sᶜ` of the vertices, in either direction. -/
def Crosses (e : E) (S : Set V) : Prop :=
  (G.source e ∈ S ∧ G.target e ∉ S) ∨ (G.target e ∈ S ∧ G.source e ∉ S)

end Digraph

/-- A rooted network on the taxa `X`: a directed multigraph, its root, and the vertex of each
taxon. -/
structure Network (V E X : Type*) where
  graph : Digraph V E
  root : V
  leaf : X → V

/-- The numerical parameters of a network: arc lengths, in coalescent units, and inheritance
probabilities. -/
structure Params (E : Type*) where
  length : E → ℝ
  inheritance : E → ℝ

namespace Network

variable {V E X : Type*} (N : Network V E X)

/-- A *rooted phylogenetic network* (TINNiK, "Phylogenetic networks"): a finite directed acyclic graph
in which the root, of in-degree zero, reaches every vertex; the vertices of out-degree zero are
exactly the vertices of the taxa, bijectively, each of in-degree one. -/
structure IsPhylogenetic : Prop where
  finite_vertices : Finite V
  finite_arcs : Finite E
  finite_taxa : Finite X
  acyclic : N.graph.IsAcyclic
  root_reaches : ∀ v, N.graph.Reaches N.root v
  root_indegree : N.graph.indegree N.root = 0
  nonroot_indegree : ∀ v, v ≠ N.root → 1 ≤ N.graph.indegree v
  leaf_injective : Function.Injective N.leaf
  leaf_indegree : ∀ x, N.graph.indegree (N.leaf x) = 1
  leaves : ∀ v, N.graph.outdegree v = 0 ↔ ∃ x, N.leaf x = v

/-- A *tree arc* enters a vertex with one entering arc. -/
def IsTreeArc (e : E) : Prop := N.graph.indegree (N.graph.target e) = 1

/-- A *hybrid arc* enters a vertex with at least two entering arcs. -/
def IsHybridArc (e : E) : Prop := 2 ≤ N.graph.indegree (N.graph.target e)

/-- The network is *binary*: the root has out-degree two, and every other vertex that is not a leaf
has in-degree and out-degree summing to three. -/
def IsBinary : Prop :=
  N.graph.outdegree N.root = 2 ∧
    ∀ v, v ≠ N.root → N.graph.outdegree v ≠ 0 →
      N.graph.indegree v + N.graph.outdegree v = 3

/-- *Valid numerical parameters*: tree arcs have positive length and inheritance probability one,
hybrid arcs non-negative length and positive inheritance probability, and the inheritance
probabilities of the arcs entering a vertex with several entering arcs sum to one. -/
def IsMetric [Fintype E] (m : Params E) : Prop :=
  (∀ e, N.IsTreeArc e → 0 < m.length e) ∧
  (∀ e, N.IsHybridArc e → 0 ≤ m.length e) ∧
  (∀ e, N.IsTreeArc e → m.inheritance e = 1) ∧
  (∀ e, N.IsHybridArc e → 0 < m.inheritance e) ∧
  ∀ v, 2 ≤ N.graph.indegree v →
    ∑ e, (if N.graph.target e = v then m.inheritance e else 0) = 1

/-- `A` is the set of taxa on one side of a cut edge: some arc is the only arc crossing a bipartition
`S | Sᶜ` of the vertices, and the taxa in `S` are `A`. -/
def HasCutSplit (A : Set X) : Prop :=
  ∃ (e : E) (S : Set V), (∀ f, N.graph.Crosses f S ↔ f = e) ∧ N.leaf ⁻¹' S = A

end Network

/-! ## Trees and quartet trees

A rooted tree on a set is given by its clusters, and an unrooted tree on the taxa by the sides of its
splits. A resolved quartet tree `ab|cd` is the pair of its cherries. -/

section Trees

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- A *hierarchy* on `X`, a rooted tree given by its clusters: it contains `X` and every singleton,
its clusters are nonempty, and any two of them are nested or disjoint. -/
def IsHierarchy (H : Finset (Finset X)) : Prop :=
  univ ∈ H ∧ (∀ x : X, {x} ∈ H) ∧ (∀ A ∈ H, A.Nonempty) ∧
    ∀ A ∈ H, ∀ B ∈ H, A ⊆ B ∨ B ⊆ A ∨ Disjoint A B

/-- The unrooted tree of a rooted tree `G`, given by its clusters: the sides of the splits of its
non-root clusters. -/
def unroot {L : Type*} [Fintype L] [DecidableEq L] (G : Finset (Finset L)) : Finset (Finset L) :=
  G.erase univ ∪ (G.erase univ).image compl

/-- An *unrooted tree* on `X`, given by the sides of its splits: those of a hierarchy. -/
def IsUnrootedTree (T : Finset (Finset X)) : Prop :=
  ∃ H : Finset (Finset X), IsHierarchy H ∧ unroot H = T

/-- A resolved quartet tree `ab|cd`: the pair of its two disjoint cherries `{a, b}`, `{c, d}`. -/
def IsQuartetTree (s : Finset (Finset X)) : Prop :=
  s.card = 2 ∧ (∀ B ∈ s, B.card = 2) ∧ ∀ B ∈ s, ∀ C ∈ s, B ≠ C → Disjoint B C

/-- The resolved quartet trees on `X`. -/
abbrev QuartetTree (X : Type*) [DecidableEq X] := {s : Finset (Finset X) // IsQuartetTree s}

instance : Fintype (QuartetTree X) := Fintype.ofFinite _

omit [Fintype X] in
/-- The four taxa of a quartet tree. -/
def QuartetTree.taxa (s : QuartetTree X) : Finset X := s.val.sup id

/-- The two quartet trees on the taxa of `s` other than `s`. -/
def QuartetTree.alternatives (s : QuartetTree X) : Finset (QuartetTree X) :=
  univ.filter fun r => r.taxa = s.taxa ∧ r ≠ s

/-- The three quartet trees on the four taxa `q`. -/
def treesOn (q : Finset X) : Finset (QuartetTree X) := univ.filter fun r => r.taxa = q

/-- The tree `T`, given by the sides of its splits, *displays* the quartet tree `s`: some split
restricts to `s` on its four taxa. -/
def Displays (T : Finset (Finset X)) (s : QuartetTree X) : Prop := ∃ A ∈ T, A ∩ s.taxa ∈ s.val

/-- The sides of the internal edges of `T`: both sides have at least two taxa. -/
def internalSides (T : Finset (Finset X)) : Finset (Finset X) :=
  T.filter fun A => 2 ≤ A.card ∧ 2 ≤ Aᶜ.card

/-- The taxa `a`, `e` are *separated* in the quartet tree `s`: they are in different cherries. -/
def Separated (s : QuartetTree X) (a e : X) : Prop :=
  a ∈ s.taxa ∧ e ∈ s.taxa ∧ ∀ B ∈ s.val, ¬ (a ∈ B ∧ e ∈ B)

/-- The quartet distance of Rhodes (2020, Theorem 2), from a family `Bq` of unresolved sets of four
taxa and a family `τ` of resolved quartet trees: for `x ≠ y`, `2 |Q_{x,y}| + 2N - 4`, where
`Q_{x,y}` holds the sets of `Bq` that contain `x` and `y` and the quartet trees of `τ` that separate
them, and `N` is the number of taxa. -/
def quartetDistance (Bq : Set (Finset X)) (τ : Set (QuartetTree X)) (x y : X) : ℝ :=
  if x = y then 0 else
    2 * (((univ.filter fun q : Finset X =>
        q.card = 4 ∧ x ∈ q ∧ y ∈ q ∧ (q ∈ Bq ∨ ∃ s ∈ τ, s.taxa = q ∧ Separated s x y)).card : ℕ) : ℝ) +
      2 * (Fintype.card X : ℝ) - 4

/-- The tree metric of the tree with sides `T` and edge weights `w`: the total weight of the splits
separating two taxa. -/
def treeMetric (T : Finset (Finset X)) (w : Finset X → ℝ) (x y : X) : ℝ :=
  ∑ A ∈ T.filter (fun A => x ∈ A ∧ y ∉ A), w A

/-- A distance-based tree building method, such as neighbor joining: from a dissimilarity on the
taxa, a tree, given by the sides of its splits, and edge weights. -/
abbrev TreeBuilder (X : Type*) := (X → X → ℝ) → Finset (Finset X) × (Finset X → ℝ)

/-- The method is *exact*: from the tree metric of a tree whose edge weights are positive and agree on
the two sides of an edge, it returns a tree resolving it with the same weights, and any further edges
have weight at most zero. -/
def IsExactBuilder (M : TreeBuilder X) : Prop :=
  ∀ (T : Finset (Finset X)) (w : Finset X → ℝ), IsUnrootedTree T →
    (∀ A ∈ T, 0 < w A ∧ w Aᶜ = w A) →
    IsUnrootedTree (M (treeMetric T w)).1 ∧ T ⊆ (M (treeMetric T w)).1 ∧
      (∀ A ∈ T, (M (treeMetric T w)).2 A = w A) ∧
      ∀ A ∈ (M (treeMetric T w)).1, A ∉ T → (M (treeMetric T w)).2 A ≤ 0

end Trees

namespace Network

variable {V E X : Type*} (N : Network V E X)

/-- The *tree of blobs* of the network, given by the sides of its splits: the nonempty proper sets of
taxa on one side of a cut edge. -/
def treeOfBlobs [Fintype X] [DecidableEq X] : Finset (Finset X) :=
  univ.filter fun A => A.Nonempty ∧ Aᶜ.Nonempty ∧ N.HasCutSplit (A : Set X)

end Network

/-! ## The network multispecies coalescent

A forest of gene lineages on the leaves `L` is the set of its clusters, and its roots are its maximal
clusters. Along an arc of length `t` the lineages coalesce by Kingman's coalescent, each pair of
roots merging at rate `1`; above the root, for an infinite time. At a vertex with several entering
arcs, each lineage independently takes each arc with its inheritance probability. -/

section Coalescent

variable {L : Type*} [Fintype L] [DecidableEq L]

/-- The roots of a forest: its maximal clusters. -/
def roots (F : Finset (Finset L)) : Finset (Finset L) := F.filter fun A => ∀ B ∈ F, A ⊆ B → B = A

/-- The generator of Kingman's coalescent on forests: each pair of distinct roots `A, B` merges at
rate `1`, adding the cluster `A ∪ B`. -/
def kingmanGenerator : Matrix (Finset (Finset L)) (Finset (Finset L)) ℝ :=
  fun F G =>
    if G = F then -((#(roots F)).choose 2 : ℝ)
    else if ∃ A ∈ roots F, ∃ B ∈ roots F, A ≠ B ∧ G = insert (A ∪ B) F then 1 else 0

/-- Kingman's coalescent over a time `t`: `exp (t • Q)`. -/
def kingmanTransition (t : ℝ) : Matrix (Finset (Finset L)) (Finset (Finset L)) ℝ :=
  NormedSpace.exp (t • kingmanGenerator)

/-- Kingman's coalescent over an infinite time: the limits as `t → ∞`. -/
def kingmanAbsorption : Matrix (Finset (Finset L)) (Finset (Finset L)) ℝ :=
  fun F G => Filter.limUnder Filter.atTop fun t : ℝ => kingmanTransition t F G

/-- The part of the forest `F` below its roots in `A`. -/
def forestBelow (F A : Finset (Finset L)) : Finset (Finset L) := F.filter fun B => ∃ C ∈ A, B ⊆ C

end Coalescent

namespace Network

variable {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
variable (N : Network V E X) (θ : Params E)

/-- The forest arriving at `v` from below: its taxon's lineage, if any, and the forests at the top of
the arcs leaving `v`. -/
def arrivingForest (top : E → Finset (Finset X)) (v : V) : Finset (Finset X) :=
  ((univ.filter fun x => N.leaf x = v).image fun x => ({x} : Finset X)) ∪
    (univ.filter fun e => N.graph.source e = v).biUnion top

/-- The probability that the roots of the forest `F` arriving at `v` choose the arcs entering `v`
that put the forests `bot e` at their bottoms: each root independently takes the arc `e` with the
inheritance probability of `e`. -/
def allocationFactor (F : Finset (Finset X)) (v : V) (bot : E → Finset (Finset X)) : ℝ :=
  ∑ a : {A // A ∈ roots F} → {e // N.graph.target e = v},
    if ∀ e : {e // N.graph.target e = v},
        bot e.val = forestBelow F ((univ.filter fun r => a r = e).image Subtype.val) then
      ∏ r, θ.inheritance (a r).val
    else 0

/-- The probability of a history: the forests `bot e` at the bottom and `top e` at the top of each
arc. -/
def historyWeight (bot top : E → Finset (Finset X)) : ℝ :=
  (∏ v ∈ univ.erase N.root, N.allocationFactor θ (N.arrivingForest top v) v bot) *
    ∏ e, kingmanTransition (θ.length e) (bot e) (top e)

/-- **The network multispecies coalescent**, with independent inheritance: the probability of the
rooted gene tree `G` (its clusters), with one lineage per taxon. -/
def geneTreeDist (G : Finset (Finset X)) : ℝ :=
  ∑ bot : E → Finset (Finset X), ∑ top : E → Finset (Finset X),
    N.historyWeight θ bot top * kingmanAbsorption (N.arrivingForest top N.root) G

/-- A set of parameters is *null*: Lebesgue-null in the coordinates given by all arc lengths and, at
each vertex with several entering arcs, the inheritance probabilities of all of them but one, for
every choice of the arc left out. The coordinates of the other arcs are dummies. -/
def IsGenericNull (A : Set (Params E)) : Prop :=
  ∀ d : V → E, (∀ v, 2 ≤ N.graph.indegree v → N.graph.target (d v) = v) →
    ((Measure.pi fun _ : E => (volume : Measure ℝ)).prod (Measure.pi fun _ : E => (volume : Measure ℝ)))
      {x | ∃ θ ∈ A, N.IsMetric θ ∧ θ.length = x.1 ∧
        ∀ e, N.IsHybridArc e → e ≠ d (N.graph.target e) → θ.inheritance e = x.2 e} = 0

end Network

/-! ## Samples of gene trees -/

section Sampling

variable {Γ : Type*} [Fintype Γ]

/-- The probability that `n` independent draws from the distribution `dist` on the finite set `Γ` lie
in the event `Ev`. -/
def iidProb (dist : Γ → ℝ) (n : ℕ) (Ev : (Fin n → Γ) → Prop) : ℝ :=
  ∑ ω : Fin n → Γ, if Ev ω then ∏ i, dist (ω i) else 0

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- The number of the gene trees `ω`, each given by the sides of its splits through `sides`, that
display the quartet tree `s`. -/
def quartetCount {n : ℕ} (sides : Γ → Finset (Finset X)) (ω : Fin n → Γ) (s : QuartetTree X) : ℝ :=
  ((univ.filter fun i => Displays (sides (ω i)) s).card : ℝ)

end Sampling

/-! ## The hypothesis tests

The tests on the counts `c` of the three quartet trees on a set of four taxa (TINNiK, "Statistical
testing and estimation for cut CFs", and its Appendix C). -/

section Tests

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- The likelihood ratio statistic for the cut-model line of the quartet tree `s`: twice the
difference of the maximal trinomial log-likelihoods, unconstrained and on the line `p_{s'} = p_{s''}`,
where `s'`, `s''` are the alternatives of `s` (Appendix C.1). `x log x` vanishes at `x = 0`. -/
def lineStat (c : QuartetTree X → ℝ) (s : QuartetTree X) : ℝ :=
  2 * (∑ r ∈ s.alternatives, c r * Real.log (c r) -
    (∑ r ∈ s.alternatives, c r) * Real.log (∑ r ∈ s.alternatives, c r) +
    (∑ r ∈ s.alternatives, c r) * Real.log 2)

/-- The likelihood ratio statistic of the star test on the taxa `q`: twice the difference of the
maximal trinomial log-likelihoods, unconstrained and at `(1/3, 1/3, 1/3)`. -/
def starStat (c : QuartetTree X → ℝ) (q : Finset X) : ℝ :=
  2 * (∑ r ∈ treesOn q, c r * Real.log (c r) -
    (∑ r ∈ treesOn q, c r) * Real.log ((∑ r ∈ treesOn q, c r) / 3))

/-- The upper tail at `t` of the `χ²` distribution with 2 degrees of freedom. -/
def chiSqTwoTail (t : ℝ) : ℝ := Real.exp (-t / 2)

/-- The p-value of the star test on the taxa `q`, by the likelihood ratio, against the `χ²₂`
distribution. -/
def starPValue (c : QuartetTree X → ℝ) (q : Finset X) : ℝ := chiSqTwoTail (starStat c q)

/-- The cut-model likelihood ratio statistic on the taxa `q`: the least of the statistics of its three
lines. -/
def cutStat (c : QuartetTree X → ℝ) (q : Finset X) : ℝ := ⨅ s : {s // s ∈ treesOn q}, lineStat c s.val

/-- The parameter `μ₀` of the test distribution, `√(2n) (1 - φ) / √(φ (3 - 2φ))`, for the point
`(1 - 2φ/3, φ/3, φ/3)` and the sample size `n`. -/
def muZero (φ n : ℝ) : ℝ := Real.sqrt (2 * n) * (1 - φ) / Real.sqrt (φ * (3 - 2 * φ))

/-- The angle `α₀` of Appendix C.2. -/
def alphaZero (φ : ℝ) : ℝ := Real.arctan (1 / Real.sqrt (3 * (3 - 2 * φ)))

/-- The upper tail at `t` of the distribution of Proposition 5, for `φ` and the sample size `n`: that
of `min(Z², (sin α₀ Z + cos α₀ Z̄)², (sin α₀ Z - cos α₀ Z̄)²)` for independent `Z ~ N(0, 1)` and
`Z̄ ~ N(μ₀, 1)`. -/
def cutTail (φ n t : ℝ) : ℝ :=
  ((gaussianReal 0 1).prod (gaussianReal (muZero φ n) 1)).real
    {z | t < min (z.1 ^ 2) (min ((Real.sin (alphaZero φ) * z.1 + Real.cos (alphaZero φ) * z.2) ^ 2)
      ((Real.sin (alphaZero φ) * z.1 - Real.cos (alphaZero φ) * z.2) ^ 2))}

/-- The p-value of the cut test, with `φ` estimated on the cut-model line of the quartet tree `s`
(Appendix C.2). -/
def cutPValue (c : QuartetTree X → ℝ) (s : QuartetTree X) : ℝ :=
  cutTail (3 * (∑ r ∈ s.alternatives, c r) / (2 * (c s + ∑ r ∈ s.alternatives, c r)))
    (c s + ∑ r ∈ s.alternatives, c r) (cutStat c s.taxa)

end Tests

/-! ## The algorithm -/

section Algorithm

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- The sets of four taxa inferred as B-quartets by the B-quartet Inference Algorithm: the sets `B₀`
judged by the hypothesis tests, closed under the rule of its Step 3, given the quartet trees `τ`
inferred in its Step 2c. -/
inductive BInferred (B₀ : Set (Finset X)) (τ : Set (QuartetTree X)) : Finset X → Prop
  | base (q : Finset X) : q ∈ B₀ → BInferred B₀ τ q
  | ruleB (a b c d e : X) (t q : Finset X) :
      ({a, b, c, d, e} : Finset X).card = 5 →
      BInferred B₀ τ {a, b, c, d} → BInferred B₀ τ {b, c, d, e} →
      t ∈ ({{a, b, c, e}, {a, b, d, e}, {a, c, d, e}} : Finset (Finset X)) → BInferred B₀ τ t →
      q ∈ ({{a, b, c, e}, {a, b, d, e}, {a, c, d, e}} : Finset (Finset X)) →
      BInferred B₀ τ q
  | ruleT (a b c d e : X) (s : QuartetTree X) (q : Finset X) :
      ({a, b, c, d, e} : Finset X).card = 5 →
      BInferred B₀ τ {a, b, c, d} → BInferred B₀ τ {b, c, d, e} →
      s ∈ τ → s.taxa ∈ ({{a, b, c, e}, {a, b, d, e}, {a, c, d, e}} : Finset (Finset X)) →
      Separated s a e →
      q ∈ ({{a, b, c, e}, {a, b, d, e}, {a, c, d, e}} : Finset (Finset X)) →
      BInferred B₀ τ q

/-- A selection of maximum likelihood topologies: on each set of four taxa, a quartet tree whose cut
line has the least statistic. -/
def IsMLSelection (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) : Prop :=
  ∀ c q, q.card = 4 → ml c q ∈ treesOn q ∧ ∀ r ∈ treesOn q, lineStat c (ml c q) ≤ lineStat c r

variable (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X)

/-- Step 2 of the B-quartet Inference Algorithm: the sets of four taxa judged B-quartets, those on which
the star test does not reject at level `β` or the cut test rejects at level `α`. -/
def testedB (α β : ℝ) (c : QuartetTree X → ℝ) : Set (Finset X) :=
  {q | q.card = 4 ∧ (β ≤ starPValue c q ∨ cutPValue c (ml c q) < α)}

/-- Step 2c: the maximum likelihood quartet trees of the other sets of four taxa. -/
def testedT (α β : ℝ) (c : QuartetTree X → ℝ) : Set (QuartetTree X) :=
  {s | s.taxa ∉ testedB ml α β c ∧ s = ml c s.taxa}

/-- **The TINNiK algorithm**, Steps 2 to 5, on the quartet counts `c`, with the levels `α`, `β`, the
tree builder `M` and the cutoff `δ`: the B-quartets inferred, the quartet distance, the tree that `M`
builds from it, and the contraction of its internal edges of weight less than `δ` or not positive. -/
def tinnik (α β δ : ℝ) (M : TreeBuilder X) (c : QuartetTree X → ℝ) : Finset (Finset X) :=
  let B := {q | BInferred (testedB ml α β c) (testedT ml α β c) q}
  let built := M (quartetDistance B {s | s ∈ testedT ml α β c ∧ s.taxa ∉ B})
  built.1.filter fun A => A ∉ internalSides built.1 ∨ (δ ≤ built.2 A ∧ 0 < built.2 A)

end Algorithm

end Tinnik.Model

end

-- END SHARED DEFINITIONS

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
  sorry

end TinnikChallenge

end
