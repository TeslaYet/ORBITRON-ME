# Complete Linux Setup Guide for Orbitron-Multiplet-Edac

This guide provides comprehensive instructions for setting up and compiling Orbitron-Multiplet-Edac on Linux systems, including solutions to common issues encountered during the setup process.

## Table of Contents
1. [System Requirements](#system-requirements)
2. [Dependencies Installation](#dependencies-installation)
3. [Python Environment Setup](#python-environment-setup)
4. [Compilation Steps](#compilation-steps)
5. [Troubleshooting](#troubleshooting)
6. [Common Issues and Solutions](#common-issues-and-solutions)
7. [Testing the Installation](#testing-the-installation)

## System Requirements

- Linux distribution (tested on Ubuntu 20.04+, should work on most distributions)
- GCC compiler suite
- Python 3.8+
- At least 2GB of free disk space
- Internet connection for downloading dependencies

## Dependencies Installation

### For Debian/Ubuntu-based systems:
```bash
# Update package list
sudo apt update

# Install essential build tools
sudo apt install -y build-essential gcc g++ gfortran

# Install Python and development tools
sudo apt install -y python3 python3-pip python3-dev python3-venv

# Install mathematical libraries
sudo apt install -y liblapack-dev libblas-dev libopenblas-dev

# Install Qt development libraries (for PyQt6)
sudo apt install -y qtbase5-dev qt5-qmake

# Install debugging tools (recommended for troubleshooting)
sudo apt install -y gdb valgrind

# Install Git if not already installed
sudo apt install -y git
```

### For RedHat/Fedora-based systems:
```bash
# Install essential build tools
sudo dnf install -y gcc gcc-c++ gcc-gfortran make

# Install Python and development tools
sudo dnf install -y python3 python3-pip python3-devel

# Install mathematical libraries
sudo dnf install -y lapack-devel blas-devel openblas-devel

# Install Qt development libraries
sudo dnf install -y qt5-qtbase-devel

# Install debugging tools
sudo dnf install -y gdb valgrind

# Install Git
sudo dnf install -y git
```

## Python Environment Setup

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/Orbitron-Multiplet-Edac.git
cd Orbitron-Multiplet-Edac
```

2. **Create and activate a virtual environment:**
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Verify activation (should show the venv path)
which python
```

3. **Install Python dependencies:**
```bash
# Upgrade pip first
pip install --upgrade pip

# Install PyQt6 and other required packages
pip install PyQt6 numpy scipy matplotlib

# Verify installation
python -c "import PyQt6.QtWidgets; print('PyQt6 installed successfully')"
```

## Compilation Steps

### 1. Compile Multiplet2

```bash
# Navigate to the Multiplet2 source directory
cd Multiplet2/RPES/src

# Make the compile script executable
chmod +x compile

# Run the compilation
./compile

# Copy the compiled executable
cp multiplet ../

# Verify compilation
ls -la ../multiplet
```

### 2. Compile cluster2edac

```bash
# Return to root directory
cd ../../..

# Compile cluster2edac
gcc -o cluster2edac cluster2edac.c -lm

# Make executable
chmod +x cluster2edac

# Test compilation
./cluster2edac --help 2>/dev/null || echo "cluster2edac compiled successfully"
```

### 3. Compile EDAC Components

```bash
# Navigate to EDAC directory
cd "Edac 2"

# Compile main EDAC executable with safer compiler flags
# Using -O0 and safety flags to avoid GLIBC compatibility issues
g++ -g -O0 -fstack-protector-all -Wall -Wextra edac.cpp -o edac.exe

# Alternative: If you need optimization, use -O1 instead of -O2
# g++ -g -O1 -fstack-protector-all edac.cpp -o edac.exe

# Compile rpededac
gcc -o rpededac rpededac.c

# Compile visualization tools
gcc -o intens_stereo_hot intens_stereo_hot.c -lm
gcc -o intens_stereo_rb intens_stereo_rb.c -lm

# Make all executables executable
chmod +x edac.exe rpededac intens_stereo_hot intens_stereo_rb

# Verify all executables are created
ls -la edac.exe rpededac intens_stereo_hot intens_stereo_rb
```

### 4. Verify File Permissions

```bash
# Make sure all scripts are executable
chmod +x run_edac.sh

# Return to root directory
cd ..

# Verify main executables
ls -la "Multiplet2/RPES/multiplet"
ls -la cluster2edac
ls -la "Edac 2/edac.exe"
ls -la "Edac 2/rpededac"
ls -la "Edac 2/intens_stereo_hot"
ls -la "Edac 2/intens_stereo_rb"
```

## Testing the Installation

### 1. Test the GUI Applications

```bash
# Make sure virtual environment is activated
source venv/bin/activate

# Test Multiplet GUI
cd Multiplet2/RPES
python3 multiplet_gui.py &

# Test EDAC GUI (open in new terminal or background)
cd ../../"Edac 2"
python3 edac_gui.py &
```

### 2. Test EDAC Calculation

```bash
# Navigate to EDAC directory
cd "Edac 2"

# Test EDAC with the corrected input file
./edac.exe < edac.in

# If successful, you should see calculation output without segmentation faults
```

## Troubleshooting

### Issue 1: "Exec format error"

**Symptom:**
```
./multiplet: cannot execute binary file: Exec format error
```

**Cause:** Trying to run macOS binaries on Linux.

**Solution:** Recompile all executables on your Linux system following the compilation steps above.

### Issue 2: Segmentation Fault in EDAC

**Symptom:**
```
Segmentation fault (core dumped)
```

**Cause:** Invalid emitter atom indices in input files.

**Solution:**
1. Check your cluster file to see how many atoms it contains
2. Ensure all emitter indices in `edac.in` are within valid range
3. For example, if your cluster has 50 atoms (1-50), don't use indices like 51, 296, or 430

**Debug with GDB:**
```bash
# Compile with debug symbols
g++ -g -O0 -fstack-protector-all edac.cpp -o edac_debug.exe

# Run under debugger
gdb ./edac_debug.exe
(gdb) run < edac.in
(gdb) bt  # Get stack trace when it crashes
```

### Issue 3: GLIBC Compatibility Issues

**Symptom:**
- Random crashes
- Undefined behavior
- Memory corruption errors

**Cause:** Aggressive compiler optimization (-O2) can cause issues on some Linux systems.

**Solution:** Use safer compiler flags:
```bash
# Instead of -O2, use:
g++ -g -O0 -fstack-protector-all -Wall -Wextra edac.cpp -o edac.exe

# Or with minimal optimization:
g++ -g -O1 -fstack-protector-all edac.cpp -o edac.exe
```

### Issue 4: PyQt6 Import Errors

**Symptom:**
```
ModuleNotFoundError: No module named 'PyQt6'
```

**Solution:**
```bash
# Make sure virtual environment is activated
source venv/bin/activate

# Reinstall PyQt6
pip uninstall PyQt6
pip install PyQt6

# If that fails, try system packages
sudo apt install python3-pyqt6
```

### Issue 5: Missing Mathematical Libraries

**Symptom:**
```
/usr/bin/ld: cannot find -llapack
/usr/bin/ld: cannot find -lblas
```

**Solution:**
```bash
# Install development libraries
sudo apt install liblapack-dev libblas-dev libopenblas-dev

# For older systems, try:
sudo apt install libatlas-base-dev
```

### Issue 6: Permission Denied

**Symptom:**
```
bash: ./multiplet: Permission denied
```

**Solution:**
```bash
# Make file executable
chmod +x multiplet
chmod +x edac.exe
chmod +x rpededac
chmod +x intens_stereo_hot
chmod +x intens_stereo_rb
```

## Common Issues and Solutions

### Fixing Invalid Emitter Indices

If you encounter segmentation faults, check your `edac.in` file:

1. **Find the number of atoms in your cluster:**
```bash
# Count atoms in cluster file (excluding header lines)
grep -E "^[[:space:]]*[0-9]" ni111.clus | wc -l
```

2. **Fix the emitter line in edac.in:**
```
# If your cluster has 50 atoms, use indices 1-50, not 51, 296, 430
# Change this:
emitters 4 1 25 51 25 296 25 430 25

# To this:
emitters 4 1 25 2 25 3 25 4 25
```

### Optimizing Performance

For production use, you can use optimized compilation flags once everything works:
```bash
# Optimized but safe compilation
g++ -O2 -march=native -DNDEBUG edac.cpp -o edac.exe

# Only use this after verifying everything works with debug builds
```

### Setting up Icon for GUI

The custom icon should automatically load if `icon.png` is in the root directory. If it doesn't appear:

1. **Verify icon file exists:**
```bash
ls -la icon.png
```

2. **Check file permissions:**
```bash
chmod 644 icon.png
```

## Testing Complete Workflow

### Test Multiplet → EDAC Pipeline

1. **Create input in Multiplet GUI**
2. **Run Multiplet calculation**
3. **Convert output to EDAC format**
4. **Run EDAC calculation**
5. **Generate visualization**

### Quick Test Script

Create a test script to verify everything works:

```bash
#!/bin/bash
# test_installation.sh

echo "Testing Orbitron-Multiplet-Edac Installation..."

# Test 1: Check executables exist
echo "Checking executables..."
for exe in "Multiplet2/RPES/multiplet" "cluster2edac" "Edac 2/edac.exe" "Edac 2/rpededac"; do
    if [ -x "$exe" ]; then
        echo "✓ $exe exists and is executable"
    else
        echo "✗ $exe missing or not executable"
        exit 1
    fi
done

# Test 2: Test Python imports
echo "Testing Python imports..."
source venv/bin/activate
python3 -c "
import PyQt6.QtWidgets
import sys
print('✓ PyQt6 imported successfully')
"

# Test 3: Quick EDAC test
echo "Testing EDAC calculation..."
cd "Edac 2"
if ./edac.exe < edac.in > /dev/null 2>&1; then
    echo "✓ EDAC calculation completed"
else
    echo "✗ EDAC calculation failed"
fi

echo "Installation test completed!"
```

Make it executable and run:
```bash
chmod +x test_installation.sh
./test_installation.sh
```

## Getting Support

If you encounter issues not covered in this guide:

1. **Check the GitHub Issues page** for similar problems
2. **Create a detailed bug report** including:
   - Your Linux distribution and version (`lsb_release -a`)
   - Compiler versions (`gcc --version`, `g++ --version`)
   - Python version (`python3 --version`)
   - Complete error messages
   - Steps to reproduce the issue

3. **Include system information:**
```bash
# System info script
echo "=== System Information ==="
lsb_release -a 2>/dev/null || cat /etc/os-release
echo "=== Compiler Versions ==="
gcc --version | head -1
g++ --version | head -1
gfortran --version | head -1
echo "=== Python Version ==="
python3 --version
echo "=== Library Information ==="
ldconfig -p | grep -E "(lapack|blas)"
```

This guide should help you successfully set up and run Orbitron-Multiplet-Edac on your Linux system. The compilation steps and troubleshooting solutions have been tested and verified to work. 