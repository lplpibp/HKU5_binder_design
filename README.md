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
| HKU5-CoV-2 | 9JJ6 |
| MRCoV | 8ZWE |

1) Remove the receptor chain from the PDB structure.
2) Model and reconstruct the missing loop regions to complete the protein structure.
3) Renumber the RBD residues starting from 1.
4) Identify critical interface hotspot residues.

### Step 2. Backbone Generation

Generate diverse de novo binder backbones using RFdiffusion.

```bash
conda activate SE3nv

python /path/to/your/RFdiffusion/scripts/run_inference.py  \
'contigmap.contigs=[B1-181/0 100-110]' \
'ppi.hotspot_res=[B156]' \
inference.output_prefix=binder\1441 \
inference.input_pdb=1441.pdb \
inference.num_designs=50 \
inference.deterministic=True \
inference.design_startnum=1
```

---

### Step 3. Sequence Design

Optimize amino acid sequences using ProteinMPNN.

```bash
bash scripts/run_proteinmpnn.sh \
    --input outputs/rfdiffusion \
    --output outputs/mpnn
```

---

### Step 4. Structure Prediction

Predict binder structures using AlphaFold2.

```bash
bash scripts/run_alphafold.sh \
    --input outputs/mpnn \
    --output outputs/alphafold
```

Only models with the highest confidence (pLDDT) were retained for downstream analysis.

---

### Step 5. Interface Evaluation

Evaluate binding interfaces using Rosetta (beta_nov16 energy function).

```bash
bash scripts/run_rosetta.sh \
    --input outputs/alphafold \
    --output outputs/rosetta
```

The following metrics are calculated:

- Rosetta Interface Score
- Contact Molecular Surface Area
- Shape Complementarity
- Interface Energy

---

## Repository Structure

```
.
├── configs/
├── data/
├── hotspots/
├── scripts/
├── src/
├── outputs/
├── examples/
└── README.md
```

---

## Requirements

- Python ≥ 3.10
- RFdiffusion
- ProteinMPNN
- AlphaFold2
- Rosetta
- CUDA-enabled GPU (recommended)

Install dependencies

```bash
conda env create -f environment.yml
conda activate binder_design
```

---

## Running the Pipeline

Example:

```bash
bash scripts/design_pipeline.sh \
    --target HKU5 \
    --output results/HKU5
```

or

```bash
bash scripts/design_pipeline.sh \
    --target MRCoV \
    --output results/MRCoV
```

---

## Citation

If you use this repository in your research, please cite:

```
Citation information will be added after publication.
```

---

## License

This project is released under the MIT License.

