#!/bin/bash
# Pack LaTeX source code for arxiv submission.
# Usage: bash pack_latex_codes.sh [output_name]
#
# Source file: main_arxiv.tex (arxiv preprint version, separate from the
# main.tex used for COLM submission / rebuttal).
# In the packed archive, main_arxiv.tex is renamed to main.tex so arxiv
# picks it up as the primary document.
#
# Prerequisites:
#   1. Compile the paper first to generate the .bbl file:
#      pdflatex -output-directory=.vscode main_arxiv.tex && \
#      bibtex .vscode/main_arxiv && \
#      pdflatex -output-directory=.vscode main_arxiv.tex && \
#      pdflatex -output-directory=.vscode main_arxiv.tex
#   2. The .bbl file must exist at .vscode/main_arxiv.bbl

set -e

OUTPUT_NAME="${1:-arxiv_submission}"
PACK_DIR="/tmp/${OUTPUT_NAME}"

# Clean up any previous pack
rm -rf "${PACK_DIR}"
mkdir -p "${PACK_DIR}/sec/appd"
mkdir -p "${PACK_DIR}/figs"
mkdir -p "${PACK_DIR}/tables"

echo "=== Packing LaTeX source for arxiv ==="

# --- Main tex files ---
# Use main_arxiv.tex as the source, but rename to main.tex in the package
# so the \bibliography{main} reference and arxiv's auto-detection work.
cp main_arxiv.tex "${PACK_DIR}/main.tex"
cp macros.tex "${PACK_DIR}/"
cp math_commands.tex "${PACK_DIR}/"

# --- Style files ---
cp colm2026_conference.sty "${PACK_DIR}/"
cp colm2026_conference.bst "${PACK_DIR}/"
cp natbib.sty "${PACK_DIR}/"
cp fancyhdr.sty "${PACK_DIR}/"
# algorithm.sty and algorithmic.sty are not used in main.tex, skip them

# --- Section files (main content) ---
cp sec/intro.tex "${PACK_DIR}/sec/"
cp sec/related.tex "${PACK_DIR}/sec/"
cp sec/exp.tex "${PACK_DIR}/sec/"
cp sec/conclusion.tex "${PACK_DIR}/sec/"
cp sec/discussion.tex "${PACK_DIR}/sec/"

# --- Appendix section files ---
cp sec/appd/related.tex "${PACK_DIR}/sec/appd/"
cp sec/appd/exp.tex "${PACK_DIR}/sec/appd/"
cp sec/appd/subsec_epoch_exp.tex "${PACK_DIR}/sec/appd/"
# qualitative_figs.tex and fail_mode.tex are commented out in main.tex, skip them

# --- Table files ---
cp tables/benchmark.tex "${PACK_DIR}/tables/"
cp tables/benchmark_llama3_full.tex "${PACK_DIR}/tables/"
cp tables/benchmark_qwen_2.5_7b.tex "${PACK_DIR}/tables/"
cp tables/benchmark_qwen2.5_0.5b.tex "${PACK_DIR}/tables/"
cp tables/benchmark_qwen3.tex "${PACK_DIR}/tables/"
cp tables/score_prompt.tex "${PACK_DIR}/tables/"
cp tables/self_reflection_prompt.tex "${PACK_DIR}/tables/"
cp tables/failure_clf_prompt.tex "${PACK_DIR}/tables/"
cp tables/llama_one_and_two_epoch.tex "${PACK_DIR}/tables/"
cp tables/llama_lr_exp.tex "${PACK_DIR}/tables/"

# --- Figures (only those actually included, not commented out) ---
cp figs/teaser.png "${PACK_DIR}/figs/"
cp figs/quality_metric_correlation_violin_new.pdf "${PACK_DIR}/figs/"
cp figs/confusion_matrix_human_vs_gpt-4o-mini_quality_acc.pdf "${PACK_DIR}/figs/"
cp figs/effective_size_new.pdf "${PACK_DIR}/figs/"
cp figs/failure_modes.pdf "${PACK_DIR}/figs/"
cp figs/failure_mode_barplot_count.pdf "${PACK_DIR}/figs/"
cp figs/failure_mode_barplot_count_reflection.pdf "${PACK_DIR}/figs/"
cp figs/wash_out_scaling_c4.pdf "${PACK_DIR}/figs/"
cp figs/wash_out_scaling_control_only.pdf "${PACK_DIR}/figs/"
# Figures from commented-out appendix sections (include for safety):
cp figs/junk-sft.png "${PACK_DIR}/figs/"
cp figs/gpt-junk-sft.png "${PACK_DIR}/figs/"

# --- Bibliography ---
# arxiv requires the .bbl file, not the .bib file
if [ -f .vscode/main_arxiv.bbl ]; then
    cp .vscode/main_arxiv.bbl "${PACK_DIR}/main.bbl"
    echo "[OK] Copied .bbl file from .vscode/main_arxiv.bbl"
elif [ -f .vscode/main.bbl ]; then
    cp .vscode/main.bbl "${PACK_DIR}/main.bbl"
    echo "[OK] Copied .bbl file from .vscode/main.bbl"
else
    echo "[WARNING] .bbl file not found (looked in .vscode/main_arxiv.bbl and .vscode/main.bbl)"
    echo "  You must compile main_arxiv.tex first to generate it."
    echo "  Copying main.bib as fallback (arxiv prefers .bbl)."
    cp main.bib "${PACK_DIR}/"
fi

# --- Create the archive ---
cd /tmp
tar czf "${OUTPUT_NAME}.tar.gz" "${OUTPUT_NAME}/"
mv "${OUTPUT_NAME}.tar.gz" "$(cd - > /dev/null && pwd)/"

echo "=== Done ==="
echo "Archive created: ${OUTPUT_NAME}.tar.gz"
echo ""
echo "Contents:"
find "${PACK_DIR}" -type f | sort | sed "s|${PACK_DIR}/||"
echo ""
echo "Total files: $(find "${PACK_DIR}" -type f | wc -l)"

# Clean up
rm -rf "${PACK_DIR}"
