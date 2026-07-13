# HKU5/MRCoV Miniprotein Binder Design Pipeline

Official implementation of the computational pipeline for **de novo design, screening, and evaluation of miniprotein binders targeting the receptor-binding domains (RBDs) of HKU5-CoV-2 and MRCoV**.

---

## Overview

This repository implements a deep-learning-enabled computational workflow for designing high-affinity de novo binders against the HKU5-CoV-2 and MRCoV spike RBDs.

The design strategy integrates recent advances in generative protein design, sequence optimization, structure prediction, and physics-based interface evaluation to identify experimentally testable binder candidates.

---

## Pipeline

The complete workflow consists of the following steps:

```
Input Structures
        │
        ▼
Backbone Generation
        │
        ▼
Sequence Design
        │
        ▼
Structure Prediction
        │
        ▼
Interface Evaluation
        │
        ▼
Experimental Candidates
```

---

## Workflow

### Step 1. Input Structures

The pipeline uses experimentally determined ACE2-bound RBD structures as design templates.

| Virus | PDB ID |
|--------|--------|
| HKU5-CoV-2 (or 1441)| 9JJ6 |
| MRCoV | 8ZWE |

1) Remove the receptor chain from the PDB structure.
2) Model and reconstruct the missing loop regions to complete the protein structure.
3) Renumber the RBD residues starting from 1.
4) Identify critical interface hotspot residues.

### Step 2. Backbone Generation

Generate diverse de novo binder backbones using RFdiffusion.

```bash
conda activate SE3nv
```
For 1441, please run:
```bash
python /path/to/your/RFdiffusion/scripts/run_inference.py  \
'contigmap.contigs=[B1-181/0 50-100]' \
'ppi.hotspot_res=[B156]' \
inference.output_prefix=binder\1441 \
inference.input_pdb=1441.pdb \
inference.num_designs=500 \
inference.design_startnum=1
```
For MRCoV, please run:
```bash
python /path/to/your/RFdiffusion/scripts/run_inference.py  \
'contigmap.contigs=[B1-201/0 50-100]' \
'ppi.hotspot_res=[B169]' \
inference.output_prefix=binder\MRCoV \
inference.input_pdb=MRCoV.pdb.pdb \
inference.num_designs=500 \
inference.design_startnum=1
```
---

### Step 3. Sequence Design

Optimize amino acid sequences using ProteinMPNN.

```bash
mkdir mpnn_input
```
```bash
cp 1441_x.pdb mpnn_input
```
```bash
conda activate mlfold
```
```bash
python /path/to/your/ProteinMPNN-main/helper_scripts/parse_multiple_chains.py \
--input_path mpnn_input   \
--output_path parsed_pdbs.jsonl
```
```bash
python /path/to/your/ProteinMPNN-main/helper_scripts/assign_fixed_chains.py   \
--input_path parsed_pdbs.jsonl   \
--output_path assigned_pdbs.jsonl   \
--chain_list "A"
```
```bash
python /path/to/your/ProteinMPNN-main/protein_mpnn_run.py   \
--jsonl_path parsed_pdbs.jsonl   \
--chain_id_jsonl assigned_pdbs.jsonl   \
--out_folder mpnn_output   \
--num_seq_per_target 10   \
--sampling_temp "0.1"   \
--seed 37   \
--batch_size 1
```
---

### Step 4. Structure Prediction

Predict binder structures using AlphaFold3.
Only models with good iPTM were retained for downstream analysis.

---

### Step 5. Interface Evaluation

Evaluate binding interfaces using Rosetta.

```bash
bash scripts/run_relax_interface.sh
```

The following metrics are calculated:

- Rosetta Interface Score
- Contact Molecular Surface Area
- Shape Complementarity
- Interface Energy

---

## Repository Structure

```
├── inputs/
├── outputs/
├── scripts/
└── README.md
```

---

## Requirements

- RFdiffusion
- ProteinMPNN
- AlphaFold3
- Rosetta

---


## License

This project is released under the MIT License.

