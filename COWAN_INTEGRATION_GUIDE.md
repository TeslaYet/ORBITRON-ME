# Cowan Atomic Parameters Integration Guide

## Overview

The Multiplet GUI now includes integrated support for Cowan's atomic structure codes, allowing you to automatically calculate Slater-Condon parameters instead of entering them manually. This eliminates guesswork and ensures accurate atomic parameters for your multiplet calculations.

## What is Cowan's Program?

Cowan's atomic structure codes, originally developed by R.D. Cowan, are the gold standard for calculating atomic parameters including:
- Coulomb integrals (F_k)
- Exchange integrals (G_k) 
- Spin-orbit coupling parameters (ζ)

These parameters are essential for accurate multiplet theory calculations in X-ray spectroscopy.

## Setup Instructions

### 1. Install atomic-parameters Tool

```bash
# Clone the repository
git clone https://github.com/mretegan/atomic-parameters.git

# Navigate to directory
cd atomic-parameters

# Install dependencies
pip install -r requirements.txt

# Test the installation
python3 parameters.py --element "Fe" --configuration "1s1,3d5"
```

### 2. Verify Installation

You should see output like:
```
INFO: Fe 1s1,3d5 
INFO: E = -27384.1640 eV
INFO: F2(3d,3d) = 13.7105 eV
INFO: F4(3d,3d) = 8.6178 eV
INFO: ζ(3d) = 0.0837 eV
INFO: G2(1s,3d) = 0.0733 eV
```

## Using the Integration

### 1. Open the Multiplet GUI

```bash
cd ORBITRON-ME
source venv/bin/activate
cd Multiplet2/RPES
python3 multiplet_gui.py
```

### 2. Navigate to Create Input Tab

The "Cowan Atomic Parameters Calculator" section is at the top of the Create Input tab.

### 3. Enter Parameters

- **Element**: Chemical symbol (e.g., "Fe", "Ni", "Co", "Mn")
- **Configuration**: Electronic configuration (e.g., "1s1,3d5", "3d5", "2p5,3d5")
- **Atomic-params path**: Path to atomic-parameters directory (auto-detected)

### 4. Calculate Parameters

1. Click "Calculate Parameters"
2. Wait for Cowan's calculation to complete (may take a few seconds)
3. Review the calculated parameters in the results panel

### 5. Populate Fields

1. Click "Populate Fields" to automatically fill the Slater-Condon parameters
2. Parameters are applied to Ground State, Final State, and Intermediate State sections
3. The input preview will update automatically

## Supported Electronic Configurations

### Common 3d Transition Metals

| Element | Oxidation States | Example Configurations |
|---------|-----------------|----------------------|
| Ti      | Ti³⁺, Ti⁴⁺      | 3d1, 3d0            |
| V       | V³⁺, V⁴⁺, V⁵⁺   | 3d2, 3d1, 3d0       |
| Cr      | Cr²⁺, Cr³⁺      | 3d4, 3d3            |
| Mn      | Mn²⁺, Mn³⁺, Mn⁴⁺| 3d5, 3d4, 3d3       |
| Fe      | Fe²⁺, Fe³⁺      | 3d6, 3d5            |
| Co      | Co²⁺, Co³⁺      | 3d7, 3d6            |
| Ni      | Ni²⁺, Ni³⁺      | 3d8, 3d7            |
| Cu      | Cu²⁺, Cu³⁺      | 3d9, 3d8            |

### Core-Hole Configurations

For X-ray photoelectron spectroscopy, include core holes:
- **L₃ edge**: "2p5,3d^n" (e.g., "2p5,3d5" for Mn²⁺)
- **L₂ edge**: "2p5,3d^n" with appropriate spin-orbit coupling
- **K edge**: "1s1,3d^n" (e.g., "1s1,3d5" for Mn²⁺)

## Parameter Mapping

The integration automatically maps calculated parameters to GUI fields:

### Coulomb Integrals
- **F₂(3d,3d)** → Ground/Final/Intermediate State F_k(3d,3d) [3rd value]
- **F₄(3d,3d)** → Ground/Final/Intermediate State F_k(3d,3d) [5th value]
- **F₂(2p,3d)** → Ground/Final/Intermediate State F_k(2p,3d) [3rd value]

### Exchange Integrals
- **G₁(2p,3d)** → Ground/Final/Intermediate State G_k(2p,3d) [2nd value]
- **G₃(2p,3d)** → Ground/Final/Intermediate State G_k(2p,3d) [4th value]

### Spin-Orbit Coupling
- **ζ(3d)** → SOC parameters [2nd value]

## Example Workflows

### 1. Fe L₃ Edge XPS

```
Element: Fe
Configuration: 2p5,3d5
```

This calculates parameters for Fe³⁺ with a 2p₃/₂ core hole.

### 2. Ni K Edge XAS

```
Element: Ni
Configuration: 1s1,3d8
```

This calculates parameters for Ni²⁺ with a 1s core hole.

### 3. Mn L₂,₃ Edge RIXS

```
Element: Mn
Configuration: 2p5,3d5
```

This calculates parameters for Mn²⁺ with a 2p core hole.

## Troubleshooting

### Common Issues

#### 1. "atomic-parameters directory not found"
- **Solution**: Use the Browse button to select the correct directory
- **Check**: Directory contains `parameters.py` file

#### 2. "Calculation failed"
- **Solution**: Check element symbol is valid (e.g., "Fe" not "Iron")
- **Check**: Configuration format is correct (e.g., "3d5" not "d5")

#### 3. "No parameters populated"
- **Solution**: Check if parameter names match expected formats
- **Workaround**: Manually copy values from calculation results

#### 4. "Dependencies not installed"
- **Solution**: Run `pip install -r requirements.txt` in atomic-parameters directory

### Validation

Compare calculated parameters with literature values:

#### Fe³⁺ (3d⁵) Literature Values
- F₂(3d,3d): ~13.7 eV
- F₄(3d,3d): ~8.6 eV
- ζ(3d): ~0.08 eV

Your calculated values should be close to these.

## Advanced Usage

### Custom Parameter Scaling

After automatic population, you can manually adjust parameters:
- **Crystal field effects**: May require scaling F₂,F₄ by 80-90%
- **Charge transfer**: May affect all parameters
- **Covalency**: Typically reduces Coulomb integrals

### Multiple Configurations

For multi-configurational systems:
1. Calculate parameters for each configuration separately
2. Use weighted averages based on configuration weights
3. Consider configuration interaction effects

## Benefits of Integration

1. **Accuracy**: Uses rigorous atomic structure calculations
2. **Speed**: Eliminates manual parameter lookup
3. **Consistency**: Ensures parameter sets are internally consistent
4. **Reproducibility**: Calculations can be exactly reproduced
5. **Documentation**: Full calculation details are logged

## References

1. Cowan, R.D. "The Theory of Atomic Structure and Spectra" (1981)
2. Retegan, M. "atomic-parameters" GitHub repository
3. de Groot, F. and Kotani, A. "Core Level Spectroscopy of Solids" (2008)

## Support

If you encounter issues:
1. Check this guide first
2. Verify atomic-parameters installation
3. Review calculation results for clues
4. Open an issue on the ORBITRON-ME GitHub repository

The integration should work seamlessly for most common transition metal systems. For exotic elements or unusual configurations, manual parameter entry may still be needed. 