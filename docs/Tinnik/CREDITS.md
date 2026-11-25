# Credits

TINNiK (Allman, Baños, Mitchell, Rhodes 2024), in Lean.

- **Maintainer:** The-Anh Vu-Le, who chose the paper, agreed to the corrections of its statements that
  [the report](REPORT.md) records, and decided the layout. **No person has reviewed the proofs.**
- **Formalization:** Claude (Opus 5.5) in Claude Code, with sub-agents, following the
  [formalize-math-paper](https://github.com/vltanh/formalize-math-paper) procedure; the first foundations and
  the source audit by Codex. The work was done in [lean4-phylo-tree-of-blobs](https://github.com/formal-phylogenetics/lean4-phylo-tree-of-blobs), with the other
  papers on the tree of blobs, from 2026-10-27 to 2026-11-04. The rounds, the agents and models, and the time and
  effort of each are in lean4-phylo-tree-of-blobs's
  [`docs/CREDITS.md`](https://github.com/formal-phylogenetics/lean4-phylo-tree-of-blobs/blob/6e7bc494d26f3d7096a17adffbfde1cf559f0ae9/docs/CREDITS.md),
  at the last commit before the split.
- **Moved to this repository** on 2026-11-21, by Claude (Opus 5.5) in Claude Code, when lean4-phylo-tree-of-blobs became the hub
  of its papers. No statement and no proof changed: only module paths did. Every declaration keeps its name and its
  type, checked against lean4-phylo-tree-of-blobs at commit `6e7bc49`, and the audit and the route check pass here.
- **Arranged in the layout of the collection** on 2026-11-25, by Claude (Opus 5.5) in Claude Code: the root
  [`Tinnik`](../../Tinnik), the library by the paper's sections, general mathematics in [`Tinnik/Basic/`](../../Tinnik/Basic), and a Challenge that states
  Theorem 4 on definitions in Mathlib's vocabulary, with the bridges to the library's. The statements of the library
  keep their meaning; the declarations are renamed from the namespace `TINNiK` to [`Tinnik`](../../Tinnik).
