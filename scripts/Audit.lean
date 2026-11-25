module

public meta import Lean.Elab.Command
public meta import Lean.DocString
-- One `import all` line per module of the libraries, so that proofs are visible to the dependency
-- traversal (the module system hides them from a plain `import`): every module of `Tinnik/`
-- (`Basic/`, `External/` and the paper's library), the paper's Solution in `palomar/`, and every
-- module of the libraries `Phylogenetics`, `PhyloNetwork`, `TreeOfBlobs` and `Allman2023` that this
-- repository requires, but no Challenge, which holds a copy of the paper's definitions. Generate the
-- lines with
--   { find Tinnik -name '*.lean'; cd palomar && find . -name Solution.lean; } |
--     sed 's#^\./##; s/\.lean$//; s#/#.#g; s/^/import all /' | sort
-- and the same `find` in `.lake/packages/Phylogenetics`, `.lake/packages/PhyloNetwork`,
-- `.lake/packages/TreeOfBlobs` and `.lake/packages/Allman2023`.
import all Tinnik.Algorithms.Counts
import all Tinnik.Algorithms.LexIndex
import all Tinnik.AppendixC.Definitions
import all Tinnik.AppendixC.LikelihoodRatio
import all Tinnik.AppendixC.OpenCutModel
import all Tinnik.AppendixC.Proposition6
import all Tinnik.Basic.Algebra.Order.Field.Basic
import all Tinnik.Basic.Analysis.SpecialFunctions.Trigonometric.Basic
import all Tinnik.Basic.Data.Finset.Powerset
import all Tinnik.Basic.Data.List.Basic
import all Tinnik.Basic.Data.Nat.Choose.Basic
import all Tinnik.Bridge.Model
import all Tinnik.Bridge.Statements
import all Tinnik.Consistency.AllmanOutline
import all Tinnik.Consistency.MissingTaxa
import all Tinnik.Consistency.NJ
import all Tinnik.Consistency.T3
import all Tinnik.Consistency.Theorem4
import all Tinnik.Defs
import all Tinnik.External.StudierKeppler1988.Lemma
import all Tinnik.Solution
import all Phylogenetics.Coalescent.Absorption
import all Phylogenetics.Coalescent.BinaryForest
import all Phylogenetics.Coalescent.Defs
import all Phylogenetics.Coalescent.Factorization
import all Phylogenetics.Coalescent.Forest
import all Phylogenetics.Coalescent.Lump
import all Phylogenetics.Coalescent.Outcome
import all Phylogenetics.Coalescent.PMF
import all Phylogenetics.Coalescent.Relabel
import all Phylogenetics.Coalescent.Tavare
import all Phylogenetics.Coalescent.Trace
import all Phylogenetics.Computation.Caterpillar5
import all Phylogenetics.Computation.Codes
import all Phylogenetics.Computation.Engine
import all Phylogenetics.Computation.FiveTaxa
import all Phylogenetics.Computation.FourTaxa
import all Phylogenetics.Computation.ThreeTaxa
import all Phylogenetics.Computation.Toolkit
import all Phylogenetics.ForMathlib.Analysis.AnalyticZeroSet
import all Phylogenetics.ForMathlib.Analysis.MatrixExponential
import all Phylogenetics.ForMathlib.MeasureTheory.HaarPreimage
import all Phylogenetics.Graph.Basic
import all Phylogenetics.Graph.Blobs
import all Phylogenetics.Graph.BridgeCutLaminar
import all Phylogenetics.Graph.Connectivity
import all Phylogenetics.Graph.CutUniqueness
import all Phylogenetics.Graph.Defs
import all Phylogenetics.Graph.Degree
import all Phylogenetics.Graph.Tree
import all Phylogenetics.Hierarchy.Basic
import all Phylogenetics.Hierarchy.Counts
import all Phylogenetics.Hierarchy.Defs
import all Phylogenetics.Hierarchy.Quartets
import all Phylogenetics.Hierarchy.RootLocation
import all Phylogenetics.Hierarchy.SpeciesTree
import all Phylogenetics.MSC.Basic
import all Phylogenetics.MSC.Classify
import all Phylogenetics.MSC.Contract
import all Phylogenetics.MSC.Defs
import all Phylogenetics.MSC.History
import all Phylogenetics.MSC.Marginal
import all Phylogenetics.MSC.MultiSample
import all Phylogenetics.MSC.Relabel
import all Phylogenetics.MSC.Shapes
import all Phylogenetics.MSC.Small
import all Phylogenetics.NMSC.Analytic
import all Phylogenetics.NMSC.Basic
import all Phylogenetics.NMSC.ChoiceMetric
import all Phylogenetics.NMSC.Defs
import all Phylogenetics.NMSC.DisplayedTreeModel
import all Phylogenetics.NMSC.Exchangeability
import all Phylogenetics.NMSC.Factor
import all Phylogenetics.NMSC.Generic
import all Phylogenetics.NMSC.Glue
import all Phylogenetics.NMSC.History
import all Phylogenetics.NMSC.Induced
import all Phylogenetics.NMSC.InducedAbove
import all Phylogenetics.NMSC.InducedParams
import all Phylogenetics.NMSC.InducedRestrict
import all Phylogenetics.NMSC.InducedSuppress
import all Phylogenetics.NMSC.Inheritance
import all Phylogenetics.NMSC.Level1.Arms
import all Phylogenetics.NMSC.Level1.Basic
import all Phylogenetics.NMSC.Level1.Consistency
import all Phylogenetics.NMSC.Level1.Context
import all Phylogenetics.NMSC.Level1.Cycle
import all Phylogenetics.NMSC.Level1.Defs
import all Phylogenetics.NMSC.Level1.Displays
import all Phylogenetics.NMSC.Level1.GeneTrees
import all Phylogenetics.NMSC.Level1.General
import all Phylogenetics.NMSC.Level1.MetricCycle.Basic
import all Phylogenetics.NMSC.Level1.MetricCycle.Instance
import all Phylogenetics.NMSC.Level1.MetricCycle.RationalLengths
import all Phylogenetics.NMSC.Level1.MetricCycle.Realization
import all Phylogenetics.NMSC.Level1.MetricCycle.Reflection
import all Phylogenetics.NMSC.Level1.Process
import all Phylogenetics.NMSC.Level1.Sampling
import all Phylogenetics.NMSC.Level1.Symmetry
import all Phylogenetics.NMSC.Marginal
import all Phylogenetics.NMSC.SpeciesTree
import all Phylogenetics.NMSC.Symmetry
import all Phylogenetics.NMSC.TreeCF
import all Phylogenetics.NMSC.Witness
import all Phylogenetics.Network.AncestralRestriction
import all Phylogenetics.Network.Basic
import all Phylogenetics.Network.CutHierarchy
import all Phylogenetics.Network.Cuts
import all Phylogenetics.Network.Defs
import all Phylogenetics.Network.DeletedArcs
import all Phylogenetics.Network.Induced
import all Phylogenetics.Network.InducedMetric
import all Phylogenetics.Network.Level1.CyclicOrder
import all Phylogenetics.Network.Level1.Defs
import all Phylogenetics.Network.Level1.Digraph.Basic
import all Phylogenetics.Network.Level1.Digraph.Complete
import all Phylogenetics.Network.Level1.Digraph.CompleteCycle
import all Phylogenetics.Network.Level1.Digraph.CompleteDesc
import all Phylogenetics.Network.Level1.Digraph.CompleteEmbed
import all Phylogenetics.Network.Level1.Digraph.Correspondence
import all Phylogenetics.Network.Level1.Digraph.CycleHybrid
import all Phylogenetics.Network.Level1.Digraph.Defs
import all Phylogenetics.Network.Level1.Digraph.Invariance
import all Phylogenetics.Network.Level1.Digraph.Invariant
import all Phylogenetics.Network.Level1.Digraph.InvariantCycle
import all Phylogenetics.Network.Level1.Digraph.InvariantSide
import all Phylogenetics.Network.Level1.Digraph.InvariantTree
import all Phylogenetics.Network.Level1.Digraph.OfNet
import all Phylogenetics.Network.Level1.Digraph.Sound
import all Phylogenetics.Network.Level1.LevelOne
import all Phylogenetics.Network.Level1.ToRootedNetwork
import all Phylogenetics.Network.OfHierarchy
import all Phylogenetics.Network.PendantCuts
import all Phylogenetics.Network.Quartets
import all Phylogenetics.Network.Semidirected
import all Phylogenetics.Network.TreeOfBlobs
import all Phylogenetics.Tree.AstralDP
import all Phylogenetics.Tree.Defs
import all Phylogenetics.Tree.Detach
import all Phylogenetics.Tree.FourPoint
import all Phylogenetics.Tree.GeneTree.AnchorNode
import all Phylogenetics.Tree.GeneTree.Annotate
import all Phylogenetics.Tree.GeneTree.Basic
import all Phylogenetics.Tree.Metric
import all Phylogenetics.Tree.NeighborJoining
import all Phylogenetics.Tree.Splice
import all Phylogenetics.Tree.Splits
import all Phylogenetics.Tree.SplitsEquivalence
import all Phylogenetics.Tree.XTree
import all PhyloNetwork.External.HuberEtAl2025.Theorem51
import all PhyloNetwork.External.MitchellAllmanRhodes2019.CutModel
import all PhyloNetwork.External.MitchellAllmanRhodes2019.T1Limit
import all PhyloNetwork.External.MitchellAllmanRhodes2019.T3Density
import all PhyloNetwork.External.MitchellAllmanRhodes2019.T3Limit
import all PhyloNetwork.External.MitchellAllmanRhodes2019.T3Test
import all PhyloNetwork.External.Rhodes2020.Theorem2
import all PhyloNetwork.ForMathlib.Analysis.SpecialFunctions.EntropyExcess
import all PhyloNetwork.ForMathlib.Analysis.SpecialFunctions.Erf
import all PhyloNetwork.ForMathlib.Probability.GaussianPlane
import all PhyloNetwork.ForMathlib.Probability.GaussianStrip
import all PhyloNetwork.ForMathlib.Probability.GaussianTail
import all PhyloNetwork.ForMathlib.Probability.Transfer
import all PhyloNetwork.InducedSplits
import all PhyloNetwork.Level1Blobs
import all PhyloNetwork.Level1Blocks
import all PhyloNetwork.Level1CF
import all PhyloNetwork.NMSCChain
import all PhyloNetwork.Testing.Combining
import all PhyloNetwork.Testing.Defs
import all PhyloNetwork.Testing.IID
import all PhyloNetwork.Testing.Limits
import all PhyloNetwork.Testing.MissingTaxa
import all PhyloNetwork.Testing.Tails
import all PhyloNetwork.Testing.Trinomial.Bridge
import all PhyloNetwork.Testing.Trinomial.CLT
import all PhyloNetwork.Testing.Trinomial.Gaussian
import all PhyloNetwork.Testing.Trinomial.Statistics
import all PhyloNetwork.Testing.Trinomial.Tests
import all PhyloNetwork.Testing.Trinomial.Whiten
import all PhyloNetwork.Wedge
import all TreeOfBlobs.BridgeDFS
import all TreeOfBlobs.Defs
import all TreeOfBlobs.External.HuberEtAl2025.Theorem51
import all TreeOfBlobs.External.MitchellAllmanRhodes2019.CutModel
import all TreeOfBlobs.External.MitchellAllmanRhodes2019.T1Limit
import all TreeOfBlobs.External.MitchellAllmanRhodes2019.T3Density
import all TreeOfBlobs.External.MitchellAllmanRhodes2019.T3Limit
import all TreeOfBlobs.External.MitchellAllmanRhodes2019.T3Test
import all TreeOfBlobs.External.Rhodes2020.Theorem2
import all TreeOfBlobs.FinNetwork
import all TreeOfBlobs.ForMathlib.Analysis.AnalyticZeroSet
import all TreeOfBlobs.ForMathlib.Analysis.FiniteOptimization
import all TreeOfBlobs.ForMathlib.Analysis.SpecialFunctions.EntropyExcess
import all TreeOfBlobs.ForMathlib.Analysis.SpecialFunctions.Erf
import all TreeOfBlobs.ForMathlib.Analysis.SpecialFunctions.GibbsInequality
import all TreeOfBlobs.ForMathlib.Probability.GaussianPlane
import all TreeOfBlobs.ForMathlib.Probability.GaussianStrip
import all TreeOfBlobs.ForMathlib.Probability.GaussianTail
import all TreeOfBlobs.ForMathlib.Probability.Transfer
import all TreeOfBlobs.General
import all TreeOfBlobs.InducedSplits
import all TreeOfBlobs.LCA
import all TreeOfBlobs.Level1Blobs
import all TreeOfBlobs.Level1Blocks
import all TreeOfBlobs.Level1CF
import all TreeOfBlobs.LocalObjective
import all TreeOfBlobs.NMSCChain
import all TreeOfBlobs.RhoOne
import all TreeOfBlobs.Testing.Combining
import all TreeOfBlobs.Testing.Defs
import all TreeOfBlobs.Testing.IID
import all TreeOfBlobs.Testing.Limits
import all TreeOfBlobs.Testing.MissingTaxa
import all TreeOfBlobs.Testing.Tails
import all TreeOfBlobs.Testing.Trinomial.Bridge
import all TreeOfBlobs.Testing.Trinomial.CLT
import all TreeOfBlobs.Testing.Trinomial.Gaussian
import all TreeOfBlobs.Testing.Trinomial.Statistics
import all TreeOfBlobs.Testing.Trinomial.Tests
import all TreeOfBlobs.Testing.Trinomial.Whiten
import all TreeOfBlobs.TreeCounts
import all TreeOfBlobs.UnitMetric
import all TreeOfBlobs.Wedge
import all Allman2023.Basic.Algebra.BigOperators.Intervals
import all Allman2023.Basic.Algebra.BigOperators.Pi
import all Allman2023.Basic.Analysis.Convex.Segment
import all Allman2023.Basic.Analysis.SpecialFunctions.Exp
import all Allman2023.Basic.Data.Finset.Card
import all Allman2023.Basic.Data.Finset.Iterate
import all Allman2023.Basic.Data.Set.Subtype
import all Allman2023.Bridge.Model
import all Allman2023.Bridge.Statements
import all Allman2023.Defs
import all Allman2023.External.SempleSteel2005.Quartets
import all Allman2023.Figures.Check
import all Allman2023.Figures.Examples
import all Allman2023.Figures.Figure1
import all Allman2023.Figures.Figure2
import all Allman2023.FourTaxa.CFDetectable
import all Allman2023.FourTaxa.CFGeometry
import all Allman2023.FourTaxa.ClaimsTheorem1
import all Allman2023.FourTaxa.ContractBlob
import all Allman2023.FourTaxa.Corollary1
import all Allman2023.FourTaxa.DeletedNetwork
import all Allman2023.FourTaxa.FourCycle
import all Allman2023.FourTaxa.GenericCF
import all Allman2023.FourTaxa.GenericDense
import all Allman2023.FourTaxa.GenericParams
import all Allman2023.FourTaxa.KernelBounds
import all Allman2023.FourTaxa.Lemma1
import all Allman2023.FourTaxa.NetworkNk
import all Allman2023.FourTaxa.NetworkNkCF
import all Allman2023.FourTaxa.NetworkNkExact
import all Allman2023.FourTaxa.NetworkNkGraph
import all Allman2023.FourTaxa.NetworkNkMixture
import all Allman2023.FourTaxa.NetworkNkSpecies
import all Allman2023.FourTaxa.NetworkOne
import all Allman2023.FourTaxa.Proposition1
import all Allman2023.FourTaxa.Theorem1
import all Allman2023.FourTaxa.Theorem1a
import all Allman2023.FourTaxa.Theorem1b
import all Allman2023.FourTaxa.TwoBlobs
import all Allman2023.LargeNetworks.Claims
import all Allman2023.LargeNetworks.Corollary2
import all Allman2023.LargeNetworks.CutOrder
import all Allman2023.LargeNetworks.CycleLemma
import all Allman2023.LargeNetworks.Lemma2
import all Allman2023.LargeNetworks.Lemma2Counterexample
import all Allman2023.LargeNetworks.Lemma3
import all Allman2023.LargeNetworks.Reduction
import all Allman2023.LargeNetworks.Rule
import all Allman2023.LargeNetworks.SubgraphBlobs
import all Allman2023.LargeNetworks.Theorem2
import all Allman2023.LargeNetworks.Theorem3
import all Allman2023.MainResult.Algorithm
import all Allman2023.MainResult.BlobDistance
import all Allman2023.MainResult.Theorem4
import all Allman2023.MainResult.TrivialEdges
import all Allman2023.Networks.BlobDefinitions
import all Allman2023.Networks.BlobStructure
import all Allman2023.Networks.BlobsPass
import all Allman2023.Networks.Bridges
import all Allman2023.Networks.Concordance
import all Allman2023.Networks.CycleFamily
import all Allman2023.Networks.Definitions
import all Allman2023.Networks.InPassing
import all Allman2023.Networks.InducedCF
import all Allman2023.Networks.InducedNetwork
import all Allman2023.Networks.InducedTransfer
import all Allman2023.Networks.LSABlob
import all Allman2023.Networks.SuppressStem
import all Allman2023.Networks.TrdFour
import all Allman2023.Networks.TrdTree
import all Allman2023.Networks.TreeBlobs
import all Allman2023.Networks.TreeIso
import all Allman2023.Networks.TreeSuppression

/-!
# Axiom and dependency audit

Run with `lake env lean -Dlinter.deprecated.module=false scripts/Audit.lean` after `lake build` and
`lake build Phylogenetics PhyloNetwork TreeOfBlobs Allman2023`.

For every numbered result of the paper, this prints the axioms it depends on and the results from
prior work that it uses (`External/`, and the cited results that the libraries prove). It then
checks every declaration of the library, those of the libraries `Phylogenetics`, `PhyloNetwork`,
`TreeOfBlobs` and `Allman2023` included, and the theorem that Palomar's comparator checks. The run
fails if any of them depends on an axiom other than Lean's standard `propext`, `Classical.choice` and
`Quot.sound` (a `sorry` shows up as the axiom `sorryAx`). Its table of results is the source of the
report's dependency table.

It also writes the *route* of every numbered result to `.lake/route_deps.tsv`: the other
numbered results that its proof uses, found by following the proof through the library's helper
lemmas and stopping at numbered results, together with the TeX label that the result's docstring
names in backticks. `route_check.py` compares these routes with the results that the paper's proofs
cite. The results of Allman et al. 2023 that carry labels are listed too, so that the routes reach
them.

The library's modules are imported with `import all`, which makes the proofs of their theorems
available: the module system does not export them otherwise. The traversal tests membership in a
precomputed set of the library's constants; looking up each constant's module instead
(`Environment.getModuleIdxFor?`) makes the interpreted script take minutes.

Keep one `import all` line per module of the libraries, each on its own line: a module that is
missing is still imported through the others, but without its proofs, and the audit then misses the
axioms and the routes inside them. The CI template checks the list.
-/

open Lean Elab Command

namespace Audit

/-- The results from prior work, with a short label: the theorems proved in `External/`, in
lean4-allman2023 and in the libraries that this repository requires. The traversal stops at them. -/
meta def externalResults : List (String × Name) :=
  [("Allman et al. 2023, Theorem 1 (TINNiK's Theorem 1)", `Allman2023.theorem1),
   ("Allman et al. 2023, Corollary 1", `Allman2023.corollary1),
   ("Allman et al. 2023, Corollary 1, as CF-detectability", `Allman2023.cfDetectable_generic),
   ("CF-detectability at given parameters", `Allman2023.CFDetectable),
   ("Allman et al. 2023, Lemma 2", `Allman2023.lemma2),
   ("Allman et al. 2023, Lemma 2, on a subgraph", `Allman2023.determines_of_subnetwork),
   ("Allman et al. 2023, Theorem 2 (TINNiK's Theorem 2)", `Allman2023.theorem2),
   ("Allman et al. 2023, Theorem 2, in the form for the closure", `Allman2023.rule_core),
   ("Allman et al. 2023, Theorem 3, combinatorial part (TINNiK's Theorem 3)", `Allman2023.closure_complete),
   ("Allman et al. 2023, Theorem 3, soundness", `Allman2023.closure_sound),
   ("Mitchell et al. 2019, Theorem 3.1, for the cut model", `External.MitchellAllmanRhodes2019.cutModel_theorem31),
   ("Mitchell et al. 2019, Proposition 4.1, for the trinomial", `External.MitchellAllmanRhodes2019.proposition4_1),
   ("Mitchell et al. 2019, Proposition 4.2", `External.MitchellAllmanRhodes2019.proposition4_2),
   ("Mitchell et al. 2019, Proposition 5.1, for the trinomial", `External.MitchellAllmanRhodes2019.proposition5_1),
   ("Mitchell et al. 2019, Proposition 5.2", `External.MitchellAllmanRhodes2019.proposition5_2),
   ("Rhodes 2020, Theorem 2", `External.Rhodes2020.theorem2),
   ("Rhodes 2020, internal edge weights", `External.Rhodes2020.quartetWeight_ge_two),
   ("Buneman 1971: exact tree builders exist", `External.Rhodes2020.exists_isExactBuilder),
   ("Saitou, Nei 1987; Studier, Keppler 1988: neighbor joining is exact", `Phylogenetics.NJ.isExactBuilder_nj),
   ("Semple, Steel 2003, the Splits Equivalence Theorem, uniqueness", `Phylogenetics.SplitsEquivalence.xTree_unique)]

/-- The numbered results of TINNiK, the labelled claims of its Appendix C, and what it says in
passing, in the order of the paper. -/
meta def tinnikResults : List (String × Name) :=
  [("Appendix C.1, the maximum likelihood estimate on a cut line", `Tinnik.cutLineMLE_maximizes),
   ("Appendix C.1, the log-likelihood on a cut line", `Tinnik.lineMaxLogLikelihood_eq),
   ("Appendix C.1, the full log-likelihood", `Tinnik.fullMaxLogLikelihood_eq),
   ("Appendix C.1, no maximum on the open cut model", `Tinnik.not_exists_generatingCutModel_maximizer),
   ("Proposition 5", `Tinnik.proposition5),
   ("Proposition 6", `Tinnik.proposition6),
   ("Theorem 4, at given parameters", `Tinnik.theorem4_of_rejects),
   ("Theorem 4, one sequence of levels", `Tinnik.theorem4_explicit),
   ("Theorem 4", `Tinnik.theorem4),
   ("Theorem 4, the T3 option", `Tinnik.theorem4T3),
   ("Theorem 4, neighbor joining", `Tinnik.theorem4_nj),
   ("Theorem 4 with missing taxa, at given parameters", `Tinnik.theorem4_missing_of_rejects),
   ("Theorem 4 with missing taxa, at parameters with CF-detectability", `Tinnik.theorem4_missing_of_cfDetectable),
   ("Theorem 4 with missing taxa", `Tinnik.theorem4_missing),
   ("The T3 option with missing taxa", `Tinnik.theorem4T3_missing),
   ("Allman et al. 2023: Like NANUQ, it can be shown to provide a statistically consistent estimate of the network features it seeks ...", `Tinnik.outline_cut_consistent),
   ("Studier, Keppler 1988, the Lemma fails at a polytomy", `External.StudierKeppler1988.not_lemmaAsPrinted)]

meta def allmanResults1 : List (String × Name) :=
  [("Definition 1", `Allman2023.IsBinaryNetwork),
   ("Definition 2", `Allman2023.IsCutEdge),
   ("Definition 3", `Allman2023.IsMetricParams),
   ("Definition 4", `Allman2023.IsLSA),
   ("Definition 5, the LSA network", `Allman2023.lsaPlus),
   ("Definition 5, the semidirected network", `Allman2023.semidirected),
   ("Definition 6", `Allman2023.induced),
   ("Definition 7, on a rooted network", `Allman2023.blobDegree),
   ("Definition 7, on a graph", `Allman2023.cutDegree),
   ("Definition 8", `Allman2023.IsDeterminedBy),
   ("Definition 9", `Allman2023.IsChainOfBlobs),
   ("Definition 10, on a semidirected network", `Allman2023.unrootedTreeOfBlobs),
   ("Definition 10, on a rooted network", `Allman2023.treeOfBlobsRooted),
   ("Definition 11, unrooted", `Allman2023.Trd),
   ("Definition 11, rooted", `Allman2023.reducedRootedTree),
   ("Definition 12", `Allman2023.IsBlobQuartet),
   ("Definition 13, associated quartet", `Allman2023.IsAssociatedQuartet),
   ("Definition 13", `Allman2023.IsTreeQuartet),
   ("Definition 14, the triple", `Allman2023.cfTriple),
   ("Definition 14, one quartet", `Allman2023.quartetCF),
   ("Definition 15, cut", `Allman2023.IsCutCF),
   ("Definition 15, non-cut, on quartet trees", `Allman2023.IsNonCut),
   ("Definition 15, non-cut", `Allman2023.IsNonCutCF),
   ("Definition 15, strictly cut, on quartet trees", `Allman2023.IsStrictlyCutAt),
   ("Definition 15, strictly cut at the first entry", `Allman2023.IsStrictlyCutAtFirst),
   ("Definition 15, strictly cut", `Allman2023.IsStrictlyCutCF),
   ("the network of Proposition 1", `Allman2023.NetworkNk.networkNk),
   ("three taxa determine one blob", `Allman2023.BlobStructure.existsUnique_isDeterminedBy_three),
   ("three taxa determine a blob", `Allman2023.Bridges.exists_isDeterminedBy_three),
   ("three taxa determine a blob, on the subnetwork of Theorem 1", `Allman2023.exists_determines_arcsAbove),
   ("three taxa determine a blob, on a subgraph", `Allman2023.exists_determines_three),
   ("a B-quartet displays the unresolved quartet", `Allman2023.isBlobQuartet_iff_displaysUnresolved),
   ("a T-quartet displays a resolved quartet", `Allman2023.exists_displays_of_isTreeQuartet),
   ("a displayed quartet is the induced topology", `Allman2023.inducedHasQuartetTopology_of_displays),
   ("a T-quartet stays a T-quartet on the induced network", `Allman2023.isTreeQuartet_induced),
   ("CFs pass to the induced network", `Allman2023.nmscCF_induced),
   ("generic parameters pass to the induced network", `Allman2023.isGenericNull_inducedParams),
   ("valid parameters pass to the induced network", `Allman2023.isMetric_inducedParams),
   ("blobs pass to blobs under suppression, one network", `Allman2023.BlobsPass.isBlobQuartetOnInduced_iff),
   ("blobs pass to blobs under suppression", `Allman2023.Bridges.isBlobQuartetOnInduced_iff),
   ("the rule's hypothesis (a) on an induced network", `Allman2023.InducedTreeSeparates.image),
   ("what is inferred on an induced network", `Allman2023.TopologyInferredA.image),
   ("an induced network of an induced network, resolved", `Allman2023.inducedHasQuartetTopology_induced),
   ("an induced network of an induced network, unresolved", `Allman2023.inducedHasStarTopology_induced),
   ("the rooted forms in the proof of Theorem 1", `Allman2023.rootedForms),
   ("displayed quartets determine the tree", `Allman2023.treeFromQuartets_displays),
   ("Lemma 1", `Allman2023.lemma1),
   ("Theorem 1, (a), for all parameters", `Allman2023.theorem1_cut),
   ("Theorem 1, statement (a)", `Allman2023.theorem1_a),
   ("Theorem 1, (b), the 2-blob step", `Allman2023.exists_isContractible_of_cutDegree_two)]

/-- The results of Allman et al. 2023 that carry the labels of the routes file (part 2). -/
meta def allmanResults2 : List (String × Name) :=
  [("the mixture, on the deleted networks", `Allman2023.InPassing.cf_mixture),
   ("Theorem 1, (b), the mixture", `Allman2023.nmscCF_withPair_mixture),
   ("Theorem 1, (b), the contradiction", `Allman2023.IsLowPair.exists_splitOffAt),
   ("Theorem 1, statement (b)", `Allman2023.theorem1_b),
   ("Theorem 1", `Allman2023.theorem1),
   ("Corollary 1", `Allman2023.corollary1),
   ("proof of Proposition 1, the probability of a level", `Allman2023.NetworkNk.stageMass_divLevel),
   ("proof of Proposition 1, the probability alpha", `Allman2023.NetworkNk.stageMass_divAt),
   ("proof of Proposition 1, the mixture", `Allman2023.NetworkNk.nmscCF_eq_mixture),
   ("proof of Proposition 1, CF1 from the species trees", `Allman2023.NetworkNk.mul_cfOne_eq_species),
   ("Proposition 1", `Allman2023.proposition1),
   ("Proposition 1, the converse", `Allman2023.proposition1_converse),
   ("Lemma 2, on a subgraph", `Allman2023.determines_of_subnetwork),
   ("Lemma 2", `Allman2023.lemma2),
   ("Corollary 2", `Allman2023.corollary2),
   ("Theorem 2", `Allman2023.theorem2),
   ("Lemma 3", `Allman2023.lemma3),
   ("proof of Theorem 3, the first step", `Allman2023.exists_representatives_induced),
   ("only part (a) of Theorem 2 is needed, the induction", `Allman2023.theorem3_core_partA),
   ("only part (a) of Theorem 2 is needed", `Allman2023.theorem3_partA),
   ("proof of Theorem 3, the induction", `Allman2023.theorem3_core),
   ("Theorem 3", `Allman2023.theorem3),
   ("proof of Theorem 4, the displayed quartets", `Allman2023.displayedFromCF_eq),
   ("the splits of the tree determine it", `Allman2023.isIso_Trd_of_splits_eq),
   ("Theorem 4", `Allman2023.theorem4),
   ("Theorem 4, for two networks, as labelled trees", `Allman2023.theorem4_iso),
   ("Theorem 4, with the function", `Allman2023.theorem4_treeFromCF),
   ("Theorem 4, for two networks", `Allman2023.theorem4_two_networks),
   ("hybrid edges are in blobs", `Allman2023.InPassing.not_isBridge_of_isHybridEdge),
   ("a blob determined by k taxa has degree at least k", `Allman2023.InPassing.card_le_blobDegree),
   ("a blob determined by k taxa has degree at least k, on a graph", `Allman2023.InPassing.card_le_cutDegree),
   ("condition (1) after Definition 12", `Allman2023.InPassing.isBlobQuartet_iff_deletion),
   ("the unrooted reduced tree from the rooted one", `Allman2023.InPassing.isIso_trdFromRooted),
   ("the reduced tree of blobs is a tree", `Allman2023.Bridges.isTree_Trd),
   ("tree-like induced networks and their displayed trees", `Allman2023.InPassing.isTreelike_iff_forall_displays),
   ("the distance between blobs is not identifiable", `Allman2023.InPassing.blobDistance_not_identifiable),
   ("any number of 2-blobs, resolved", `Allman2023.InPassing.exists_network_resolved),
   ("any number of 2-blobs, unresolved", `Allman2023.InPassing.exists_network_star),
   ("for generic parameters, cut iff strictly cut", `Allman2023.isCutCF_iff_isStrictlyCutCF),
   ("blobs below the LSA are determined by three taxa", `Allman2023.BlobStructure.exists_isDeterminedBy_of_isBelowLSA),
   ("blobs above the LSA are not determined", `Allman2023.BlobStructure.not_isDeterminedBy_of_isAboveLSA),
   ("a blob at the LSA is determined by three taxa", `Allman2023.BlobStructure.exists_isDeterminedBy_lsaNode),
   ("the shape of a chain of blobs", `Allman2023.BlobStructure.IsChainOfBlobs.deg_eq_two),
   ("blobs above the LSA are 2-blobs", `Allman2023.BlobStructure.blobDegree_eq_two_of_isAboveLSA),
   ("the chain of blobs between root and LSA", `Allman2023.BlobStructure.exists_chain_root_lsaNode),
   ("the degree of the blob of the LSA", `Allman2023.BlobStructure.blobDegree_lsaPlus),
   ("an m-blob at the LSA gives an (m-1)-multifurcation", `Allman2023.BlobStructure.existsUnique_multifurcation),
   ("a 3-blob at the LSA is suppressed", `Allman2023.BlobStructure.not_liesIn_of_three),
   ("a CF is in the simplex", `Allman2023.cfTriple_mem_simplex),
   ("CFs off the segments come from unresolved trees", `Allman2023.hasStarTopology_of_isNonCutCF)]

/-- The results of Allman et al. 2023 that carry the labels of the routes file (part 3). -/
meta def allmanResults3 : List (String × Name) :=
  [("points off the segments arise from 4-cycles (Banos 2019)", `Allman2023.FourCycle.exists_cfTriple_eq),
   ("a 4-blob can give a CF on the segments", `Allman2023.FourCycle.exists_isCutCF),
   ("a pendant edge whose length is not identifiable", `Allman2023.FourCycle.pendant_not_identifiable),
   ("lengths of edges between trivial blobs, on the rooted network", `Allman2023.TrivialEdges.edge_length_eq),
   ("lengths of edges between trivial blobs, at the root", `Allman2023.TrivialEdges.root_length_eq),
   ("lengths of edges between trivial blobs, internal edges", `Allman2023.TrivialEdges.semidirected_length_eq),
   ("Figure 3", `Allman2023.Figures.fig3_cf),
   ("Figure 9, left, the CFs", `Allman2023.Figures.fig9L_cf),
   ("Figure 9, left, one rule", `Allman2023.Figures.fig9L_single_rule),
   ("Figure 9, right, the CFs", `Allman2023.Figures.fig9R_cf),
   ("Figure 9, right, three rules", `Allman2023.Figures.fig9R_three_rules),
   ("Lemma 2 needs a connected subnetwork", `Allman2023.lemma2_needs_connected),
   ("The consistency of the outline, for a test that is right on each set of four taxa with probability tending to ...", `Allman2023.Algorithm.outline_consistent),
   ("For edges between trivial blobs ... heuristics such as those used by ASTRAL ... provide a fast estimate of ...", `Allman2023.Algorithm.astralLength_semidirected),
   ("If 𝒩⁺ is a resolved tree, then Allman et al. (2011) showed CF_{ab/cd} may take on any value in the interval ...", `Allman2023.InPassing.cf_tree_range),
   ("This network has 6 non-trivial blobs (a 5-blob, two 3-blobs, and three 2-blobs), and a single trivial 3-blob", `Allman2023.Figures.fig1_blobs),
   ("The child edges of v are both tree edges and non-cut, while the parent edge of v is tree and cut", `Allman2023.Figures.fig1_edges_at_v),
   ("The induced network on a B-quartet ... can even be a tree", `Allman2023.Figures.fig3_induced_tree),
   ("However, {a, b, c, f} is a B-quartet on both the full and the induced networks", `Allman2023.Figures.fig3_abcf),
   ("The lowest stable ancestor (LSA) of the network is v", `Allman2023.Figures.fig1_lsa),
   ("Nodes ... of degree 2 or 3 may correspond to trivial or non-trivial blobs in the network", `Allman2023.Figures.fig1_degree_examples),
   ("A single 2-blob in a non-binary network, formed from two 2-cycles sharing a single node", `Allman2023.Figures.fig2R_blob),
   ("Leaves are the only 1-blobs", `Allman2023.BlobStructure.blobDegree_eq_one_iff_of_isTreeNetwork),
   ("The root and internal nodes are 3-blobs", `Allman2023.BlobStructure.blobDegree_eq_three_of_isTreeNetwork),
   ("Nodes of degree 4 or more in the tree of blobs indicate non-trivial blobs for a binary network", `Allman2023.BlobStructure.not_isTrivialBlob_of_four_le_cutDegree),
   ("On a non-binary tree, polytomous nodes are k-blobs with k ≥ 4", `Allman2023.BlobStructure.four_le_blobDegree_of_isTreeNetwork),
   ("(If the network is level-1, this is a chain of 2-cycles, as discussed in Banos 2019)", `Allman2023.BlobStructure.ncard_blobNodes_of_isAboveLSA),
   ("If the root of a binary network is a trivial blob, then it is a degree-2 node but forms a degree-3 blob", `Allman2023.BlobStructure.root_of_isTrivialBlob),
   ("As is well known, on a tree any 3 taxa determine a unique node", `Allman2023.BlobStructure.existsUnique_node_of_isTreeNetwork),
   ("If the number of taxa was not decreased, then 𝒩⁺ has a relatively simple structure: Its LSA network 𝒩⊕ ...", `Allman2023.BlobStructure.structure_of_separated),
   ("If the species network is a tree then two of the three entries of CF_abcd must be equal, with the third no ...", `Allman2023.BlobStructure.third_no_smaller_of_isTreeNetwork),
   ("If two cycles share only a node as in Fig. 2R ... Our restriction to binary networks rules out this ...", `Allman2023.BlobStructure.exists_mem_inter_of_two_incident),
   ("Non-tree phylogenetic networks may have k-blobs that are not nodes for any k > 1", `Allman2023.CycleFamily.exists_kBlob),
   ("Blobs may ... reduce to tree-like relationships. Indeed, this happens even in the level-1 case with a single ...", `Allman2023.CycleFamily.cycleNet_b_to_t),
   ("A ... 4-blob", `Allman2023.Figures.fig2C_blob),
   ("A planar 5-blob", `Allman2023.Figures.fig2L_planar),
   ("A non-planar 4-blob", `Allman2023.Figures.fig2C_not_planar),
   ("A ... 5-blob", `Allman2023.Figures.fig2L_blob),
   ("If 𝒩⁺ is level-1, then Baños (2019) showed CF_{ab/cd} may take on any value in (1/6, 1)", `Allman2023.NetworkNk.banos_range)]

/-- The numbered results of the paper and of Allman et al. 2023 that carry labels: one list is split
in parts, since one literal of this length exceeds the limit on elaboration. -/
meta def paperResults : List (String × Name) :=
  tinnikResults ++ allmanResults1 ++ allmanResults2 ++ allmanResults3

/-- The theorem that Palomar's comparator checks (`theorem_names` of
`palomar/Tinnik/comparator.json`), as the Solution restates it. -/
meta def solutionResults : List Name :=
  [`TinnikChallenge.theorem4]

/-- Lean's standard axioms. -/
meta def standardAxioms : List Name := [``propext, ``Classical.choice, ``Quot.sound]

/-- Whether `m` is a module of the libraries: under the root `Tinnik` (`Basic/`, `External/`, the
paper's library and the Solution), but not the Challenge, or of the libraries `Phylogenetics`,
`PhyloNetwork`, `TreeOfBlobs` and `Allman2023`, which the audit reads too (but not the Challenge of
`Allman2023`). -/
meta def isLibraryModule (m : Name) : Bool :=
  ((`Tinnik).isPrefixOf m && m != `Tinnik.Challenge) ||
    ((`Allman2023).isPrefixOf m && m != `Allman2023.Challenge) ||
    (`Phylogenetics).isPrefixOf m || (`PhyloNetwork).isPrefixOf m || (`TreeOfBlobs).isPrefixOf m

/-- The constants declared in the library. -/
meta def libraryConstants (env : Environment) : NameSet := Id.run do
  let mut s : NameSet := {}
  for m in env.header.moduleNames, d in env.header.moduleData do
    if isLibraryModule m then
      for c in d.constNames do
        s := s.insert c
  return s

/-- The constants used by the type and the value of `c`. -/
meta def usedConstants (env : Environment) (c : Name) : Array Name :=
  match env.find? c with
  | some (.thmInfo t) => t.type.getUsedConstants ++ t.value.getUsedConstants
  | some (.defnInfo d) => d.type.getUsedConstants ++ d.value.getUsedConstants
  | some (.opaqueInfo o) => o.type.getUsedConstants ++ o.value.getUsedConstants
  | some (.inductInfo i) => i.type.getUsedConstants ++ i.ctors.toArray
  | some ci => ci.type.getUsedConstants
  | none => #[]

/-- The external results reached from `root` through constants of the library, without looking
inside the proofs of the external results themselves. `deps` caches the constants of the library
that each constant uses, across calls. -/
meta def externalUses (env : Environment) (library : NameSet) (deps : NameMap (Array Name))
    (root : Name) :
    List Name × NameMap (Array Name) := Id.run do
  let externals := externalResults.map (·.2)
  let mut deps := deps
  let mut visited : NameSet := {}
  let mut stack : List Name := [root]
  let mut found : NameSet := {}
  while true do
    match stack with
    | [] => break
    | c :: rest =>
      stack := rest
      if visited.contains c then continue
      visited := visited.insert c
      if c != root && externals.contains c then
        found := found.insert c
        continue
      let ds := match deps.find? c with
        | some ds => ds
        | none => (usedConstants env c).filter library.contains
      deps := deps.insert c ds
      for d in ds do
        if !visited.contains d then stack := d :: stack
  return (externalResults.filterMap fun (_, n) => if found.contains n then some n else none, deps)

/-- Where `#audit` writes the routes, relative to the project root (`.lake/` is not committed). -/
meta def routeFile : System.FilePath := ".lake/route_deps.tsv"

/-- The numbered results that the proof of `root` uses: those reached from it through constants
of the library, without looking inside the proofs of numbered results themselves. -/
meta def resultUses (env : Environment) (library results : NameSet) (root : Name) :
    Array Name := Id.run do
  let mut visited : NameSet := {}
  let mut stack : List Name := (usedConstants env root).toList
  let mut found : Array Name := #[]
  while true do
    match stack with
    | [] => break
    | c :: rest =>
      stack := rest
      if visited.contains c || c == root then continue
      visited := visited.insert c
      if results.contains c then
        found := found.push c
        continue
      if !library.contains c then continue
      for d in usedConstants env c do
        if !visited.contains d then stack := d :: stack
  return found

/-- The code spans of the docstring of `c` that contain no space or comma: the candidates for its
TeX label. -/
meta def docLabels (env : Environment) (c : Name) : IO (Array String) := do
  let some doc ← findDocString? env c | return #[]
  let mut out : Array String := #[]
  let mut inside := false
  for part in doc.splitOn "`" do
    if inside && !part.isEmpty && !part.any (fun ch => ch.isWhitespace || ch == ',') then
      out := out.push part
    inside := !inside
  return out

elab "#audit" : command => do
  let env ← getEnv
  let mut bad : Array Name := #[]
  let library := libraryConstants env
  let mut deps : NameMap (Array Name) := {}
  let mut rows : Array String := #["| Result | Lean | Results from prior work used | Axioms |",
    "| --- | --- | --- | --- |"]
  for (label, n) in paperResults do
    let axs ← liftCoreM <| collectAxioms n
    if axs.any (!standardAxioms.contains ·) then bad := bad.push n
    let (uses, deps') := externalUses env library deps n
    deps := deps'
    let usesStr := if uses.isEmpty then "–" else ", ".intercalate (uses.map fun u => s!"`{u}`")
    let axStr := ", ".intercalate (axs.toList.map toString)
    rows := rows.push s!"| {label} | `{n}` | {usesStr} | {axStr} |"
  for n in solutionResults ++ externalResults.map (·.2) do
    let axs ← liftCoreM <| collectAxioms n
    if axs.any (!standardAxioms.contains ·) then bad := bad.push n
  -- Every declaration of the library, including private and auxiliary ones.
  for c in library do
    let axs ← liftCoreM <| collectAxioms c
    if axs.any (!standardAxioms.contains ·) then bad := bad.push c
  -- The routes: for each numbered result, its docstring's labels and the results it uses.
  let results : NameSet := paperResults.foldl (fun s p => s.insert p.2) {}
  let mut routes : Array String := #[]
  for (label, n) in paperResults do
    let labels ← docLabels env n
    let uses := resultUses env library results n
    routes := routes.push (s!"{label}\t{n}\t{",".intercalate labels.toList}\t" ++
      ",".intercalate (uses.map toString).toList)
  IO.FS.createDirAll ".lake"
  IO.FS.writeFile routeFile ("\n".intercalate routes.toList ++ "\n")
  logInfo ("\n".intercalate rows.toList ++
    s!"\n\nChecked {library.size} declarations of the library: " ++
    (if bad.isEmpty then "all use only the standard axioms." else "see the error."))
  unless bad.isEmpty do
    throwError m!"non-standard axioms used by: {bad}"

end Audit

#audit
