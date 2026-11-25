# The results the paper cites

One directory per source, `Tinnik/External/<Source>/`, with modules `Tinnik.External.<Source>.…`,
declarations in the namespace `External.<Source>`, and a [`README.md`](README.md) giving the source, the
statement, how the paper uses it, whether the source was read, and the argument that proves it.
Each result is stated in its source's terms and proved; none is assumed. These modules import
Mathlib, [`Tinnik/Basic/`](../Basic) and the libraries this repository requires, never the paper's library.

A source that another repository of the collection already formalizes (lean4-phylogenetics, the
hubs lean4-phylo-network and lean4-phylo-tree-of-blobs, or the repository of a paper) is not formalized again
(lean4-phylogenetics, docs/CONVENTIONS.md, Sections 4 and 6).

| Source | Where | What the paper uses |
| --- | --- | --- |
| Studier, Keppler 1988 | [`StudierKeppler1988/`](StudierKeppler1988) | neighbor joining, in Step 4 of the algorithm: their Lemma fails at a polytomy ([`External.StudierKeppler1988.not_lemmaAsPrinted`](StudierKeppler1988/Lemma.lean#L96)); their theorem holds with polytomies, in lean4-phylogenetics ([`Phylogenetics.NJ.exists_QC_lt_of_not_nbr`](https://github.com/formal-phylogenetics/lean4-phylogenetics/blob/3fcabfd7d191990dda268b0b3968d945b65eb59a/Phylogenetics/Tree/NeighborJoining.lean#L785)), and neighbor joining is an exact tree builder there ([`Phylogenetics.NJ.isExactBuilder_nj`](https://github.com/formal-phylogenetics/lean4-phylogenetics/blob/3fcabfd7d191990dda268b0b3968d945b65eb59a/Phylogenetics/Tree/NeighborJoining.lean#L1964)) |
| Allman, Baños, Mitchell, Rhodes 2023 | [`Allman2023/`](Allman2023), proved from lean4-allman2023 | TINNiK's Theorems 1, 2 and 3: the `CF`-detectability of 4-blobs for generic parameters ([`External.Allman2023.cfDetectable_generic`](Allman2023/CFDetectable.lean#L34)), the B-quartet inference rule and the closure under it ([`External.Allman2023.closure_sound`](Allman2023/Rule.lean#L35), [`External.Allman2023.closure_complete`](Allman2023/Rule.lean#L43)), and the steps of its proofs and of its Section 5 that the proofs here use |
| Mitchell, Allman, Rhodes 2019 | lean4-phylo-network, `PhyloNetwork/External/MitchellAllmanRhodes2019/`, in the namespace `External.MitchellAllmanRhodes2019` | Theorem 3.1 for the trinomial cut model, in Proposition 5 ([`External.MitchellAllmanRhodes2019.cutModel_theorem31`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/CutModel.lean#L181)); the T3 test and its limit law, for the T3 option |
| Rhodes 2020 | lean4-phylo-network, `PhyloNetwork/External/Rhodes2020/`, in the namespace `External.Rhodes2020` | the quartet intertaxon distance is a tree metric on the tree of blobs, in Step 3 of the algorithm and the proof of Theorem 4 ([`External.Rhodes2020.theorem2`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/Rhodes2020/Theorem2.lean#L777), [`External.Rhodes2020.quartetWeight_ge_two`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/Rhodes2020/Theorem2.lean#L869)) |

Allman et al. 2023 is formalized in its own repository, lean4-allman2023: each of its results that the
proofs here use is stated in [`Allman2023/`](Allman2023) and proved from that repository's theorem
(lean4-phylogenetics, docs/CONVENTIONS.md, Section 6).

## What the sources share with the paper's library

The cited results are stated on the definitions of lean4-phylogenetics and of the hubs (networks,
split families, quartet trees, [`Displays`](https://github.com/formal-phylogenetics/lean4-phylogenetics/blob/3fcabfd7d191990dda268b0b3968d945b65eb59a/Phylogenetics/Tree/Defs.lean#L84), [`quartetDistance`](https://github.com/formal-phylogenetics/lean4-phylogenetics/blob/3fcabfd7d191990dda268b0b3968d945b65eb59a/Phylogenetics/Tree/Defs.lean#L123), the neighbor-joining algorithm), so
the sources need no definition of the paper. No module here imports the paper's library.
