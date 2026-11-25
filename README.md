# TINNiK: inference of the tree of blobs of a species network, in Lean

[![CI](https://github.com/vltanh/lean4-tinnik/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/vltanh/lean4-tinnik/actions/workflows/lean_action_ci.yml)

A Lean 4 formalization of E. S. Allman, H. Baños, J. D. Mitchell, J. A. Rhodes, *TINNiK: inference of the tree of blobs of a species network under the coalescent model*, [Algorithms Mol. Biol. 19 (2024), 23](https://doi.org/10.1186/s13015-024-00266-2), read in the publisher's XML (PMC11539473). The tree of blobs of a phylogenetic network is what remains of it when its reticulate parts, the blobs, are contracted. TINNiK estimates it from the quartet concordance factors of a sample of gene trees. Hypothesis tests on each set of four taxa, completed by the B-quartet inference rule of Allman et al. 2023, find the sets whose induced network has a 4-blob. A quartet distance built from these sets and from the topologies inferred on the others, and a distance method such as neighbor joining, give a weighted tree, whose internal edges shorter than a cutoff are contracted. The main result, Theorem 4, says that under the network multispecies coalescent, for generic parameters on a binary network, there are test levels for which the algorithm returns the tree of blobs with probability tending to one as the number of gene trees grows.

Every numbered result of the paper is proved, by the paper's arguments except the departures that [Section 7 of the report](docs/Tinnik/REPORT.md#7-departures-from-the-papers-proofs) lists. The formalization is unconditional: no result of the literature is assumed, and there is no `sorry` or `axiom` outside the Challenge's statement. The maximum likelihood estimate of Appendix C.1 is read on the closed simplex, since on the open cut model it need not exist (E31): this is the one correction of a statement, and the user who requested this formalization agreed to it. No person has reviewed the proofs.

This paper is one of the four of the hub [lean4-tob](https://github.com/vltanh/lean4-tob), a sub-hub of [lean4-phylo-network](https://github.com/vltanh/lean4-phylo-network), which presents them; it builds on Allman et al. 2023, formalized in [lean4-allman2023](https://github.com/vltanh/lean4-allman2023), and TOB-QMC, NANUQ and ECToBlob build on it.

## Status

| Part of the paper | Status |
| --- | --- |
| Background: the definitions, the cut model (Definition 7) and the tests | stated on the definitions of the libraries; the cut model of Appendix C on the closed simplex (E31) |
| Background: Theorems 1, 2 and 3, from Allman et al. 2023 | proved in lean4-allman2023, in the forms TINNiK uses |
| Algorithms: the B-quartet Inference Algorithm and TINNiK, with their running times | proved: the closure is what the printed algorithm computes, and the running times are counts of operations |
| Statistical consistency: Theorem 4 | proved, with the paper's levels, and with one sequence of levels for all networks |
| What the paper says in passing: the T3 option, missing taxa, neighbor joining, the index in lex order | proved; missing taxa with each set of four taxa on more and more gene trees (E75) |
| Appendix C: the estimates of C.1, Propositions 5 and 6 | proved; C.1 on the closed simplex (E31) |
| Cited results: Mitchell et al. 2019, Rhodes 2020, neighbor joining, Studier and Keppler's Lemma | proved, in lean4-phylo-network, lean4-phylogenetics and [`Tinnik/External/`](Tinnik/External) |
| The simulations, the data analyses and measured running times | not formalized |

[Section 9 of the report](docs/Tinnik/REPORT.md#9-not-formalized) lists what is not formalized.

## Main results

The statement of record is the theorem of the Challenge, [`palomar/Tinnik/Challenge.lean`](palomar/Tinnik/Challenge.lean), in the namespace `TinnikChallenge`. The Challenge imports only Mathlib, and its definitions are those of [`Tinnik/Defs.lean`](Tinnik/Defs.lean), copied by [`scripts/sync_challenge_defs.py`](scripts/sync_challenge_defs.py): rooted phylogenetic and binary networks, valid and generic parameters, the network multispecies coalescent with independent inheritance, the tree of blobs given by the sides of its splits, the star and cut tests, and the TINNiK algorithm. [`palomar/Tinnik/Solution.lean`](palomar/Tinnik/Solution.lean) proves it, under the same name, from the library, through the bridges of [`Tinnik/Bridge/`](Tinnik/Bridge). It keeps the paper's hypotheses.

| Paper | Lean | Statement |
| --- | --- | --- |
| Theorem 4 | [`TinnikChallenge.theorem4`](palomar/Tinnik/Challenge.lean#L494) | for generic parameters on a binary network on at least four taxa, there is a sequence `α_m → 0` such that for any `β > 0`, any `0 ≤ δ < 2`, any exact tree builder and any selection of maximum likelihood topologies, the TINNiK algorithm on `m` independent gene trees returns the tree of blobs with probability tending to one |

### Also proved in the library

| Paper | Lean | Statement |
| --- | --- | --- |
| Theorem 4, the library's form | [`Tinnik.theorem4`](Tinnik/Consistency/Theorem4.lean#L619) | Theorem 4, without the hypotheses that its proof does not use |
| Theorem 4, one sequence of levels | [`Tinnik.theorem4_explicit`](Tinnik/Consistency/Theorem4.lean#L647) | one sequence `α_m`, independent of the network and the parameters, serves |
| The T3 option | [`Tinnik.theorem4T3`](Tinnik/Consistency/T3.lean#L465) | Theorem 4 with the T3 test, for networks with no anomalous quartets |
| Neighbor joining in Step 4 | [`Tinnik.theorem4_nj`](Tinnik/Consistency/NJ.lean#L36) | Theorem 4 with neighbor joining, for any way of breaking ties |
| Missing taxa, the sentence before Theorem 4 | [`Tinnik.theorem4_missing`](Tinnik/Consistency/MissingTaxa.lean#L473) | Theorem 4 for gene trees on subsets of the taxa, when each set of four taxa is on more and more of them (E75) |
| The running times | [`Tinnik.tinnikOperations_le`](Tinnik/Algorithms/Counts.lean#L835) | the steps of TINNiK take `O((m + N) N⁴)` operations, with the count `4 (N - 4)` of the sets sharing three taxa with one (E29) |
| The index in lex order | [`Tinnik.image_rho_words`](Tinnik/Algorithms/LexIndex.lean#L227) | the formula of line 162 is a bijection from the sets of four taxa to `[1, C(N, 4)]`, increasing in lex order |
| Appendix C.1 | [`Tinnik.cutLineMLE_maximizes`](Tinnik/AppendixC/LikelihoodRatio.lean#L73), [`Tinnik.not_exists_generatingCutModel_maximizer`](Tinnik/AppendixC/OpenCutModel.lean#L108) | the maximum likelihood estimate on a cut line, on the closed simplex; on the open cut model no maximum exists at counts such as `(1, 0, 0)` (E31) |
| Proposition 5 | [`Tinnik.proposition5`](Tinnik/AppendixC/LikelihoodRatio.lean#L327) | the likelihood ratio statistic of the cut test and the paper's variable of two independent normals converge in distribution to the same limit |
| Proposition 6 | [`Tinnik.proposition6`](Tinnik/AppendixC/Proposition6.lean#L945) | the paper's density is the density of that variable |
| Allman et al. 2023, the outline of Section 5 | [`Tinnik.outline_cut_consistent`](Tinnik/Consistency/AllmanOutline.lean#L65) | with TINNiK's cut test, the outline of an algorithm in Section 5 of Allman et al. 2023 is consistent for generic parameters |

### The sources

| Source | Lean | Statement |
| --- | --- | --- |
| Allman et al. 2023, Theorem 1 and Corollary 1 (TINNiK's Theorem 1) | [`Allman2023.cfDetectable_generic`](https://github.com/vltanh/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/FourTaxa/CFDetectable.lean#L24) | `CF`-detectability of 4-blobs on every induced network, for generic parameters; proved in lean4-allman2023 |
| Allman et al. 2023, Theorems 2 and 3 (TINNiK's Theorems 2 and 3) | [`Allman2023.rule_core`](https://github.com/vltanh/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Rule.lean#L596), [`Allman2023.closure_sound`](https://github.com/vltanh/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Rule.lean#L714), [`Allman2023.closure_complete`](https://github.com/vltanh/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Rule.lean#L706) | the B-quartet inference rule, and its closure is the set of B-quartets; proved in lean4-allman2023 |
| Mitchell et al. 2019, Theorem 3.1, for the trinomial cut model | [`External.MitchellAllmanRhodes2019.cutModel_theorem31`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/CutModel.lean#L181) | the limit law of the likelihood ratio at a cut model, in Proposition 5; proved in lean4-phylo-network |
| Rhodes 2020, Theorem 2 | [`External.Rhodes2020.theorem2`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/Rhodes2020/Theorem2.lean#L777) | the quartet distance is a tree metric with the same topology; proved in lean4-phylo-network |
| Saitou, Nei 1987; Studier, Keppler 1988 | [`Phylogenetics.NJ.isExactBuilder_nj`](https://github.com/vltanh/lean4-phylogenetics/blob/3fcabfd7d191990dda268b0b3968d945b65eb59a/Phylogenetics/Tree/NeighborJoining.lean#L1964) | neighbor joining is an exact tree builder; proved in lean4-phylogenetics |
| Studier, Keppler 1988, the Lemma | [`External.StudierKeppler1988.not_lemmaAsPrinted`](Tinnik/External/StudierKeppler1988/Lemma.lean#L96) | "If `i` and `j` are neighbors, then `S_ij` is the strictly least element in its row and column" fails on the star with four leaves and unit weights; their theorem holds with polytomies |

## What the audit found

| Finding | Where |
| --- | --- |
| The count `4(N-1)` of quartets sharing three taxa with a given one should be `4(N-4)`; no result is affected | E29 |
| The maximum likelihood estimate of Appendix C.1 need not exist on the open cut model, at counts such as `(1, 0, 0)` | E31 |
| The use of Theorem 2 needs a stronger rule than the printed one, which the same proof gives | E30 |
| The proofs of Propositions 5 and 6 have an informal remark and an unjustified differentiation; every display checks out | E32 |
| In the proof of Theorem 4, the limit law under the alternative gives no comparison at cutoffs growing with `m`, and under the null the limit needs `\|μ₀\| → ∞` | E33 |
| "This pair will be compared again later" needs the sentence before it | E40 |
| The generalization to missing taxa that line 202 calls straightforward needs each set of four taxa on more and more gene trees | E75 |
| Mitchell et al. 2019, which the paper cites, has a misprint in one display of its Appendix C; its Proposition 5.2 holds as printed | E82 |

The gaps are repaired, and none changes a statement. [Section 3 of the report](docs/Tinnik/REPORT.md#3-errors-and-gaps-in-the-paper) gives each finding with its location, the paper's sentence and the repair, and [Section 5](docs/Tinnik/REPORT.md#5-redundant-hypotheses) the redundant hypotheses: `0 ≤ δ` in Theorem 4; the star test, for the consistency claim; for the output of the T3 option, no anomalous quartets on the subsets that the tree of blobs does not resolve; and `φ ∈ (0, 1]` in Mitchell et al.'s Proposition 4.2. The proofs follow the paper's arguments, except the departures in [Section 7 of the report](docs/Tinnik/REPORT.md#7-departures-from-the-papers-proofs), each with what the paper does, what Lean does and why: Theorem 4 under the alternative repairs a gap (E33); Proposition 5 goes by the central limit theorem, since Lean lacks van der Vaart's Theorem 16.7; neighbor joining is proved by another comparison, since Studier and Keppler's Lemma fails at polytomies.

## Trust

- `lake build` passes; the only warning is the `sorry` of the Challenge's statement. There is no `sorry`, `axiom`, `native_decide` or `implemented_by` in [`Tinnik/`](Tinnik) or in the Solution.
- [`scripts/Audit.lean`](scripts/Audit.lean) checks every declaration of this repository and of the libraries it requires, `Phylogenetics`, `PhyloNetwork`, `TreeOfBlobs` and `Allman2023`, including private and generated ones, against [`propext`](https://leanprover-community.github.io/mathlib4_docs/Init/Core.html#propext), [`Classical.choice`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Classical.choice) and [`Quot.sound`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Quot.sound), and writes the routes of the proofs.
- [`scripts/route_check.py`](scripts/route_check.py) compares those routes with the paper's, in [`docs/Tinnik/paper_routes.tsv`](docs/Tinnik/paper_routes.tsv); [`docs/Tinnik/route_differences.tsv`](docs/Tinnik/route_differences.tsv) records every difference, with its reason.
- Comparator checks that the Solution proves exactly the Challenge's statement, under Lean's kernel and NanoDa; [`scripts/check_kernels.sh`](scripts/check_kernels.sh) runs it, and con-ron on an export of the same theorem.
- **No person has reviewed the proofs.** Independent agents reviewed the statements against the paper, compared the proofs with the paper's, and checked the findings.

## Dependencies

- [Mathlib](https://github.com/leanprover-community/mathlib4), at `v4.37.0-rc1`.
- [lean4-phylogenetics](https://github.com/vltanh/lean4-phylogenetics), the library of the collection, pinned by commit in [`lakefile.toml`](lakefile.toml): networks, trees and quartets, the network multispecies coalescent and generic parameters, neighbor joining and Buneman's four-point theorem.
- [lean4-phylo-network](https://github.com/vltanh/lean4-phylo-network), the library of the hub of network estimation, pinned by commit: the hypothesis tests on quartet counts, their limit laws, independent samples, and the sources Mitchell et al. 2019 and Rhodes 2020.
- [lean4-tob](https://github.com/vltanh/lean4-tob), the library of this paper's hub, pinned by commit: the TINNiK algorithm and the closure under the B-quartet inference rule, and the counts of tree edges.
- [lean4-allman2023](https://github.com/vltanh/lean4-allman2023), Allman et al. 2023, pinned by commit: TINNiK's Theorems 1, 2 and 3.

## Palomar

No submission to Palomar is planned. [`palomar/Tinnik/`](palomar/Tinnik) has the files of an entry: the Challenge, which imports only Mathlib, the Solution, [`comparator.json`](palomar/Tinnik/comparator.json), which names them and the theorem, and [`formalization.yaml`](palomar/Tinnik/formalization.yaml), the entry's metadata, with the statement aligned to the Challenge's theorem and every divergence from the paper. From the repository root, after `lake build`, run [`scripts/check_kernels.sh`](scripts/check_kernels.sh). CI checks that the Challenge's copy of the definitions is the block of [`Tinnik/Defs.lean`](Tinnik/Defs.lean) (`python3 scripts/sync_challenge_defs.py --check`).

## Building

From the root of the repository:

```sh
lake exe cache get
lake build
lake build Phylogenetics PhyloNetwork TreeOfBlobs Allman2023          # the libraries that the audit reads
lake env lean -Dlinter.deprecated.module=false scripts/Audit.lean     # axioms and dependencies
python3 scripts/route_check.py check docs/Tinnik/paper_routes.tsv --accept docs/Tinnik/route_differences.tsv
scripts/check_kernels.sh                                              # Comparator: Lean's kernel, NanoDa; con-ron
python3 scripts/linkify_docs.py                                       # the documents' links to the code
```

- Toolchain: Lean and Mathlib `v4.37.0-rc1` ([`lean-toolchain`](lean-toolchain), [`lake-manifest.json`](lake-manifest.json)).
- `lake comparator`, `leanexport` and `con-ron` come from the toolchain, under `lake env`. The kernels' replays need much memory.
- [lean4-tob's `docs/CONFIGURATION.md`](https://github.com/vltanh/lean4-tob/blob/05a024a837076455c700e5d0f88637aa22432b45/docs/CONFIGURATION.md) records the versions, the decisions, and what "line N" means.

## Layout

| Folder | Content |
| --- | --- |
| [`Tinnik/Basic/`](Tinnik/Basic) | General mathematics, in Mathlib's namespaces; [its README](Tinnik/Basic/README.md) says where each part could go |
| [`Tinnik/External/`](Tinnik/External) | The cited results, one directory per source, in the namespaces `External.<Source>`; [its README](Tinnik/External/README.md) lists them, with those proved in the libraries |
| [`Tinnik/Defs.lean`](Tinnik/Defs.lean), [`Tinnik/Bridge/`](Tinnik/Bridge) | The definitions of the Challenge, and the proof that they are the library's |
| [`Tinnik/Algorithms/`](Tinnik/Algorithms) | The algorithms' running times ([`Counts`](Tinnik/AppendixC/Definitions.lean#L35)) and the index of a set of four taxa (`LexIndex`) |
| [`Tinnik/Consistency/`](Tinnik/Consistency) | Theorem 4 (`Theorem4`), with the T3 option (`T3`), missing taxa (`MissingTaxa`), neighbor joining (`NJ`), and the outline of Allman et al. 2023 (`AllmanOutline`) |
| [`Tinnik/AppendixC/`](Tinnik/AppendixC) | The cut model and its likelihood (`Definitions`), the estimates of C.1 and Proposition 5 (`LikelihoodRatio`), the open cut model (`OpenCutModel`), Proposition 6 (`Proposition6`) |
| [`palomar/Tinnik/`](palomar/Tinnik) | The Challenge, the Solution, the Comparator configuration and the metadata |
| [`docs/Tinnik/`](docs/Tinnik) | [The report](docs/Tinnik/REPORT.md), [the credits](docs/Tinnik/CREDITS.md) and the routes of the proofs |
| [`scripts/`](scripts) | The audit, the route check, the copy of the definitions into the Challenge, the kernels, the links and the tables |

The paper's library is in the namespace [`Tinnik`](Tinnik). The repositories that require this one use some of its declarations under their names in the namespace `TINNiK`, which the modules that declare them give, as deprecated aliases of the theorems and exports of the definitions.

## Related work

From [Section 10 of the report](docs/Tinnik/REPORT.md#10-the-paper-in-the-literature).

- No other formalization of TINNiK was found.
- Before: SNaQ, Baños 2019 and NANUQ infer level-1 networks from quartets. Allman et al. 2023 showed that the tree of blobs is identifiable from gene quartet distributions, with no assumption on the level, and TINNiK makes this an algorithm with a consistency theorem. We found no earlier proof of its Theorem 4.
- Concurrent: Huber et al. 2025 and Frohn et al. 2025 determine the tree of blobs from exact quarnet information, with no statistical model. Both appeared after the TINNiK preprint and do not build on its algorithm.
- Since: TOB-QMC and ECToBlob, formalized in their own repositories of the hub lean4-tob ([TOB-QMC](https://github.com/vltanh/lean4-tob-qmc/blob/main/README.md), [ECToBlob](https://github.com/vltanh/lean4-ectoblob/blob/main/README.md)), describe TINNiK as the first algorithm for the problem and build on its tests. NANUQ⁺ and the outline of Holtgrefe et al. 2025 start from its tree of blobs, SEQUoIA uses its functions, and MSCquartets 3.3 implements it. We found no erratum to TINNiK.

## What's next

Theorem 4 is proved for binary networks under independent inheritance, `ρ = 0`. Extending it to common or correlated inheritance needs CF-detectability at generic parameters for other `ρ`, and extending it to non-binary networks needs a condition such as no trivial 4-blob on any set of four taxa. [Section 11 of the report](docs/Tinnik/REPORT.md#11-whats-next) has these, and the simpler arguments that the formalization found, among them that CF-detectability already excludes the centroid in the proof of Theorem 4. A private `NEXT.md` holds the candidate follow-up papers.

## Credits

- Requested and supervised by The-Anh Vu-Le, who chose the paper, agreed to the correction of its Appendix C.1 (E31), and decided the library's boundary and the project's layout. **No person has reviewed the proofs.** Independent agents reviewed the statements and compared the proofs with the paper.
- Codex made the source audit and first foundations of the collection, on 2026-10-27. Claude (Opus 5.5) in Claude Code, with sub-agents, wrote the statements, proofs, audit and documents, following the [formalize-math-paper](https://github.com/vltanh/formalize-math-paper) procedure.
- Made in lean4-tob on 2026-10-27 and from 2026-10-31 to 2026-11-01, with the other papers of the collection. [`docs/Tinnik/CREDITS.md`](docs/Tinnik/CREDITS.md) and lean4-tob's [`docs/CREDITS.md`](https://github.com/vltanh/lean4-tob/blob/05a024a837076455c700e5d0f88637aa22432b45/docs/CREDITS.md) have the details.

## License

[Apache-2.0](LICENSE).
