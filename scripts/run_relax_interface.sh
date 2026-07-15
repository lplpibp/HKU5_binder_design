#!/bin/bash

ROSETTA_BIN="/path/to/rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease"
INPUT_PDB="input.pdb"
XML_PROTOCOL="relax_interface.xml"
OUTPUT_DIR="rosetta_results"
NSTRUCT=1

mkdir -p "${OUTPUT_DIR}"

echo "========================================="
echo "Running Rosetta FastRelax..."
echo "Input PDB : ${INPUT_PDB}"
echo "Protocol  : ${XML_PROTOCOL}"
echo "Output    : ${OUTPUT_DIR}"
echo "========================================="

"${ROSETTA_BIN}" \
    -s "${INPUT_PDB}" \
    -parser:protocol "${XML_PROTOCOL}" \
    -beta_nov16 \
    -nstruct "${NSTRUCT}" \
    -out:path:all "${OUTPUT_DIR}" \
    -out:file:scorefile interface_score.sc \
    -out:suffix _beta_relaxed \
    -use_input_sc \
    -flip_HNQ \
    -no_optH false \
    -relax:constrain_relax_to_start_coords \
    -relax:coord_constrain_sidechains \
    -relax:ramp_constraints false \
    -ex1 \
    -ex2aro \
    -overwrite \
    > "${OUTPUT_DIR}/rosetta.log" 2>&1

EXIT_CODE=$?


if [ ${EXIT_CODE} -ne 0 ]; then
    echo ""
    echo "Rosetta failed."
    echo "Exit code : ${EXIT_CODE}"
    echo "See log file:"
    echo "${OUTPUT_DIR}/rosetta.log"
    exit ${EXIT_CODE}
fi

echo ""
echo "========================================="
echo "Rosetta finished successfully."
echo ""
echo "Relaxed structures:"
echo "  ${OUTPUT_DIR}"
echo ""
echo "Score file:"
echo "  ${OUTPUT_DIR}/interface_score.sc"
echo ""
echo "Log file:"
echo "  ${OUTPUT_DIR}/rosetta.log"
echo "========================================="
