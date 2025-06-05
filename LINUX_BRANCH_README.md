# Orbitron-Multiplet-Edac: Linux-Compatible Branch

This branch contains modifications specifically for Linux compatibility. The main branch is optimized for macOS, while this branch includes changes to ensure proper operation on Linux systems.

## 🚀 Quick Start

**For complete setup instructions, see [LINUX_COMPLETE_SETUP_GUIDE.md](LINUX_COMPLETE_SETUP_GUIDE.md)**

The comprehensive guide includes solutions to all known Linux compatibility issues, including GLIBC compatibility problems and segmentation fault fixes.

## Linux-Specific Changes

This branch includes the following Linux-specific changes:

1. **Modified Compilation Scripts**: The `compile` script in `Multiplet2/RPES/src/` now detects the OS and uses appropriate compiler flags.

2. **Improved Executable Detection**: The GUI has been updated to search for executables in multiple locations common on Linux systems.

3. **Better Error Handling**: More informative error messages specific to Linux environments.

4. **Platform-Specific Binary Directories**: A `linux-bin` directory has been added to store Linux-specific binaries.

5. **Path Handling**: Fixed path issues that could cause problems on Linux file systems.

6. **Automatic Binary Compilation**: The GUI now automatically detects missing binaries and offers to compile them for you.

7. **Custom Icon Support**: Both GUI applications now display the custom `icon.png` instead of the default Python icon.

## ⚠️ Important: Binary Compatibility Issue ⚠️

The repository may contain pre-compiled binaries for macOS that **will not work on Linux**. If you try to run these directly, you'll get an "Exec format error" like:

```
./multiplet: cannot execute binary file: Exec format error
```

**This is expected and normal.** The solution is to compile all the executables yourself on your Linux system following the steps below. The binaries need to be built specifically for your Linux architecture.

## 🛠️ Critical Fixes Included

### GLIBC Compatibility Issues (NEW)

**Issue:** Aggressive compiler optimization (`-O2`) can cause random crashes and undefined behavior on some Linux systems due to GLIBC compatibility issues.

**Solution:** We now use safer compiler flags:
```bash
# Safe compilation (recommended)
g++ -g -O0 -fstack-protector-all -Wall -Wextra edac.cpp -o edac.exe

# Or with minimal optimization if needed
g++ -g -O1 -fstack-protector-all edac.cpp -o edac.exe
```

### Segmentation Fault Fixes (NEW)

**Issue:** EDAC calculations would crash with "Segmentation fault (core dumped)" due to invalid emitter atom indices in input files.

**Root Cause:** The original `edac.in` files contained emitter indices that exceeded the number of atoms in the cluster files.

**Example Fix:**
```
# Original (BROKEN - causes segfault)
emitters 4 1 25 51 25 296 25 430 25

# Fixed (WORKS - for cluster with 50 atoms)
emitters 4 1 25 2 25 3 25 4 25
```

**Debugging Tools:** The guide includes GDB debugging instructions to identify similar issues.

### Required Compilation Steps

You **must** compile these binaries on your Linux system:

1. `multiplet` - The main calculation engine
2. `cluster2edac` - The crystal structure generator
3. `edac.exe` - The main EDAC calculation engine (note: Linux version requires .exe extension)
4. `rpededac` - For EDAC simulations (NEW: was missing from previous instructions)
5. `intens_stereo_hot` and `intens_stereo_rb` - Visualization tools

The GUI has been updated to provide better error messages if these executables are missing or incompatible.

## Additional Linux Compatibility Issues

During our analysis, we identified these additional Linux-specific issues that have been addressed:

1. **File Path Separators**: Linux uses forward slashes (`/`) while Windows uses backslashes (`\`). The code now uses `os.path.join()` consistently to handle this difference.

2. **EDAC Executable Extensions**: According to `linux_compile_instructions.txt`, the EDAC executables on Linux should have an `.exe` extension, unlike on macOS. The code now searches for both variants.

3. **Shell Commands Differences**: Commands like `cat` (Linux/macOS) vs `type` (Windows) are handled differently based on platform.

4. **QT Plugin Path Issues**: The EDAC GUI previously had macOS-specific Qt plugin path settings that could cause issues on Linux.

5. **Permission Requirements**: Linux requires explicit executable permissions (`chmod +x`) for binary files, which are not always needed on macOS.

6. **BLAS/LAPACK Libraries**: On macOS, the Accelerate framework is used, while on Linux, explicit linking to `-llapack -lblas` is required.

7. **Virtual Environment Setup**: Added comprehensive Python virtual environment setup instructions for Linux.

## How to Use This Branch

### Switching to the Linux Branch

If you've cloned the repository, switch to this branch with:

```bash
git checkout linux-compatible
```

### Quick Setup (For Experienced Users)

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt install -y build-essential python3 python3-pip python3-venv liblapack-dev libblas-dev gdb

# Setup Python environment
python3 -m venv venv
source venv/bin/activate
pip install PyQt6 numpy scipy matplotlib

# Compile all components with safe flags
cd Multiplet2/RPES/src && ./compile && cp multiplet ../ && cd ../../..
gcc -o cluster2edac cluster2edac.c -lm
cd "Edac 2"
g++ -g -O0 -fstack-protector-all -Wall -Wextra edac.cpp -o edac.exe
gcc -o rpededac rpededac.c
gcc -o intens_stereo_hot intens_stereo_hot.c -lm
gcc -o intens_stereo_rb intens_stereo_rb.c -lm
chmod +x edac.exe rpededac intens_stereo_hot intens_stereo_rb run_edac.sh

# Test installation
./edac.exe < edac.in  # Should complete without segfault
```

### Complete Setup Instructions

**For detailed instructions including troubleshooting, see [LINUX_COMPLETE_SETUP_GUIDE.md](LINUX_COMPLETE_SETUP_GUIDE.md)**

The comprehensive guide includes:
- Step-by-step dependency installation for multiple Linux distributions
- Complete compilation instructions with safe compiler flags
- Troubleshooting for all known issues
- Testing procedures
- Debugging instructions with GDB
- Performance optimization tips

### Running the Application

```bash
# Activate virtual environment
source venv/bin/activate

# Run Multiplet GUI
cd Multiplet2/RPES
python3 multiplet_gui.py

# Run EDAC GUI (in another terminal)
cd "../../Edac 2"
python3 edac_gui.py
```

## Testing Your Installation

Run this quick test to verify everything works:

```bash
# Test EDAC calculation (should complete without segfault)
cd "Edac 2"
./edac.exe < edac.in

# Test GUI (should show custom icon)
source venv/bin/activate
cd "../Multiplet2/RPES"
python3 multiplet_gui.py
```

## Contributing Back to Main Branch

If you make improvements to this Linux branch that would be valuable for the main branch, please:

1. Create a new branch from this one
2. Make your changes
3. Submit a pull request to merge into the main branch

## Keeping Up to Date

To get the latest changes from the main branch:

```bash
git checkout linux-compatible
git pull
# OR if you need to update from main
git merge main
```

## Reporting Issues

If you encounter Linux-specific issues, please report them on the GitHub issue tracker and mention that you're using the Linux-compatible branch. 

**Include this information in bug reports:**
- Linux distribution and version (`lsb_release -a`)
- Compiler versions (`gcc --version`, `g++ --version`)
- Python version (`python3 --version`)
- Complete error messages
- Steps to reproduce the issue

## Change Log

### Recent Fixes (Latest)
- ✅ **GLIBC Compatibility**: Fixed random crashes by using safer compiler flags
- ✅ **Segmentation Faults**: Fixed invalid emitter indices in input files
- ✅ **Custom Icon**: Added support for custom GUI icons
- ✅ **Complete Documentation**: Created comprehensive setup guide
- ✅ **Missing rpededac**: Added compilation instructions for rpededac
- ✅ **GDB Debugging**: Added debugging instructions for troubleshooting

### Previous Fixes
- ✅ **Exec Format Error**: Fixed by ensuring all binaries are compiled on Linux
- ✅ **PyQt6 Support**: Updated GUI for PyQt6 compatibility
- ✅ **Path Handling**: Fixed cross-platform path issues
- ✅ **Library Linking**: Fixed BLAS/LAPACK linking on Linux 