#!/bin/bash

# ==============================
# 用户需要修改的参数
# ==============================

ROSETTA_BIN="/home/lthpc/softwares/rosetta.source.release-371/main/source/bin/rosetta_scripts.default.linuxgccrelease"

INPUT_PDB="4m_hACE2-apo.pdb"

XML_FILE="relax_interface.xml"

OUTPUT_DIR="rosetta_interface_results"

NSTRUCT=1

# ==============================
# 创建输出目录
# ==============================

mkdir -p "${OUTPUT_DIR}"

# ==============================
# 运行Rosetta
# ==============================

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

echo "Rosetta计算完成。"
echo "结构文件：${OUTPUT_DIR}"
echo "打分文件：${OUTPUT_DIR}/interface_score.sc"
