# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Academic paper for COLM 2026 submission. The paper has two template variants:
- **`main_icml.tex`** — Original main file using ICML 2026 template (paper title: "LLMs Can Get Brain Rot!"). This is the substantive paper with full content.
- **`main_colm_example.tex`** — COLM 2026 template version (paper title: "HPFA: Hypergraph-Based Paired Failure Attribution for LLM Reasoning"). This references `section/` subdirectory (not `sec/`), indicating it may be a separate/newer draft.

## Build

All LaTeX build output (`.aux`, `.log`, `.bbl`, `.blg`, `.pdf`, etc.) should go to the `.vscode/` directory to keep the repo root clean.

```bash
# Compile with bibliography (run from repo root, output to .vscode/)
pdflatex -output-directory=.vscode main_icml.tex && bibtex .vscode/main && pdflatex -output-directory=.vscode main_icml.tex && pdflatex -output-directory=.vscode main_icml.tex

# For the COLM version
pdflatex -output-directory=.vscode main_colm_example.tex && bibtex .vscode/main_colm_example && pdflatex -output-directory=.vscode main_colm_example.tex && pdflatex -output-directory=.vscode main_colm_example.tex
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
