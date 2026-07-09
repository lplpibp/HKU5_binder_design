# HKU5_binder_design
Computational design and screening of protein binders targeting the HKU5 coronavirus RBD.

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
ACE2–RBD Complex Structures
        │
        ▼
Hotspot Identification
        │
        ▼
RFdiffusion
Backbone Generation
        │
        ▼
ProteinMPNN
Sequence Design
        │
        ▼
AlphaFold2
Structure Prediction
        │
        ▼
Rosetta
Interface Evaluation
        │
        ▼
Multi-parameter Filtering
(pLDDT + RMSD + Interface Score + Contact Surface Area)
        │
        ▼
Experimental Candidates
```

---

## Input Structures

The pipeline uses experimentally determined ACE2-bound RBD structures as design templates.

| Virus | PDB ID |
|--------|--------|
| HKU5-CoV-2 | 9JJ6 |
| MRCoV | 8ZWE |

Critical interface hotspot residues were identified from these co-crystal structures and used as target epitopes during binder design.

---

## Workflow

### Step 1. Backbone Generation

Generate diverse de novo binder backbones using RFdiffusion.

```bash
bash scripts/run_rfdiffusion.sh \
    --target data/HKU5_RBD.pdb \
    --hotspots hotspots/hku5.txt \
    --output outputs/rfdiffusion
```

---

### Step 2. Sequence Design

Optimize amino acid sequences using ProteinMPNN.

```bash
bash scripts/run_proteinmpnn.sh \
    --input outputs/rfdiffusion \
    --output outputs/mpnn
```

---

### Step 3. Structure Prediction

Predict binder structures using AlphaFold2.

```bash
bash scripts/run_alphafold.sh \
    --input outputs/mpnn \
    --output outputs/alphafold
```

Only models with the highest confidence (pLDDT) were retained for downstream analysis.

---

### Step 4. Rosetta Interface Evaluation

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

### Step 5. Candidate Filtering

Candidate binders are selected using multiple structural criteria.

Current filtering thresholds include:

| Metric | Threshold |
|---------|-----------|
| Contact Molecular Surface Area | > 382 Å² |
| Rosetta Interface Score | < -394 REU |
| AlphaFold2 pLDDT | Highest confidence |
| RMSD | Lowest structural deviation |

Only candidates satisfying all criteria are retained for experimental validation.

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

