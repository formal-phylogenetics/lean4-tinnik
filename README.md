# TINNiK: inference of the tree of blobs of a species network, in Lean

[![CI](https://github.com/vltanh/lean4-tinnik/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/vltanh/lean4-tinnik/actions/workflows/lean_action_ci.yml)

A Lean 4 formalization of E. S. Allman, H. Baños, J. D. Mitchell, J. A. Rhodes, *TINNiK: inference of the tree of
blobs of a species network under the coalescent model*, [Algorithms Mol. Biol. 19 (2024), 23](https://doi.org/10.1186/s13015-024-00266-2).
The tree of blobs of a phylogenetic network is what remains of it when its reticulate parts, the blobs, are contracted.
TINNiK estimates it from the quartet concordance factors of a sample of gene trees. Hypothesis tests on each set of four
taxa, completed by the B-quartet inference rule of Allman et al. 2023, find the sets whose induced network has a 4-blob.
A quartet distance built from these sets and from the topologies inferred on the others, and a distance method such as
neighbor joining, give a weighted tree, whose internal edges shorter than a cutoff are contracted. The main result,
Theorem 4, says that under the network multispecies coalescent, for generic parameters on a binary network, there are
test levels for which the algorithm returns the tree of blobs with probability tending to one as the number of gene
trees grows. The formalization is unconditional: no result of the literature is assumed. This paper is part of a
collection of four formalizations on the tree of blobs, described in [lean4-tob](https://github.com/vltanh/lean4-tob), the hub of these papers.

## What is proved

From the header of [the report](REPORT.md):

- Every numbered result of TINNiK, by the paper's arguments except the departures in
  [Section 7 of the report](REPORT.md#7-departures-from-the-papers-proofs): Propositions 5 and 6, the estimates of
  Appendix C, and Theorem 4, with the paper's levels. The maximum likelihood estimate of Appendix C.1 is read on the
  closed simplex, since on the open cut model it need not exist (E31). This is the one correction of a statement, and
  the user who requested this formalization agreed to it.
- What the paper says in passing: the T3 option, the algorithm with missing taxa, neighbor joining in Step 4, the
  counts behind its running times, the index of a set of four taxa in lex order, and the consistency of the outline of
  an algorithm in Section 5 of Allman et al. 2023, which TINNiK develops. One sequence of levels, independent of the
  network and the parameters, also serves ([`TINNiK.theorem4_explicit`](TINNiK/Basic.lean#L657)).
- The cited results: TINNiK's Theorems 1 and 2 and the combinatorial part of its Theorem 3, which come from Allman et
  al. 2023, in [`lean4-allman2023/AllmanEtAl2023/`](https://github.com/vltanh/lean4-allman2023/tree/main/AllmanEtAl2023) ([its folder](https://github.com/vltanh/lean4-allman2023/blob/main/README.md)); Rhodes
  2020, Theorem 2; Mitchell et al. 2019, Theorem 3.1 for the cut model and Propositions 4.1, 4.2, 5.1, 5.2; that
  neighbor joining is exact on tree metrics, and Buneman's four-point theorem, in the library
  [lean4-phylogenetics](https://github.com/vltanh/lean4-phylogenetics); and that the Lemma of Studier and Keppler 1988
  fails at a polytomy. Nothing is assumed.
- `lake build` passes with no warnings, and there is no `sorry`, `axiom`, `native_decide` or `implemented_by` in
  [`lean4-tob/`](https://github.com/vltanh/lean4-tob). [`scripts/Audit.lean`](scripts/Audit.lean) checks every declaration of the project and of
  the library, including private and generated ones, against the standard axioms [`propext`](https://leanprover-community.github.io/mathlib4_docs/Init/Core.html#propext), [`Classical.choice`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Classical.choice),
  [`Quot.sound`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Quot.sound); [Building](#building) says how to run it. Lean's kernel, NanoDa and con-ron accept the eight main
  theorems.
- No person has reviewed the proofs.

## The main results

[`TINNiK/MainResults.lean`](TINNiK/MainResults.lean) states eight theorems in the namespace `TreeOfBlobs`,
each with a docstring in plain terms, and proves them from the libraries. They keep the paper's hypotheses.

- [`TreeOfBlobs.theorem4`](TINNiK/MainResults.lean#L49) (Theorem 4): for generic numerical parameters on a
  binary network, there is a sequence `α_m → 0` such that for any `β > 0` and `0 ≤ δ < 2`, any exact tree builder and
  any selection of maximum likelihood topologies, the TINNiK algorithm on `m` independent gene trees infers the tree of
  blobs with probability tending to one.
- [`TreeOfBlobs.tinnik_theorem4_missing`](TINNiK/MainResults.lean#L69) (the sentence before Theorem 4): the
  same for gene trees on subsets of the taxa, when each set of four taxa is on more and more of them.
- [`TreeOfBlobs.tinnik_not_exists_generatingCutModel_maximizer`](TINNiK/MainResults.lean#L81) (Appendix C.1,
  E31): at the counts `n > 0` in one coordinate, such as `(1, 0, 0)`, no point of the cut model of Definition 7
  maximizes the trinomial likelihood. Not every count with a zero fails.
- [`TreeOfBlobs.mitchell_proposition4_1`](TINNiK/MainResults.lean#L97),
  [`TreeOfBlobs.mitchell_proposition5_1`](TINNiK/MainResults.lean#L116) (Mitchell et al. 2019, Propositions
  4.1 and 5.1, for the trinomial): at the true point `(1 - 2φ/3, φ/3, φ/3)`, `0 < φ ≤ 1`, the likelihood ratio
  statistic of model T3, or of model T1, and the source's variable of two independent normals converge in distribution
  to the same limit.
- [`TreeOfBlobs.mitchell_proposition4_2`](TINNiK/MainResults.lean#L108),
  [`TreeOfBlobs.mitchell_proposition5_2`](TINNiK/MainResults.lean#L127) (Propositions 4.2 and 5.2): the
  printed densities are the densities of those variables. Proposition 4.2 holds for all `φ < 3/2`, where the source
  states it for `(0, 1]`.
- [`TreeOfBlobs.studierKeppler_not_lemmaAsPrinted`](TINNiK/MainResults.lean#L134) (Studier, Keppler 1988):
  the Lemma "If `i` and `j` are neighbors, then `S_ij` is the strictly least element in its row and column" fails on
  the star with four leaves and unit weights. If the letter means binary trees, this is a failure of wording. Its
  Theorem holds.

## Palomar

No submission to [Palomar](https://github.com/mathlib-initiative) is planned. [`palomar/`](.) keeps the files in
case that changes:

- [`palomar/comparator.json`](comparator.json) runs Comparator on the eight main theorems, with
  [`TINNiK.MainResults`](TINNiK/MainResults.lean) as both the challenge and the solution, the three standard axioms permitted, and NanoDa enabled.
- [`palomar/formalization.yaml`](formalization.yaml) is the entry's metadata, valid against the schema it
  names: the paper, the sources it cites, the statements aligned to the `TreeOfBlobs.*` theorems of its module, and its
  fidelity section, which lists every divergence from the paper.

To check the entry, from the repository root, after `lake build`:

```sh
scripts/check_kernels.sh
```

This checks the closure of each theorem under Lean's kernel, NanoDa and con-ron, and rejects `sorryAx`. It does not
compare a separate statement file with a proof, which is what Palomar's Challenge and Solution are for. `lake comparator`,
`leanexport` and `con-ron` come from the toolchain under `lake env`.

A submission would still need:

1. A Challenge that imports only Mathlib, with the definitions that its statements use in a block of its own, and the
   bridges from them to the library's definitions. The last such file, with `scripts/sync_challenge_defs.py`, which kept
   its block equal to the library's, and `scripts/gen_solution.py`, which generated the Solution from it, is in the git
   history at `f838ea4`, for TINNiK, TOB-QMC and ECToBlob together.
2. A Solution that restates those theorems and proves them from the libraries, and a `comparator.json` that names the
   two modules.
3. These files at the root of the repository that holds the paper, with `formalization.yaml` pointing at the new
   modules.

## Audit summary

The numbers are those of [the report](REPORT.md), which gives each finding with its location, the paper's sentence, the
Lean and the repair.

- **Errors.** The count `4(N-1)` of quartets sharing three taxa with a given one should be `4(N-4)` (E29). The MLE of
  Appendix C.1 need not exist on the open cut model, at counts such as `(1, 0, 0)` (E31). Neither affects a result.
- **Gaps.** The use of Theorem 2 needs a stronger rule than the printed one, which the same proof gives (E30). The
  proofs of Propositions 5 and 6 have an informal remark and an unjustified differentiation, and every display checks
  out (E32). In the proof of Theorem 4, the limit law under the alternative gives no comparison at cutoffs growing with
  `m`, and under the null the limit needs `|μ₀| → ∞` and is governed by `cos α₀ |μ₀|` (E33). "This pair will be
  compared again later" needs the sentence before it (E40). All are repaired, and none changes a statement.
- **Missing taxa.** The generalization that line 202 calls straightforward needs each set of four taxa on more and more
  gene trees (E75). Nothing there is an error.
- **Missing hypotheses.** None found.
- **Redundant hypotheses.** `0 ≤ δ` in Theorem 4; the star test, for the consistency claim; for the output of the T3
  option, no anomalous quartets on the subsets the tree of blobs does not resolve; and `φ ∈ (0, 1]` in Mitchell et al.'s
  Proposition 4.2.
- **Use of cited results.** Theorem 2 is applied beyond its printed hypothesis (b) (E30), and the other cited results
  are used correctly. Studier and Keppler's Lemma fails at polytomies, a failure of wording if the letter means binary
  trees, and their theorem holds. Mitchell et al.'s Appendix C has a misprint in one display (E82). The typos are E34.
- **Proofs.** They follow the paper's arguments, except the departures in
  [Section 7 of the report](REPORT.md#7-departures-from-the-papers-proofs), each with what the paper does, what Lean
  does and why. Theorem 4 under the alternative repairs a gap (E33). Proposition 5, and Mitchell et al.'s Propositions
  4.1 and 5.1, go by the central limit theorem, since Lean lacks van der Vaart's Theorem 16.7. Neighbor joining is
  proved by another comparison, since Studier and Keppler's Lemma fails at polytomies. Buneman's four-point theorem and
  the T3 theorems have no printed proof to follow. [`docs/route_differences.tsv`](docs/route_differences.tsv)
  records every difference of route.

## Credits

- Requested and supervised by The-Anh Vu-Le, who chose the paper, agreed to the correction of its Appendix C.1 (E31),
  and decided the library's boundary and the project's layout. **No person has reviewed the proofs.**
- Source audit and first foundations by Codex; statements, proofs, audit and documents by Claude (Opus 5.5) in Claude
  Code, with sub-agents, following the [formalize-math-paper](https://github.com/vltanh/formalize-math-paper) procedure.
- Made on 2026-10-27 and from 2026-10-31 to 2026-11-01, with the other papers of the collection and Gusfield et al. 2007,
  since moved to [lean4-gusfield2007](https://github.com/vltanh/lean4-gusfield2007); Claude Code used 85 sub-agents for
  the five, up to commit `282215c`. [`../../docs/CREDITS.md`](https://github.com/vltanh/lean4-tob/blob/main/docs/CREDITS.md) has the details.

## Related work

From [Section 10 of the report](REPORT.md#10-the-paper-in-the-literature).

- No other formalization of TINNiK was found. This project imports the public
  [lean4-phylogenetics](https://github.com/vltanh/lean4-phylogenetics).
- Before: SNaQ, Baños 2019 and NANUQ infer level-1 networks from quartets. Allman et al. 2023 showed that the tree of
  blobs is identifiable from gene quartet distributions, with no assumption on the level, and TINNiK makes this an
  algorithm with a consistency theorem. We found no earlier proof of its Theorem 4.
- Concurrent: Huber et al. 2025 and Frohn et al. 2025 determine the tree of blobs from exact quarnet information, with
  no statistical model. Both appeared after the TINNiK preprint and do not build on its algorithm.
- Since: TOB-QMC and ECToBlob, formalized in this collection ([TOB-QMC](https://github.com/vltanh/lean4-tob-qmc/blob/main/README.md),
  [ECToBlob](https://github.com/vltanh/lean4-ectoblob/blob/main/README.md)), describe TINNiK as the first algorithm for the problem and build on its tests.
  NANUQ⁺ and the outline of Holtgrefe et al. 2025 start from its tree of blobs, SEQUoIA uses its functions, and
  MSCquartets 3.3 implements it. We found no erratum to TINNiK.

## What's next

Theorem 4 is proved for binary networks under independent inheritance, `ρ = 0`. Extending it to common or correlated
inheritance needs CF-detectability at generic parameters for other `ρ`, and extending it to non-binary networks needs a
condition such as no trivial 4-blob on any set of four taxa. [Section 11 of the report](REPORT.md#11-whats-next) has
these, and the simpler arguments that the formalization found, among them that CF-detectability already excludes the
centroid in the proof of Theorem 4.

## Building

```sh
lake exe cache get
lake build                                                                        # this paper, with TINNiK.MainResults
lake build Phylogenetics TreeOfBlobs AllmanEtAl2023   # the libraries that the audit reads
python3 scripts/gen_audit.py                                                      # after adding a module
lake env lean -DautoImplicit=false -DmaxSynthPendingDepth=3 scripts/Audit.lean    # axioms and routes
python3 scripts/route_check.py check docs/paper_routes.tsv --accept docs/route_differences.tsv
scripts/check_kernels.sh                                                          # Lean's kernel, NanoDa, con-ron
```

- Lean and Mathlib `v4.36.0-rc1` ([`lean-toolchain`](lean-toolchain), [`lake-manifest.json`](lake-manifest.json)).
  [`lakefile.toml`](lakefile.toml) requires, by commit, [lean4-phylogenetics](https://github.com/vltanh/lean4-phylogenetics), [lean4-tob](https://github.com/vltanh/lean4-tob), [lean4-allman2023](https://github.com/vltanh/lean4-allman2023).
- The audit checks every declaration of this repository and of the libraries it requires against Lean's
  standard axioms, and writes the routes of the proofs, which the route check compares with the paper's.
- [lean4-tob's `docs/CONFIGURATION.md`](https://github.com/vltanh/lean4-tob/blob/main/docs/CONFIGURATION.md)
  records the versions, the decisions, and what "line N" means for each paper.

## Layout

The modules of [`TINNiK/`](TINNiK):

| Module | Content |
| --- | --- |
| [`Basic`](TINNiK/Basic.lean) | Consistency of the algorithm: the count of Step 3(a)(i) (E29) and Theorem 4 |
| [`T3`](TINNiK/T3.lean) | TINNiK with the T3 test |
| [`NJ`](TINNiK/NJ.lean) | TINNiK with neighbor joining |
| [`MissingTaxa`](TINNiK/MissingTaxa.lean) | TINNiK with gene trees that have missing taxa |
| [`AllmanOutline`](TINNiK/AllmanOutline.lean) | TINNiK and the outline of an algorithm in Allman, Baños, Mitchell, Rhodes 2023 |
| [`Counts`](TINNiK/Counts.lean) | Operation counts |
| [`LexIndex`](TINNiK/LexIndex.lean) | The index of a set of four taxa |
| [`Statistics/Definitions`](TINNiK/Statistics/Definitions.lean) | Probability and likelihood definitions and representation bridges |
| [`Statistics/AppendixC`](TINNiK/Statistics/AppendixC.lean) | Appendix C: the cut test |
| [`Statistics/OpenCutModel`](TINNiK/Statistics/OpenCutModel.lean) | Appendix C.1: the maximum likelihood estimate on the open cut model (E31) |
| [`Statistics/Proposition6`](TINNiK/Statistics/Proposition6.lean) | Appendix C.2: Proposition 6, the density of the test distribution |

The sources it uses, in [`TINNiK/External/`](TINNiK/External), each with a README that says how its source was read:

| Folder | Modules |
| --- | --- |
| [`MitchellAllmanRhodes2019`](https://github.com/vltanh/lean4-tob/tree/main/TreeOfBlobs/External/MitchellAllmanRhodes2019) | `CutModel` (Theorem 3.1, for the trinomial cut model), `T3Test` (the T3 test), `T3Limit` (the limit law of the T3 statistic), `T3Density` (Proposition 4.2: the density of the T3 test distribution), `T1Limit` (Propositions 5.1 and 5.2: the T1 test) |
| [`Rhodes2020`](https://github.com/vltanh/lean4-tob/tree/main/TreeOfBlobs/External/Rhodes2020) | `Theorem2` (the quartet metrization of a tree) |
| [`StudierKeppler1988`](TINNiK/External/StudierKeppler1988) | `Lemma` (the Lemma fails at a polytomy) |

It also builds on Allman et al. 2023, in [`lean4-allman2023/AllmanEtAl2023/`](https://github.com/vltanh/lean4-allman2023/tree/main/AllmanEtAl2023), whose
[folder](https://github.com/vltanh/lean4-allman2023/blob/main/README.md) documents it.

The modules of [`lean4-tob/TreeOfBlobs/`](https://github.com/vltanh/lean4-tob/tree/main/TreeOfBlobs) that it relies on ([its README](https://github.com/vltanh/lean4-tob/blob/main/TreeOfBlobs/README.md) lists them
all):

| Module | Content |
| --- | --- |
| `Defs` | Definitions specific to ECToBlob, TOB-QMC and TINNiK: the algorithm [`tinnik`](https://github.com/vltanh/lean4-tob/blob/main/TreeOfBlobs/Defs.lean#L161), its steps and the closure [`BInferred`](https://github.com/vltanh/lean4-tob/blob/main/TreeOfBlobs/Defs.lean#L126) |
| `Testing/Defs` | Hypothesis tests on quartet counts: definitions |
| `Testing/IID` | Independent samples from a finite distribution |
| `Testing/Tails` | The quartet hypothesis tests: tail bounds and growth under the alternative |
| `Testing/Limits` | The quartet hypothesis tests: limits under the null |
| `Testing/MissingTaxa` | Gene trees with missing taxa |
| `Testing/Trinomial/*` | The limits of the quartet tests for a trinomial sample: the central limit theorem, the whitened frequencies, the likelihood ratio statistics |
| `TreeCounts` | How many splits a tree has |
| `ForMathlib/*` | Through these: the error function, `x log x`, the multinomial likelihood, zero sets of analytic functions, the Gaussian plane and its tails, transferring limit laws |

[`TINNiK/MainResults.lean`](TINNiK/MainResults.lean) has the eight main theorems.

[`scripts/layers.toml`](https://github.com/vltanh/lean4-tob/blob/main/scripts/layers.toml) lists what each unit may import, and
[`scripts/check_layers.py`](https://github.com/vltanh/lean4-tob/blob/main/scripts/check_layers.py) checks every import against it. This paper's unit is
[`TINNiK/`](TINNiK) with [`TINNiK/MainResults.lean`](TINNiK/MainResults.lean), and it may import [`Basic`](https://github.com/vltanh/lean4-tob/tree/main/TreeOfBlobs), [`AllmanEtAl2023`](https://github.com/vltanh/lean4-allman2023/tree/main/AllmanEtAl2023), `MitchellAllmanRhodes2019`,
`Rhodes2020` and `StudierKeppler1988`, besides Mathlib and the library `Phylogenetics`. NANUQ, TOB-QMC and ECToBlob
import it.

## License

Apache-2.0: [LICENSE](LICENSE). Code adapted from [lean4-phylogenetics](https://github.com/vltanh/lean4-phylogenetics)
(Apache-2.0) keeps its notice in each file's header.
