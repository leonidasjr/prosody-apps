# SyllCraft

**Automatic English Syllable Segmentation Tool for L2 Phonetics Education**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Python 3.7+](https://img.shields.io/badge/python-3.7%2B-blue.svg)](https://www.python.org/)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)]()

SyllCraft is a free, open-source Python tool that automatically segments English words into syllables using three complementary criteria: **orthographic**, **phonetic (V-V / ambisyllabic)**, and **phonological (SSP-MOP)**. It was designed to support explicit phonetic-phonological instruction in English as a Foreign Language (EFL) teacher education programs, particularly for Brazilian learners whose L1 (Brazilian Portuguese) exhibits much more transparent grapheme–phoneme correspondences than English.

---

## Table of Contents

- [Background and Motivation](#background-and-motivation)
- [Features](#features)
- [Theoretical Foundations](#theoretical-foundations)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Output](#output)
- [Pedagogical Validation](#pedagogical-validation)
- [Citation](#citation)
- [License](#license)
- [Contact](#contact)

---

## Background and Motivation

Brazilian learners of English frequently struggle with syllable segmentation because they apply orthographic and phonological rules derived from Brazilian Portuguese (BP), a language with largely transparent letter-to-sound correspondences. English, by contrast, is notably opaque: the word *foreign*, for example, contains three vowel graphemes yet is pronounced as a monosyllable [fɔɹn].

SyllCraft was created to address this gap. By displaying three different segmentation analyses side by side, it enables learners and teachers to visualize syllable boundaries from multiple theoretical perspectives, fostering metalinguistic and phonological awareness of the target L2.

The tool was developed for use within the discipline *Fonética da Língua Inglesa I* at the Universidade Estadual da Paraíba (UEPB) and has been empirically validated in a pre-instruction/post-instruction classroom experiment (see [Pedagogical Validation](#pedagogical-validation)).

---

## Features

- **Three segmentation criteria** displayed simultaneously in a formatted table:
  - Orthographic (Hunspell/American English hyphenation via pyphen)
  - Phonetic V-V / ambisyllabic (Barbosa, 2006; Ladefoged & Johnson, 2011)
  - Phonological SSP-MOP (Selkirk, 1982, 1984; Clements, 1990)
- **IPA transcription** of each word, generated automatically
- **Syllable counts** for each segmentation method
- **Graphical user interface** (Tkinter dialog) — no command-line arguments required
- **Tab-delimited output file** (`segmented_words.txt`) for further analysis in R, Excel, or other tools
- **Batch processing**: multiple words can be entered at once, separated by commas
- Flexible and extensible: the codebase is designed to incorporate additional languages in future versions

---

## Theoretical Foundations

SyllCraft implements three models of syllabification:

### 1. Orthographic segmentation
Conventional written syllabification based on Hunspell hyphenation dictionaries for American English (implemented via the `pyphen` library). This reflects the segmentation taught in schools and printed in standard dictionaries.

### 2. Phonetic V-V segmentation (Ambisyllabic model)
Based on the notion of the **phonetic syllable** as a V-V interval — the stretch from the onset of one vowel to the onset of the next (Barbosa, 2006). Inter-vocalic consonants are treated as ambisyllabic (Ladefoged & Johnson, 2011), consistent with the concept of perceptual centers (P-centers) described by Morton et al. (1976). IPA transcription is performed automatically using `eng_to_ipa`.

### 3. Phonological segmentation (SSP-MOP)
Implements the algorithm proposed by Selkirk (1982, 1984):
- **Maximal Onset Principle (MOP)**: consonants between vowels are assigned to the onset of the following syllable whenever English phonotactics permit.
- **Sonority Sequencing Principle (SSP)** (Clements, 1990): segments within a syllable must rise in sonority toward the nucleus and fall toward the coda.

---

## Requirements

- Python 3.7 or higher
- The following Python packages:

| Package | Purpose |
|---|---|
| `eng_to_ipa` | IPA transcription of English words |
| `pyphen` | Orthographic hyphenation (Hunspell/American English) |
| `tabulate` | Formatted terminal table output |
| `tkinter` | GUI dialog (included in the Python standard library) |

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/leonidasjr/SyllCraft.git
cd SyllCraft
```

### 2. (Recommended) Create a virtual environment

```bash
python -m venv venv
source venv/bin/activate        # Linux / macOS
venv\Scripts\activate           # Windows
```

### 3. Install dependencies

```bash
pip install eng-to-ipa pyphen tabulate
```

> **Note:** `tkinter` is bundled with most Python distributions. On some Linux systems you may need to install it separately:
> ```bash
> sudo apt-get install python3-tk   # Debian/Ubuntu
> ```

---

## Usage

Run SyllCraft from the terminal or from your IDE:

```bash
python SyllCraft.py
```

A dialog window will open. Type one or more English words separated by commas in the text area, then click **OK**.

**Example input:**
```
example, apple, bicycle, pronunciation, aspirin, constitution, rhythm
```

The segmentation table will be printed in the terminal and the results will be saved to `segmented_words.txt` in the current working directory.

---

## Output

### Terminal table

```
+------------------+-------------------+------------+---------------------------+------------+---------------------------+-------------+
|       Word       |       Ortho       | Ortho_Syll |           Phon            | Phon_Syll  |          SSP-MOP          | SSP-MOP_Syll|
+==================+===================+============+===========================+============+===========================+=============+
|    example       | ['ex', 'am', 'ple']|     3      |   ['ɪɡ', 'zæm', 'pəl']   |     3      |  ['ɪɡ', 'zæm', 'pəl']    |      3      |
+------------------+-------------------+------------+---------------------------+------------+---------------------------+-------------+
```

The output table contains the following columns:

| Column | Description |
|---|---|
| `Word` | The input word as typed |
| `Ortho` | Orthographic syllables (Hunspell/American English) |
| `Ortho_Syll` | Number of orthographic syllables |
| `Phon` | Phonetic syllables in IPA (V-V / ambisyllabic model) |
| `Phon_Syll` | Number of phonetic syllables |
| `SSP-MOP` | Phonological syllables in IPA (Selkirk's MOP + Clements's SSP) |
| `SSP-MOP_Syll` | Number of phonological syllables |

### File output

Results are automatically saved to `segmented_words.txt` (tab-delimited, UTF-8 encoded) in the current directory. This file can be opened directly in Excel, LibreOffice Calc, or R for further analysis.

---

## Pedagogical Validation

SyllCraft was validated in a controlled pre-instruction/post-instruction study conducted at UEPB with 28 undergraduate EFL students (Letras-Inglês). Participants performed a syllabification task before and after four sessions of explicit instruction using SyllCraft (16 hours total).

**Results (paired t-test):**

| Condition | Mean (M) | SD (DP) |
|---|---|---|
| Pre-instruction | 6.35 | 1.42 |
| Post-instruction | 8.10 | 1.25 |

- *t*(27) = 6.34, *p* < 0.001, Cohen's *d* = 1.20

A Cohen's *d* of 1.20 indicates a large, practically meaningful effect, confirming that explicit instruction mediated by SyllCraft produced a significant improvement in syllabification accuracy beyond what would be expected by chance.

For the full study, see:

> Silva Júnior, L. J., [co-authors]. A segmentação silábica no inglês por aprendizes brasileiros: Contribuições fonético-fonológicas para a formação de professores. *Lingu@ Nostr@*, v. 10, n. 1, 2023.

---

## Citation

If you use SyllCraft in research or teaching, please cite it as follows:

### APA
```
Silva Júnior, L. J. (2024–2026). SyllCraft (Version 1.0.0) [Computer software].
https://github.com/leonidasjr/SyllCraft
```

### BibTeX
```bibtex
@software{silvajunior2024syllcraft,
  author    = {Silva Jr., Leônidas},
  title     = {{SyllCraft}: Automatic English Syllable Segmentation Tool},
  year      = {2024},
  version   = {1.0.0},
  url       = {https://github.com/leonidasjr/SyllCraft},
  license   = {MIT}
}
```

A full `CITATION.cff` file is also provided in this repository.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Contact

**Leônidas José da Silva Júnior**  
Professor — Universidade Estadual da Paraíba (UEPB) / Universidade Federal de Pernambuco (UFPE)  
Researcher in Phonetics, Phonology, and Language Teaching Technology  
📧 leonidas.silvajr@servidor.uepb.edu.br
