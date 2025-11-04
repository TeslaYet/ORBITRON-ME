# Multiplet GUI Developer & User Guide

**For Physics Students and Researchers**

This comprehensive guide will help you understand, use, and modify the Multiplet GUI for your research needs.

## Table of Contents

1. [Overview](#overview)
2. [Getting Started - Using the GUI](#getting-started---using-the-gui)
3. [Understanding the Physics Parameters](#understanding-the-physics-parameters)
4. [GUI Code Structure](#gui-code-structure)
5. [How to Modify the GUI](#how-to-modify-the-gui)
6. [Adding New Features](#adding-new-features)
7. [Common Workflows](#common-workflows)
8. [Troubleshooting Development](#troubleshooting-development)
9. [Quick Reference](#quick-reference)

## Overview

The Multiplet GUI (`multiplet_gui.py`) is a PyQt6-based interface that provides:
- **Input Creation**: Generate multiplet calculation input files
- **Calculation Execution**: Run multiplet calculations
- **Output Conversion**: Convert results for EDAC analysis
- **EDAC Integration**: Run EDAC calculations with results
- **Visualization**: Generate and view diffraction patterns
- **Cluster Creation**: Create crystal structures for calculations

### Key Files:
- `Multiplet2/RPES/multiplet_gui.py` - Main GUI application
- `Multiplet2/RPES/convert_rpesalms.py` - Output conversion utility
- `Multiplet2/RPES/src/` - Core multiplet calculation engine
- `Edac 2/edac_gui.py` - EDAC interface (separate but integrated)

## Getting Started - Using the GUI

### 1. Launch the Application

```bash
# Activate virtual environment
source venv/bin/activate

# Navigate to GUI directory
cd Multiplet2/RPES

# Launch the GUI
python3 multiplet_gui.py
```

### 2. Understanding the Tab Structure

The GUI is organized into **6 main tabs**:

#### **Tab 1: Create Input**
- Define all physical parameters for your calculation
- Set crystal field effects, magnetic fields, photon energies
- Configure electron configurations and Slater-Condon parameters

#### **Tab 2: Run Multiplet** 
- Execute the multiplet calculation
- Monitor progress and view output
- Select input files and output directories

#### **Tab 3: Convert Output**
- Convert `rpesalms.dat` to `rpesalms.edac` format
- Essential step before EDAC analysis

#### **Tab 4: Run EDAC**
- Configure EDAC calculations
- Set emitter configurations
- Run electron diffraction simulations

#### **Tab 5: Visualization**
- Generate diffraction pattern visualizations
- Choose between hot and red-blue colormaps
- View and analyze results

#### **Tab 6: Cluster Creator**
- Create crystal cluster structures
- Define lattice parameters and orientations
- Generate input files for calculations

### 3. Basic Workflow

```
1. Create Input → 2. Run Multiplet → 3. Convert Output → 4. Run EDAC → 5. Visualization
                                    ↕
                          6. Cluster Creator (as needed)
```

## Understanding the Physics Parameters

### Energy Parameters

#### **E(2p) and E(3d)**
```python
self.e2p_input = QLineEdit("-639")    # 2p binding energy (eV)
self.e3d_input = QLineEdit("-1.e-6")  # 3d binding energy (eV)
```
**Physics**: Define the core and valence energy levels for your system.

#### **Crystal Field Matrix (5×5)**
```python
# Example: Octahedral crystal field
self.cf_matrix[0][0].setText("-0.024")  # t2g orbital splitting
self.cf_matrix[2][2].setText("-0.177")  # eg orbital splitting
```
**Physics**: Describes how the crystal environment splits d-orbital energies.

### Magnetic Field Parameters

```python
self.bfield_strength = QLineEdit("1.e-3")  # Field strength (eV)
self.bfield_theta = QLineEdit("90.")       # Field direction (degrees)
```
**Physics**: External magnetic field effects on electronic states.

### Photon Energy Settings

```python
self.omega_start = QLineEdit("651.8")   # Starting photon energy (eV)
self.omega_stop = QLineEdit("651.8")    # Ending photon energy (eV)
self.gamma = QLineEdit("0.4")           # Core-hole lifetime broadening (eV)
```
**Physics**: Defines the X-ray photon energy range for resonant photoemission.

### Electron Configuration

```python
self.d_electrons = QLineEdit("5")              # Number of d-electrons
self.l_values = QLineEdit("1 2 1 3 5")        # Angular momentum quantum numbers
self.soc_params = QLineEdit("6.846 0.040...")  # Spin-orbit coupling parameters
```
**Physics**: Describes the electronic structure of your system.

### Slater-Condon Parameters

These describe electron-electron interactions:

```python
# Ground state
self.gs_slater_f2p3d = QLineEdit("0 0 5.0568")      # F_k(2p,3d) integrals
self.gs_slater_g2p3d = QLineEdit("0 3.6848 0 2.0936") # G_k(2p,3d) integrals
self.gs_slater_f3d3d = QLineEdit("0 0 9.4752 0 5.9256") # F_k(3d,3d) integrals
```
**Physics**: Quantify Coulomb and exchange interactions between electrons.

## GUI Code Structure

### Main Classes and Methods

#### **MultipletGUI Class Structure**

```python
class MultipletGUI(QMainWindow):
    def __init__(self):
        # Initialize GUI components
        
    def initUI(self):
        # Set up the main window and tabs
        
    def setup_input_tab(self):
        # Create the input parameter interface
        
    def setup_run_tab(self):
        # Create the calculation execution interface
        
    # ... other setup methods for each tab
```

#### **Key Methods for Developers**

```python
def generate_input_content(self):
    """Generate the multiplet input file content"""
    # This is where you modify input file format
    
def run_multiplet(self):
    """Execute the multiplet calculation"""
    # Modify this to change how calculations are run
    
def browse_input_file(self):
    """File dialog for input selection"""
    # Customize file handling here
```

### GUI Layout Structure

```python
# Main layout hierarchy:
QMainWindow
├── QTabWidget (self.tabs)
│   ├── input_tab (QWidget)
│   │   ├── QScrollArea
│   │   │   ├── Energy Parameters (QGroupBox)
│   │   │   ├── Magnetic Field (QGroupBox)
│   │   │   ├── Photon Energy (QGroupBox)
│   │   │   ├── Electron Config (QGroupBox)
│   │   │   ├── Ground State (QGroupBox)
│   │   │   ├── Final State (QGroupBox)
│   │   │   └── Intermediate State (QGroupBox)
│   │   └── Preview Area
│   ├── run_tab
│   ├── convert_tab
│   ├── edac_tab
│   ├── viz_tab
│   └── cluster_tab
```

## How to Modify the GUI

### 1. Adding New Parameters

**Example: Adding a new energy parameter**

```python
# In setup_input_tab() method, add to an existing group:
def setup_input_tab(self):
    # ... existing code ...
    
    # Add new parameter to energy group
    energy_layout.addWidget(QLabel("New Energy (eV):"), 4, 0)
    self.new_energy = QLineEdit("0.0")
    energy_layout.addWidget(self.new_energy, 4, 1)
```

**Update the input generation:**

```python
def generate_input_content(self):
    lines = []
    # ... existing parameters ...
    
    # Add your new parameter to the input file
    lines.append(f"{self.new_energy.text()}")
    
    return "\n".join(lines)
```

### 2. Modifying Existing Parameters

**Example: Changing default values**

```python
# Find the parameter in setup_input_tab():
self.e2p_input = QLineEdit("-639")  # Change this default value

# Or modify the crystal field matrix defaults:
self.cf_matrix[0][0].setText("-0.030")  # New default value
```

### 3. Adding Validation

**Example: Add parameter validation**

```python
def validate_inputs(self):
    """Validate user inputs before running calculation"""
    try:
        e2p = float(self.e2p_input.text())
        if e2p > 0:
            QMessageBox.warning(self, "Warning", "E(2p) should be negative (binding energy)")
            return False
    except ValueError:
        QMessageBox.critical(self, "Error", "E(2p) must be a number")
        return False
    
    return True

def run_multiplet(self):
    # Add validation check
    if not self.validate_inputs():
        return
    
    # ... rest of existing code ...
```

### 4. Customizing the Interface

**Example: Adding tooltips for better user experience**

```python
def setup_input_tab(self):
    # ... existing code ...
    
    # Add helpful tooltips
    self.e2p_input.setToolTip("2p binding energy in eV (should be negative)")
    self.e3d_input.setToolTip("3d binding energy in eV (reference level)")
    
    # Add status tips
    self.e2p_input.setStatusTip("Enter the 2p core level binding energy")
```

## Adding New Features

### 1. Adding a New Tab

```python
def initUI(self):
    # ... existing tabs ...
    
    # Add your new tab
    self.my_new_tab = QWidget()
    self.tabs.addTab(self.my_new_tab, "My Feature")
    
    # Set up the new tab
    self.setup_my_new_tab()

def setup_my_new_tab(self):
    """Set up your custom tab"""
    layout = QVBoxLayout()
    
    # Add your controls
    self.my_button = QPushButton("Do Something")
    self.my_button.clicked.connect(self.my_custom_function)
    layout.addWidget(self.my_button)
    
    self.my_new_tab.setLayout(layout)

def my_custom_function(self):
    """Your custom functionality"""
    QMessageBox.information(self, "Info", "Custom function executed!")
```

### 2. Adding File I/O Features

```python
def export_parameters(self):
    """Export current parameters to a file"""
    file_path, _ = QFileDialog.getSaveFileName(
        self, "Export Parameters", "parameters.json", 
        "JSON Files (*.json)"
    )
    
    if file_path:
        params = {
            'e2p': self.e2p_input.text(),
            'e3d': self.e3d_input.text(),
            # ... add more parameters
        }
        
        import json
        with open(file_path, 'w') as f:
            json.dump(params, f, indent=2)

def import_parameters(self):
    """Import parameters from a file"""
    file_path, _ = QFileDialog.getOpenFileName(
        self, "Import Parameters", "", 
        "JSON Files (*.json)"
    )
    
    if file_path:
        import json
        with open(file_path, 'r') as f:
            params = json.load(f)
        
        # Update GUI with loaded parameters
        self.e2p_input.setText(params.get('e2p', ''))
        self.e3d_input.setText(params.get('e3d', ''))
        # ... update more parameters
```

### 3. Adding Progress Indicators

```python
def run_multiplet(self):
    # ... existing validation code ...
    
    # Add progress dialog
    self.progress = QProgressDialog("Running multiplet calculation...", "Cancel", 0, 0, self)
    self.progress.setWindowModality(Qt.WindowModality.WindowModal)
    self.progress.show()
    
    # ... start calculation ...

def process_finished(self, exit_code, exit_status):
    """Handle calculation completion"""
    if hasattr(self, 'progress'):
        self.progress.close()
    
    # ... existing completion code ...
```

## Cowan Atomic Parameters Integration

### Overview

The Cowan integration allows automatic calculation of Slater-Condon parameters using Robert D. Cowan's atomic structure codes. This eliminates the need for manual parameter lookup and ensures accurate, internally consistent parameter sets.

### Architecture

The integration consists of several key components:

#### 1. UI Components (in `setup_input_tab()`)

```python
# Main Cowan section
self.cowan_element = QLineEdit("Fe")              # Element input
self.cowan_configuration = QLineEdit("1s1,3d5")  # Configuration input  
self.atomic_params_path = QLineEdit()             # Path to atomic-parameters
self.calculate_cowan_btn = QPushButton()          # Calculate button
self.populate_params_btn = QPushButton()          # Populate button
self.cowan_results = QTextEdit()                  # Results display
```

#### 2. Background Calculation Thread

```python
class CowanThread(QThread):
    finished = pyqtSignal(bool, str, dict)
    
    def __init__(self, element, configuration, atomic_params_path):
        # Initialize thread with calculation parameters
        
    def run(self):
        # Execute Cowan calculation in background
        # Parse output and extract parameters
        # Emit results via finished signal
```

#### 3. Core Methods

```python
def calculate_cowan_parameters(self):
    """Main calculation orchestrator"""
    # Validate inputs
    # Create and start CowanThread
    # Handle UI state during calculation

def on_cowan_calculation_finished(self, success, output, parameters):
    """Handle calculation completion"""
    # Process results
    # Update UI with calculated parameters
    # Enable populate button

def populate_slater_condon_parameters(self):
    """Map calculated parameters to GUI fields"""
    # Parse Cowan output parameters
    # Map to specific GUI fields
    # Update Ground/Final/Intermediate state parameters
```

### Parameter Mapping

The integration maps Cowan's calculated parameters to specific GUI fields:

| Cowan Parameter | GUI Field Location | Description |
|----------------|-------------------|-------------|
| `F2(3d,3d)` | `gs_slater_f3d3d[2]` | d-d Coulomb integral |
| `F4(3d,3d)` | `gs_slater_f3d3d[4]` | d-d Coulomb integral |
| `F2(2p,3d)` | `gs_slater_f2p3d[2]` | Core-valence Coulomb |
| `G1(2p,3d)` | `gs_slater_g2p3d[1]` | Core-valence exchange |
| `G3(2p,3d)` | `gs_slater_g2p3d[3]` | Core-valence exchange |
| `ζ(3d)` | `soc_params[1]` | Spin-orbit coupling |

### Adding Support for New Elements

To extend support for new elements or orbitals:

#### 1. Update Validation

```python
def validate_cowan_inputs(self, element, configuration):
    # Add new elements to valid_elements list
    valid_elements = ['H', 'He', ..., 'YourNewElement']
    
    # Add validation for new orbital types
    pattern = r'^(\d+[spdfg]\d+,)*\d+[spdfg]\d+$'  # Added 'g' orbitals
```

#### 2. Extend Parameter Mapping

```python
def populate_slater_condon_parameters(self):
    # Add new parameter mappings
    elif "F2(4f,4f)" in param_name:
        # Handle 4f-4f interactions for lanthanides
        # Map to appropriate GUI fields
```

#### 3. Add New Examples

```python
def show_cowan_examples(self):
    examples_text = """
    📋 LANTHANIDE 4f SYSTEMS:
       • Ce³⁺ L₃: Element=Ce, Config=2p5,4f1
       • Eu³⁺ L₃: Element=Eu, Config=2p5,4f6
    """
```

### Error Handling and Debugging

#### Common Issues and Solutions

1. **Calculation Timeout**
```python
# Add timeout handling in CowanThread
def run(self):
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, 
                              text=True, check=True, timeout=120)  # 2 min timeout
    except subprocess.TimeoutExpired:
        self.finished.emit(False, "Calculation timed out", {})
```

2. **Parameter Parsing Failures**
```python
# Add robust parsing with fallbacks
def parse_cowan_output(self, output):
    parameters = {}
    try:
        # Primary parsing method
        for line in output.split('\n'):
            if 'INFO:' in line and '=' in line:
                # Parse line
    except Exception as e:
        # Fallback parsing or error handling
        logging.error(f"Parsing failed: {e}")
        return {}
```

3. **Path Resolution Issues**
```python
# Improve path detection
def find_atomic_params_path(self):
    search_paths = [
        os.environ.get('ATOMIC_PARAMS_PATH'),  # Environment variable
        os.path.expanduser("~/atomic-parameters"),
        "/opt/atomic-parameters",  # System-wide installation
        # Add more fallback paths
    ]
```

### Performance Optimization

#### 1. Caching Results

```python
# Add result caching to avoid recalculation
def calculate_cowan_parameters(self):
    cache_key = f"{element}_{configuration}"
    if cache_key in self.parameter_cache:
        # Use cached results
        self.use_cached_parameters(cache_key)
        return
    
    # Proceed with calculation
```

#### 2. Background Processing

```python
# Ensure UI remains responsive during calculation
class CowanThread(QThread):
    progress = pyqtSignal(str)  # Progress updates
    
    def run(self):
        self.progress.emit("Starting RCN calculation...")
        # ... RCN step ...
        self.progress.emit("Running RCN2...")
        # ... RCN2 step ...
```

### Integration with Other Features

#### 1. Parameter Export/Import

```python
def export_cowan_parameters(self):
    """Export calculated Cowan parameters"""
    if not self.calculated_parameters:
        return
    
    data = {
        'element': self.cowan_element.text(),
        'configuration': self.cowan_configuration.text(),
        'parameters': self.calculated_parameters,
        'timestamp': datetime.now().isoformat()
    }
    
    # Save to file
```

#### 2. Batch Calculations

```python
def batch_calculate_parameters(self, element_config_pairs):
    """Calculate parameters for multiple systems"""
    results = {}
    for element, config in element_config_pairs:
        # Calculate parameters
        # Store results
    return results
```

### Testing the Integration

#### Unit Tests

```python
def test_cowan_validation(self):
    """Test input validation"""
    gui = MultipletGUI()
    
    # Test valid inputs
    valid, msg = gui.validate_cowan_inputs('Fe', '3d5')
    assert valid == True
    
    # Test invalid inputs
    valid, msg = gui.validate_cowan_inputs('XYZ', 'invalid')
    assert valid == False

def test_parameter_mapping(self):
    """Test parameter mapping to GUI fields"""
    gui = MultipletGUI()
    test_params = {'F2(3d,3d)': 13.7105, 'ζ(3d)': 0.0837}
    
    # Mock calculated parameters
    gui.calculated_parameters = test_params
    gui.populate_slater_condon_parameters()
    
    # Verify mapping
    f3d3d_values = gui.gs_slater_f3d3d.text().split()
    assert float(f3d3d_values[2]) == 13.7105
```

#### Integration Tests

```python
def test_full_workflow(self):
    """Test complete Cowan workflow"""
    # Create GUI
    # Set inputs
    # Run calculation
    # Verify results
    # Test populate function
```

### Contributing to Cowan Integration

When adding new features to the Cowan integration:

1. **Follow the existing architecture** - Use the thread-based calculation pattern
2. **Add comprehensive validation** - Validate all inputs before calculation
3. **Include error handling** - Handle all possible failure modes gracefully
4. **Add examples** - Include relevant examples in the examples system
5. **Update documentation** - Update this guide and user documentation
6. **Add tests** - Include both unit and integration tests

The Cowan integration is designed to be extensible and maintainable. Follow these patterns when adding new functionality to ensure consistency with the existing codebase.

## Common Workflows

### 1. Systematic Parameter Studies

```python
def parameter_sweep(self):
    """Example: Sweep through different crystal field values"""
    original_value = self.cf_matrix[0][0].text()
    
    values = ["-0.020", "-0.024", "-0.028", "-0.032"]
    
    for value in values:
        self.cf_matrix[0][0].setText(value)
        
        # Generate input with new value
        input_content = self.generate_input_content()
        
        # Save to file
        filename = f"input_cf_{value.replace('-', 'neg').replace('.', 'p')}.txt"
        with open(filename, 'w') as f:
            f.write(input_content)
    
    # Restore original value
    self.cf_matrix[0][0].setText(original_value)
```

### 2. Batch Processing

```python
def batch_convert_files(self):
    """Convert multiple rpesalms.dat files at once"""
    from convert_rpesalms import convert_rpesalms
    
    # Select multiple input files
    file_paths, _ = QFileDialog.getOpenFileNames(
        self, "Select rpesalms.dat files", "", 
        "DAT Files (*.dat)"
    )
    
    for input_file in file_paths:
        # Generate output filename
        output_file = input_file.replace('.dat', '.edac')
        
        try:
            convert_rpesalms(input_file, output_file)
            print(f"Converted: {input_file} -> {output_file}")
        except Exception as e:
            print(f"Error converting {input_file}: {e}")
```

### 3. Results Analysis Integration

```python
def analyze_results(self):
    """Integrate with analysis tools"""
    import numpy as np
    import matplotlib.pyplot as plt
    
    # Load EDAC results
    data_file = QFileDialog.getOpenFileName(
        self, "Select results file", "", 
        "EDAC Files (*.edac)"
    )[0]
    
    if data_file:
        # Simple analysis example
        data = np.loadtxt(data_file)
        
        plt.figure(figsize=(10, 6))
        plt.plot(data[:, 0], data[:, 1])
        plt.xlabel('Energy (eV)')
        plt.ylabel('Intensity')
        plt.title('EDAC Results')
        plt.show()
```

## Troubleshooting Development

### Common Issues and Solutions

#### 1. GUI Layout Problems

```python
# Problem: Widgets not showing properly
# Solution: Make sure to call show() or add to layout

def setup_my_tab(self):
    layout = QVBoxLayout()
    
    widget = QLabel("My Label")
    layout.addWidget(widget)  # Don't forget this!
    
    self.my_tab.setLayout(layout)  # And this!
```

#### 2. Signal-Slot Connection Issues

```python
# Problem: Button clicks not working
# Solution: Check signal-slot connections

def setup_buttons(self):
    self.my_button = QPushButton("Click Me")
    
    # Correct connection
    self.my_button.clicked.connect(self.my_function)
    
    # Common mistake - calling the function instead of connecting
    # self.my_button.clicked.connect(self.my_function())  # Wrong!
```

#### 3. File Path Issues

```python
# Problem: Files not found
# Solution: Use absolute paths and check existence

def safe_file_operation(self, filename):
    file_path = os.path.abspath(filename)
    
    if not os.path.exists(file_path):
        QMessageBox.critical(self, "Error", f"File not found: {file_path}")
        return False
    
    return True
```

#### 4. Exception Handling

```python
def robust_calculation(self):
    """Example of proper error handling"""
    try:
        # Your calculation code here
        result = self.perform_calculation()
        
    except FileNotFoundError as e:
        QMessageBox.critical(self, "File Error", f"Required file missing: {e}")
        
    except ValueError as e:
        QMessageBox.warning(self, "Input Error", f"Invalid parameter: {e}")
        
    except Exception as e:
        QMessageBox.critical(self, "Error", f"Unexpected error: {e}")
        
    finally:
        # Cleanup code (e.g., re-enable buttons)
        self.run_button.setEnabled(True)
```

### Debugging Tips

#### 1. Add Debug Output

```python
def debug_parameters(self):
    """Print all current parameters for debugging"""
    print("=== Current Parameters ===")
    print(f"E(2p): {self.e2p_input.text()}")
    print(f"E(3d): {self.e3d_input.text()}")
    print(f"B-field: {self.bfield_strength.text()}")
    # ... add more parameters as needed
    print("========================")
```

#### 2. Use Logging

```python
import logging

# Set up logging in __init__
logging.basicConfig(level=logging.DEBUG, 
                   format='%(asctime)s - %(levelname)s - %(message)s')

def my_function(self):
    logging.debug("Entering my_function")
    
    try:
        # Your code here
        logging.info("Function completed successfully")
    except Exception as e:
        logging.error(f"Error in my_function: {e}")
```

#### 3. Interactive Development

```python
# Add this for interactive debugging
def open_python_console(self):
    """Open IPython console for interactive debugging"""
    try:
        from IPython import embed
        embed()  # This will open an interactive console
    except ImportError:
        print("IPython not available. Install with: pip install ipython")
```

## Best Practices for Student Developers

### 1. Code Organization

- **Keep functions small and focused** (one task per function)
- **Use descriptive variable names** (`energy_value` not `e`)
- **Add comments explaining the physics** not just the code
- **Group related functionality** in logical sections

### 2. Testing Your Changes

```python
def test_my_changes(self):
    """Always test your modifications"""
    # Test with known good values
    self.e2p_input.setText("-639")
    self.e3d_input.setText("-1.e-6")
    
    # Generate input and check format
    content = self.generate_input_content()
    lines = content.split('\n')
    
    # Verify expected format
    assert len(lines) >= 10, "Input file too short"
    assert lines[0] == "-639 -1.e-6", "First line format incorrect"
```

### 3. Documentation

- **Comment your physics assumptions**
- **Document parameter units and ranges**
- **Explain non-obvious calculations**
- **Keep this guide updated** with your changes

### 4. Version Control

```bash
# Before making changes, create a branch
git checkout -b my-feature-branch

# Make small, focused commits
git add modified_file.py
git commit -m "Add validation for energy parameters"

# Test thoroughly before merging
./test_linux_installation.sh
```

## Getting Help

### Resources for Students

1. **PyQt6 Documentation**: https://doc.qt.io/qtforpython/
2. **Physics References**: Cite relevant papers by Professor Krüger
3. **Python GUI Programming**: Online tutorials and books
4. **Lab Group**: Collaborate with other students

### Questions to Ask

- "What physics does this parameter represent?"
- "What units should this be in?"
- "What are reasonable values for this system?"
- "How does this affect the calculation?"

### Contributing Back

When you make useful improvements:

1. Document your changes clearly
2. Test with multiple parameter sets
3. Share with other lab members
4. Consider submitting improvements to the main repository

Remember: The goal is to make this tool more useful for physics research while maintaining its reliability and accuracy.

## Quick Reference

### Physics Parameter Cheat Sheet

#### **Common Energy Ranges (eV)**

| Parameter | Typical Range | Example Values |
|-----------|---------------|----------------|
| E(2p) | -700 to -600 | -639 (Mn), -708 (Fe), -779 (Co) |
| E(3d) | -10 to 10 | -1.e-6 (reference), 0.0, -2.5 |
| Photon Energy (ω) | 600-800 | 651.8 (Mn L3), 707.0 (Fe L3) |
| Γ (broadening) | 0.1-1.0 | 0.4 (typical), 0.2 (sharp), 0.8 (broad) |

#### **Crystal Field Matrix Examples**

**Octahedral (Oh):**
```
-0.024   0.000   0.000  -0.056   0.000
 0.000   0.064   0.000   0.000   0.056
 0.000   0.000  -0.177   0.000   0.000
-0.056   0.000   0.000   0.064   0.000
 0.000   0.056   0.000   0.000  -0.024
```

**Tetrahedral (Td):**
```
 0.036   0.000   0.000   0.084   0.000
 0.000  -0.096   0.000   0.000  -0.084
 0.000   0.000   0.265   0.000   0.000
 0.084   0.000   0.000  -0.096   0.000
 0.000  -0.084   0.000   0.000   0.036
```

#### **Electron Configurations**

| System | d-electrons | Configuration | Example |
|--------|-------------|---------------|---------|
| Mn²⁺ | 5 | 3d⁵ | High-spin MnO |
| Fe³⁺ | 5 | 3d⁵ | Fe₂O₃ |
| Co²⁺ | 7 | 3d⁷ | CoO |
| Ni²⁺ | 8 | 3d⁸ | NiO |
| Cu²⁺ | 9 | 3d⁹ | CuO |

#### **Default Slater-Condon Parameters**

For 3d transition metals (in eV):

| Parameter | Typical Values |
|-----------|----------------|
| F₂(3d,3d) | 9.0-12.0 |
| F₄(3d,3d) | 5.5-7.0 |
| F₂(2p,3d) | 4.5-6.0 |
| G₁(2p,3d) | 3.0-4.5 |
| G₃(2p,3d) | 1.8-2.5 |

### GUI Widget Reference

#### **Key Widget Names for Developers**

```python
# Energy parameters
self.e2p_input          # E(2p) binding energy
self.e3d_input          # E(3d) binding energy
self.cf_matrix[i][j]    # Crystal field matrix elements

# Magnetic field
self.bfield_strength    # B-field strength
self.bfield_theta       # B-field angle

# Photon energy
self.omega_start        # Starting photon energy
self.omega_stop         # Ending photon energy
self.gamma              # Core-hole lifetime broadening

# Electron configuration
self.d_electrons        # Number of d-electrons
self.l_values          # Angular momentum quantum numbers
self.soc_params        # Spin-orbit coupling parameters

# Slater-Condon parameters (Ground State)
self.gs_slater_f2p3d   # F_k(2p,3d) integrals
self.gs_slater_g2p3d   # G_k(2p,3d) integrals
self.gs_slater_f3d3d   # F_k(3d,3d) integrals

# Similar for Final State (fs_) and Intermediate State (is_)
```

### Common File Formats

#### **Input File Structure**
```
-639 -1.e-6                    # E(2p) E(3d)
5×5 crystal field matrix      # Crystal field parameters
1.e-3 90.                     # B-field strength, angle
651.8 651.8 2. 0.4 0         # ω_start, ω_stop, Δω, Γ, flag
5                             # d-electrons
1 2 1 3 5                     # l-values
6.846 0.040 0 0 0            # SOC parameters
2.064 0.02161 0.09695        # Dipole matrix elements
1                            # Ground state config count
6 5 0 0 0                    # Ground state occupation
[Slater-Condon parameters]
1                            # Final state config count
6 4 0 0 0                    # Final state occupation
[More Slater-Condon parameters]
[Intermediate state parameters]
```

#### **Output Files**
- `rpesalms.dat` - Raw multiplet output
- `rpesalms.edac` - Converted for EDAC analysis
- `*.ms` - EDAC diffraction patterns
- `*.png` - Visualization images

### Troubleshooting Quick Fixes

#### **Common Error Messages**

| Error | Cause | Solution |
|-------|-------|----------|
| "multiplet: command not found" | Binary not compiled | Run `setup_linux_binaries()` |
| "Segmentation fault" | Invalid parameters | Check emitter indices in EDAC |
| "File not found" | Missing input files | Verify file paths |
| "Permission denied" | Binary not executable | `chmod +x binary_name` |

#### **Parameter Validation Checklist**

- [ ] E(2p) is negative (binding energy)
- [ ] E(3d) is small (reference level)
- [ ] d-electron count matches your system
- [ ] Crystal field matrix is appropriate for symmetry
- [ ] Photon energy matches experimental setup
- [ ] Slater-Condon parameters are reasonable

### Development Shortcuts

#### **Quickly Test Parameter Changes**

```python
# Add this method to MultipletGUI class for quick testing
def load_test_parameters(self):
    """Load a set of known-good parameters for testing"""
    self.e2p_input.setText("-639")
    self.e3d_input.setText("-1.e-6")
    self.d_electrons.setText("5")
    self.omega_start.setText("651.8")
    self.gamma.setText("0.4")
    
    # Set octahedral crystal field
    cf_values = [
        [-0.024, 0., 0., -0.056, 0.],
        [0., 0.064, 0., 0., 0.056],
        [0., 0., -0.177, 0., 0.],
        [-0.056, 0., 0., 0.064, 0.],
        [0., 0.056, 0., 0., -0.024]
    ]
    
    for i in range(5):
        for j in range(5):
            self.cf_matrix[i][j].setText(str(cf_values[i][j]))
```

#### **Debug Helper Functions**

```python
def print_all_parameters(self):
    """Print all current parameters for debugging"""
    params = {
        'E(2p)': self.e2p_input.text(),
        'E(3d)': self.e3d_input.text(),
        'd-electrons': self.d_electrons.text(),
        'omega': self.omega_start.text(),
        'gamma': self.gamma.text()
    }
    
    print("=== Current Parameters ===")
    for key, value in params.items():
        print(f"{key}: {value}")
    print("=========================")

def validate_crystal_field(self):
    """Check if crystal field matrix is reasonable"""
    try:
        total = 0
        for i in range(5):
            for j in range(5):
                val = float(self.cf_matrix[i][j].text())
                total += abs(val)
        
        if total == 0:
            print("Warning: Crystal field matrix is all zeros")
        elif total > 10:
            print("Warning: Crystal field values seem very large")
        else:
            print(f"Crystal field matrix looks reasonable (total |values|: {total:.3f})")
            
    except ValueError:
        print("Error: Non-numeric values in crystal field matrix")
```

### Academic Citation Format

When using this software in publications, please cite:

**BibTeX:**
```bibtex
@software{orbitron_multiplet_edac,
  title={ORBITRON-ME: Multiplet Theory and Electron Diffraction Analysis Code},
  author={Krüger, Peter and Garcia de Abajo, F. Javier and TeslaYet},
  year={2024},
  note={Multiplet theory calculations and GUI interface},
  url={https://github.com/TeslaYet/ORBITRON-ME}
}

@article{krueger_multiplet,
  title={Multiplet effects in X-ray photoelectron spectroscopy},
  author={Krüger, Peter},
  journal={[Journal Name]},
  year={[Year]},
  note={Theoretical foundation for multiplet calculations}
}

@article{garcia_edac,
  title={Electron diffraction from atoms and clusters},
  author={Garcia de Abajo, F. Javier},
  journal={[Journal Name]},
  year={1997-2000},
  note={Original EDAC implementation}
}
```

---



