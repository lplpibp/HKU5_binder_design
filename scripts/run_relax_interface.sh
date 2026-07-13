#!/bin/bash
ROSETTA_BIN="/path/to/your/rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease"
INPUT_PDB="your.pdb"
XML_FILE="relax_interface.xml"
OUTPUT_DIR="rosetta_interface_results"
NSTRUCT=1

mkdir -p "${OUTPUT_DIR}"

"${ROSETTA_BIN}" \
    -s "${INPUT_PDB}" \
    -parser:protocol "${XML_FILE}" \
    -nstruct "${NSTRUCT}" \
    -out:path:all "${OUTPUT_DIR}" \
    -out:file:scorefile interface_score.sc \
    -out:suffix _relaxed \
    -use_input_sc \
    -flip_HNQ \
    -no_optH false \
    -constrain_relax_to_start_coords \
    -relax:coord_constrain_sidechains \
    -relax:ramp_constraints false \
    -ex1 \
    -ex2aro \
    -overwrite

echo "Rosetta complete!"
echo "PDB files：${OUTPUT_DIR}"
echo "Score files：${OUTPUT_DIR}/interface_score.sc"
