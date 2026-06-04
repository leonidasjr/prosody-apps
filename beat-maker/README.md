# BeatMaker

[![DOI](https://img.shields.io/badge/DOI-10.22456%2F1679--1916.134363-blue)](https://doi.org/10.22456/1679-1916.134363)
[![Praat](https://img.shields.io/badge/Praat-%3E%3D6.0-orange)](https://www.fon.hum.uva.nl/praat/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://www.fon.hum.uva.nl/praat/download_linux.html)

**BeatMaker** is a multilingual prosody-based script for [Praat](https://www.fon.hum.uva.nl/praat/) that extracts and visualizes the fundamental frequency (F0) contours and rhythmic beat signals of two speech recordings for direct visual and auditory comparison. It is designed for researchers, language teachers, and practitioners working with foreign language (L2) pronunciation, forensic phonetics, or clinical voice assessment.

> **Quick citation:**  
> SILVA JR., Leônidas. (2023–2026). *BeatMaker* (version 1.02). [Computer program for Praat]. Available at: <https://github.com/leonidasjr/prosody-apps>

---

## Overview

BeatMaker receives two `.wav` audio files — a **reference** voice (e.g., a native speaker, L1) and a **comparison** voice (e.g., an L2 learner, a questioned speaker) — together with a plain-text transcription file for the reference recording. The script then:

1. Performs automatic intensity-based forced alignment at the phrase level and built-in word-level alignment (TextGrid with `Text` and `Words` tiers).
2. Extracts the F0 (pitch) contour of each speaker within sex-appropriate or user-defined frequency ranges.
3. Synthesizes a **beat signal** (rhythmic pulse train derived from glottal pulses) and a **pitch humming signal** for each voice.
4. Creates stereo **Voice & Beat** composite audio objects (voice in the upper channel, beat in the lower channel) for perceptual comparison.
5. Renders a **multicolored overlay plot** of both F0 contours with the aligned TextGrid and saves it as a 600-dpi JPEG image (`BeatMaker_plot.jpg`).

---

## Repository contents

```
BeatMaker_v1_02.praat   — Main Praat script (all logic self-contained)
L1_speech.wav           — Example reference audio (native North American English)
L2_speech.wav           — Example comparison audio (Brazilian EFL speaker)
L1_speech.txt           — Transcription file for the reference recording
README.md               — This file
USER_MANUAL.md          — Step-by-step usage guide with theoretical background
CITATION.cff            — Citation metadata (CFF v1.2.0)
LICENSE                 — MIT License
```

> **Note on file naming:** Audio files must be prefixed with `L1` / `NS` / `RV` / `V1` (reference voice) or `L2` / `FS` / `CV` / `V2` (comparison voice). The transcription `.txt` file must share the exact base name of the reference `.wav` file (e.g., `L1_speech.wav` → `L1_speech.txt`).

---

## Supported languages

| Option | Language |
|--------|----------|
| 1 | English (America) |
| 2 | English (Great Britain) |
| 3 | French (France) |
| 4 | German |
| 5 | Portuguese (Brazil) |
| 6 | Portuguese (Portugal) |
| 7 | Spanish (Spain) |
| 8 | Spanish (Latin America) |
| 9 | Interlingua |

---

## Form parameters

| # | Field | Type | Default | Description |
|---|-------|------|---------|-------------|
| 1 | `Intensity_threshold_(dB)` | Real | 45.0 | Intensity floor (dB) for automatic phrase-boundary detection |
| 2 | `Reference_sound` | Word | `L1_speech` | Base name of the reference `.wav` and `.txt` files (no extension) |
| 3 | `Language` | Option menu | English (America) | Language for built-in word-level forced alignment |
| 4 | `Speaker_sex` | Choice | Male | Sets F0 range: Female (90–350 Hz), Male (75–200 Hz), Customize |
| 4.1 | `left_F0_threshold_(Hz)` | Integer | 0 | Lower F0 bound (only if `Speaker_sex = Customize`) |
| 4.1 | `right_F0_threshold_(Hz)` | Integer | 0 | Upper F0 bound (only if `Speaker_sex = Customize`) |
| 5 | `L1_speech` (color) | Option menu | Red | Plot color for the reference F0 contour |
| 5 | `L2_speech` (color) | Option menu | Blue | Plot color for the comparison F0 contour |

---

## Input files

| File | Format | Naming rule | Description |
|------|--------|-------------|-------------|
| Reference audio | `.wav` (mono, any sampling rate) | Must begin with `L1`, `NS`, `RV`, or `V1` | Speech recording of the reference speaker |
| Comparison audio | `.wav` (mono, any sampling rate) | Must begin with `L2`, `FS`, `CV`, or `V2` | Speech recording of the comparison speaker |
| Transcription | `.txt` (plain text, UTF-8) | Same base name as reference `.wav` | Orthographic transcription of the reference utterance |

---

## Output objects and files

| Object / File | Type | Description |
|---------------|------|-------------|
| `L1_Beat_and_Voice` | Praat Sound (stereo) | Reference voice (upper ch.) + beat pulses (lower ch.) |
| `L2_Beat_and_Voice` | Praat Sound (stereo) | Comparison voice (upper ch.) + beat pulses (lower ch.) |
| `L1_Pitch` | Praat Sound | Humming signal derived from the reference F0 contour |
| `L2_Pitch` | Praat Sound | Humming signal derived from the comparison F0 contour |
| TextGrid (reference) | Praat TextGrid | Two-tier object: `Text` (phrase) and `Words` (word-level) |
| `BeatMaker_plot.jpg` | JPEG, 600 dpi | Overlay plot of both F0 contours with aligned TextGrid |

---

## Requirements

- **Praat** ≥ 6.0 (free download: <https://www.fon.hum.uva.nl/praat/>)
- An internet connection is **not** required.
- All three input files (`L1_speech.wav`, `L2_speech.wav`, `L1_speech.txt`) must reside in the **same folder** as the script.
- Audio files must be `.wav` format. Stereo files should be converted to mono before use.

---

## Quick start

1. Download Praat and open it.
2. Place `BeatMaker_v1_02.praat`, both `.wav` files, and the `.txt` transcription file in the same folder.
3. In Praat, go to **Praat > Open Praat script…** and select `BeatMaker_v1_02.praat`.
4. Click **Run** (or press `Ctrl+R` / `Cmd+R`).
5. Fill in the form and click **OK**.
6. When prompted, click **Save plots?** to export the figure as `BeatMaker_plot.jpg`.

For a complete walkthrough, see [USER_MANUAL.md](USER_MANUAL.md).

---

## Applications

BeatMaker supports speech comparison across three domains:

- **Pronunciation teaching** — native vs. learner speech; different L2 proficiency levels.
- **Forensic phonetics** — reference vs. questioned voice in speaker identification scenarios.
- **Clinical voice assessment** — healthy vs. pathological voice comparison.

---

## Citation

If you use BeatMaker in your research or teaching, please cite:

```
SILVA JR., Leônidas. (2023–2026). BeatMaker (version 1.02).
[Computer program for Praat]. Available at:
https://github.com/leonidasjr/VowelCode
```

For the original validation study, please also cite:

```
SILVA JR., Leônidas José. BeatMaker: a computational system for foreign
language pronunciation teaching based on speech prosody. Revista Novas
Tecnologias na Educação (RENOTE), Porto Alegre, v. 21, n. 1, p. 341–350,
jul. 2023. DOI: https://doi.org/10.22456/1679-1916.134363
```

See also [CITATION.cff](CITATION.cff) for machine-readable citation metadata.

---

## License

BeatMaker is distributed under the [MIT License](LICENSE).  
© 2023–2026 Leônidas José da Silva Jr. — Universidade Estadual da Paraíba (UEPB), Brazil.

---

## For a demo trailer, click here: [![Demo Trailer](https://img.shields.io/badge/Demo%20Trailer-▶%20Watch%20now-E24B4A?style=for-the-badge)](https://leonidasjr.github.io/prosody-apps/beat-maker/BeatMaker_demo.html)

## Contact

**Leônidas José da Silva Jr.**  
Universidade Estadual da Paraíba (UEPB) | Universidade Federal de Pernambuco (UFPE)  
📧 leonidas.silvajr@servidor.uepb.edu.br  
🔗 ORCID: [0000-0002-3728-9851](https://orcid.org/0000-0002-3728-9851)
