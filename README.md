# Lecture 02 – Sampling and Aliasing

## Objective
The purpose of this investigation is to evaluate analog-to-digital conversion parameters for an industrial condition monitoring system. By sampling a 10 Hz vibration signal across multiple sample rates (15 Hz to 100 Hz), we investigate the boundary conditions of the Nyquist-Shannon Sampling Theorem, visualize reconstruction distortion and aliasing, and identify an optimal sampling frequency for practical engineering deployment.

---

## Nyquist Analysis
The Nyquist-Shannon Sampling Theorem states that to perfectly reconstruct a continuous, band-limited signal without aliasing, the sampling frequency ($f_s$) must be strictly greater than twice the highest frequency component ($f_{\max}$) present in the signal:

$$f_s > 2 \cdot f_{\max}$$

Given the vibration signal frequency $f_{\max} = 10\text{ Hz}$:

$$f_{\text{Nyquist}} = 2 \cdot 10\text{ Hz} = 20\text{ Hz}$$

### Compliance Evaluation
* **15 Hz:** $15\text{ Hz} < 20\text{ Hz}$ — **Violates criterion** (aliasing occurs).
* **20 Hz:** $20\text{ Hz} = 20\text{ Hz}$ — **Meets boundary rate** (theoretically critical, practically non-viable).
* **25 Hz:** $25\text{ Hz} > 20\text{ Hz}$ — **Satisfies criterion**.
* **50 Hz:** $50\text{ Hz} > 20\text{ Hz}$ — **Satisfies criterion**.
* **100 Hz:** $100\text{ Hz} > 20\text{ Hz}$ — **Satisfies criterion**.

### Practical Viability at Exactly the Nyquist Rate
Sampling exactly at $f_s = 2 \cdot f_{\max}$ (20 Hz) is **not recommended** in practice:
1. **Phase Dependency:** If samples coincide with the signal's zero-crossings (e.g., $\sin(2\pi \cdot 10 \cdot t)$ sampled at intervals of $0.05\text{ s}$ yields $t = 0, 0.05, 0.10 \dots$), every sample value is exactly $0$. The signal disappears entirely.
2. **Filter Constraints:** Perfect reconstruction at the theoretical boundary demands an ideal "brick-wall" low-pass filter with an infinite transition slope, which is physically impossible and introduces severe phase distortion.

---

## Results

| Sampling Frequency ($f_s$) | Samples per Cycle ($f_s / f_{\text{signal}}$) | Observed Behavior |
| :--- | :--- | :--- |
| **15 Hz** | 1.5 | **Severe Aliasing:** The sampled points trace out an apparent sine wave at $\vert{}15 - 10\vert{} = 5\text{ Hz}$. Peak amplitudes and cycle boundaries are misidentified. |
| **20 Hz** | 2.0 | **Critical Failure:** Because the signal starts at phase 0, all sample instances fall exactly on zero-crossings, resulting in a flatline at $0\text{ amplitude}$. |
| **25 Hz** | 2.5 | **Distorted Tracking:** Avoids mathematical aliasing ($25 > 20$), but linear interpolation produces severe beat-envelope distortion and poorly resolves peak vibration levels. |
| **50 Hz** | 5.0 | **Adequate Reconstruction:** Five points per cycle reliably preserve the 10 Hz periodicity and track waveform peaks with moderate fidelity. |
| **100 Hz** | 10.0 | **High Fidelity:** The reconstructed profile closely overlays the true analog signal, accurately capturing cycle dynamics, zero crossings, and peak amplitudes. |

---

## Aliasing Discussion
Aliasing occurs when $f_s < 2 f_{\max}$. In our test, this occurs at **15 Hz** (where the 10 Hz tone reflects across the 7.5 Hz folding frequency to produce an alias at $5\text{ Hz}$) and degenerates at **20 Hz** due to phase cancellation. 

Aliasing happens because discrete-time sampling records data points at fixed intervals ($T_s$). When intervals are spaced too far apart, multiple continuous waveforms with different frequencies intersect the exact same discrete points, rendering them indistinguishable to digital algorithms.

For an industrial condition monitoring system, a sampling frequency of **100 Hz ($10 \times f_{\max}$)** is recommended. In vibration diagnostics, accuracy in extracting peak amplitude and detecting harmonic distortions is critical for predictive maintenance. A rate of 100 Hz provides clean waveform visibility without requiring complex reconstruction filters. At a data rate of 100 samples/second, processing and storage overhead remain trivial for modern microcontrollers and DSP algorithms, achieving optimal robustness.

---

## Engineering Recommendation
* **Selected Frequency:** **100 Hz** ($10 \times f_{\max}$)
* **Trade-off Justification:** While 50 Hz meets the technical Nyquist requirement and captures basic frequency, 100 Hz ensures under 5% peak-amplitude estimation error under arbitrary phase alignment. The computational footprint (100 samples/second at 16-bit single-axis resolution = 200 bytes/sec) is easily handled by entry-level embedded microcontrollers and edge AI systems.

---

## AI Usage

* **AI Tool Used:** Gemini
* **Prompt(s):**
  > "Generate a complete MATLAB script for condition monitoring vibration analysis. Simulate a 10 Hz sine wave for 1 second, sample it at 15, 20, 25, 50, and 100 Hz, export each figure as a PNG, and explain why sampling at the exact Nyquist rate causes phase cancellation."
* **Summary of AI Response:**
  The AI provided a script setting up high-resolution continuous time arrays alongside discrete-sample stem plots. It explained how sampling a pure sine wave at its exact Nyquist frequency can collapse into all zeros if the sample instances hit the zero-crossing points ($t = n / 2f$).
* **What I Modified:**
  * Replaced basic `saveas` commands with `exportgraphics(..., 'Resolution', 300)` for publication-grade, crisp image outputs.
  * Added dashed reconstruction traces (`--`) on top of stems to directly visualize the digital alias wave for 15 Hz and 25 Hz.
  * Set explicit axis boundaries (`xlim`, `ylim`) across all figures for consistent cross-comparison.
* **How I Verified the Results:**
  * Ran `Lecture02_sampling_aliasing.m` in MATLAB R2024b and checked that all 6 image files saved correctly in the active directory.
  * Verified that at $f_s = 15\text{ Hz}$, the apparent period of the interpolated waveform spans $0.2\text{ s}$, which confirms an alias frequency of $f_{\text{alias}} = \vert{}10 - 15\vert{} = 5\text{ Hz}$.
  * Verified that sampling at 20 Hz yielded $0$ amplitude at all evaluation points ($\sin(k\pi) = 0$).
