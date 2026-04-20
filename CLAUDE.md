# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Academic paper for COLM 2026 submission. The paper has two build variants:
- **`main.tex`** — COLM 2026 submission version (anonymous, `[submission]` option). Keep this intact for rebuttal.
- **`main_arxiv.tex`** — arxiv preprint version (`[preprint]` option, real authors, Author Contributions section). Packed via `pack_latex_codes.sh`.

The older `main_icml.tex` / `main_colm_example.tex` variants have been moved to `trash/`.

## Build

All LaTeX build output (`.aux`, `.log`, `.bbl`, `.blg`, `.pdf`, etc.) should go to the `.vscode/` directory to keep the repo root clean.

```bash
# COLM submission version (run from repo root, output to .vscode/)
pdflatex -output-directory=.vscode main.tex && bibtex .vscode/main && pdflatex -output-directory=.vscode main.tex && pdflatex -output-directory=.vscode main.tex

# arxiv preprint version
pdflatex -output-directory=.vscode main_arxiv.tex && bibtex .vscode/main_arxiv && pdflatex -output-directory=.vscode main_arxiv.tex && pdflatex -output-directory=.vscode main_arxiv.tex

# Pack arxiv sources into a tarball for upload
bash pack_latex_codes.sh
```

Style files (`colm2026_conference.sty`, `natbib.sty`, `fancyhdr.sty`, `algorithm.sty`, `algorithmic.sty`) are vendored in the repo root — no external package installation needed beyond a standard LaTeX distribution.

## Repository Structure

- `sec/` — Main paper sections for `main_icml.tex`: `intro.tex`, `related.tex`, `exp.tex`, `conclusion.tex`, `discussion.tex`, `limitation.tex`, `ack.tex`, `statements.tex`
- `sec/appd/` — Appendix sections: `related.tex`, `exp.tex`, `data_process.tex`, `fail_mode.tex`, `qualitative_figs.tex`, `subsec_epoch_exp.tex`
- `tables/` — Table content files and prompt templates (e.g., `benchmark.tex`, `score_prompt.tex`, `self_reflection_prompt.tex`). Also contains `effective_size.pdf`.
- `figs/` — All figures (PNG and PDF)
- `macros.tex` — Shared package imports, commenting macros, math notation shortcuts (vectors `\va`-`\vz`, matrices `\vA`-`\vZ`, calligraphic `\cA`-`\cZ`, operators)
- `math_commands.tex` — Additional math command definitions (used by `main_icml.tex`)
- `main.bib` — Bibliography database

## Key Conventions

- Author commenting macros: `\junyuan{...}` (red, JH), `\claude{...}` (green, CLD), `\outline{...}` (brown), `\rev{...}` (blue for revisions)
- The method name macro is `\method` — defined differently per main file (`\method` in COLM = "HPFA"; not defined in ICML version)
- `\llama` macro expands to "Llama3 8B Instruct" (ICML version)
- COLM template uses `[submission]` option for anonymous review (enables line numbers via `\linenumbers`)
- `sec/trash.tex` exists as a scratch/dump file

## Rules

* Do not delete files. If you need to remove content, move it to `trash/`.
