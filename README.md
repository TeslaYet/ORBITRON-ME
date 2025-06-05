# Orbitron-Multiplet-Edac

A comprehensive suite for electron diffraction angular correlation (EDAC) calculations and multiplet theory simulations with graphical user interfaces.

## 🚀 Quick Start

### For Linux Users (Recommended)

**Complete Linux setup guide:** [LINUX_COMPLETE_SETUP_GUIDE.md](LINUX_COMPLETE_SETUP_GUIDE.md)

This includes solutions for all known Linux issues:
- GLIBC compatibility problems
- Segmentation fault fixes
- Complete compilation instructions
- Virtual environment setup
- Troubleshooting guide

**Quick test:** Run `./test_linux_installation.sh` to verify your setup.

### For macOS Users

Follow the instructions in [compile_macos.sh](compile_macos.sh) for macOS compilation.

## 📖 Documentation

- **[LINUX_COMPLETE_SETUP_GUIDE.md](LINUX_COMPLETE_SETUP_GUIDE.md)** - Comprehensive Linux setup (recommended)
- **[LINUX_BRANCH_README.md](LINUX_BRANCH_README.md)** - Linux compatibility overview
- **[linux_compile_instructions.txt](linux_compile_instructions.txt)** - Basic Linux compilation
- **[compile_linux.sh](compile_linux.sh)** - Linux compilation script
- **[compile_macos.sh](compile_macos.sh)** - macOS compilation script

## 🔧 Features

- **Multiplet Theory Calculations**: Full multiplet calculations with crystal field effects
- **EDAC Simulations**: Electron diffraction angular correlation analysis
- **Cluster Structure Generator**: Create crystal clusters for calculations
- **Visualization Tools**: Generate publication-quality diffraction patterns
- **Graphical User Interface**: Easy-to-use PyQt6-based GUIs
- **Cross-Platform**: Full Linux support with macOS compatibility

## 🖥️ System Requirements

### Linux (Primary Platform)
- Ubuntu 20.04+ or equivalent Linux distribution
- GCC/G++ compiler suite
- Python 3.8+
- 2GB+ free disk space

### macOS (Secondary Platform)
- macOS 10.14+ (Mojave or later)
- Xcode command line tools
- Python 3.8+

## 🛠️ Installation

### Linux Installation (Recommended)

1. **Install dependencies:**
```bash
sudo apt install build-essential python3 python3-pip python3-venv liblapack-dev libblas-dev gdb
```

2. **Clone and setup:**
```bash
git clone https://github.com/TeslaYet/ORBITRON-ME.git
cd ORBITRON-ME
python3 -m venv venv
source venv/bin/activate
pip install PyQt6 numpy scipy matplotlib
```

3. **Compile components:**
```bash
# Compile Multiplet
cd Multiplet2/RPES/src && ./compile && cp multiplet ../ && cd ../../..

# Compile cluster creator
gcc -o cluster2edac cluster2edac.c -lm

# Compile EDAC (with safe flags to avoid GLIBC issues)
cd "Edac 2"
g++ -g -O0 -fstack-protector-all -Wall -Wextra edac.cpp -o edac.exe
gcc -o rpededac rpededac.c
gcc -o intens_stereo_hot intens_stereo_hot.c -lm
gcc -o intens_stereo_rb intens_stereo_rb.c -lm
chmod +x edac.exe rpededac intens_stereo_hot intens_stereo_rb
```

4. **Test installation:**
```bash
./test_linux_installation.sh
```

5. **Run applications:**
```bash
source venv/bin/activate
cd Multiplet2/RPES && python3 multiplet_gui.py  # Multiplet GUI
cd "../../Edac 2" && python3 edac_gui.py        # EDAC GUI
```

For detailed instructions and troubleshooting, see [LINUX_COMPLETE_SETUP_GUIDE.md](LINUX_COMPLETE_SETUP_GUIDE.md).

## 📱 Applications

### Multiplet GUI (`Multiplet2/RPES/multiplet_gui.py`)
- Create multiplet calculation input files
- Run multiplet calculations
- Convert output for EDAC analysis
- Integrated cluster creator
- Visualization tools

### EDAC GUI (`Edac 2/edac_gui.py`)
- Configure EDAC calculations
- Run electron diffraction simulations
- Generate diffraction pattern visualizations
- Support for multiple emitter configurations

## 🔧 Key Components

### Computational Engines
- **multiplet**: Core multiplet calculation engine
- **edac.exe**: Main EDAC calculation program
- **rpededac**: RPES-EDAC interface program
- **cluster2edac**: Crystal cluster structure generator

### Visualization Tools
- **intens_stereo_hot**: Hot colormap diffraction patterns
- **intens_stereo_rb**: Red-blue colormap diffraction patterns

### Data Conversion
- **convert_rpesalms.py**: Convert multiplet output to EDAC format

## 🐛 Known Issues and Solutions

### Linux-Specific Issues (All Fixed)
- ✅ **GLIBC Compatibility**: Fixed with safer compiler flags
- ✅ **Segmentation Faults**: Fixed invalid emitter indices in input files
- ✅ **Exec Format Error**: Resolved by compiling all binaries on Linux
- ✅ **PyQt6 Issues**: Virtual environment setup resolves import problems
- ✅ **File Permissions**: Proper chmod +x for all executables

### Troubleshooting
For detailed troubleshooting instructions, see [LINUX_COMPLETE_SETUP_GUIDE.md](LINUX_COMPLETE_SETUP_GUIDE.md).

## 📄 File Structure

```
ORBITRON-ME/
├── Multiplet2/RPES/          # Multiplet calculation suite
│   ├── multiplet_gui.py      # Main Multiplet GUI
│   ├── src/                  # Source code for multiplet
│   └── convert_rpesalms.py   # Output conversion tool
├── Edac 2/                   # EDAC calculation suite
│   ├── edac_gui.py          # Main EDAC GUI
│   ├── edac.cpp             # EDAC calculation engine
│   ├── rpededac.c           # RPES-EDAC interface
│   └── intens_stereo_*.c    # Visualization tools
├── cluster2edac.c           # Cluster generator
├── icon.png                 # Custom GUI icon
├── venv/                    # Python virtual environment
├── LINUX_COMPLETE_SETUP_GUIDE.md    # Comprehensive Linux guide
├── test_linux_installation.sh       # Installation test script
└── README.md               # This file
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Citation

If you use this software in your research, please cite:

```bibtex
@software{orbitron_multiplet_edac,
  title={ORBITRON-ME: Orbitron-Multiplet-Edac Suite},
  author={TeslaYet},
  note={GUI interface and Linux compatibility implementation},
  year={2024},
  url={https://github.com/TeslaYet/ORBITRON-ME}
}
```

## 🏆 Credits

This software integrates several computational engines with modern GUI interfaces:

- **EDAC Engine**: Originally developed by **F. Javier Garcia de Abajo** (Copyright 1997-2000)
- **Multiplet Theory Code**: Originally developed by **Professor Peter Kruger**, University of Chiba
- **GUI Interface & Linux Compatibility**: Developed by **TeslaYet**
- **Cross-platform Integration**: Community contributions

### Original Publications
Please also cite the original theoretical work when using the computational engines:
- For EDAC calculations: Cite the relevant papers by F. Javier Garcia de Abajo
- For Multiplet theory: Cite the relevant papers by Professor Peter Kruger

## 📜 License

This project is licensed under the [LICENSE](LICENSE) file in the repository.

## 🆘 Support

- **Linux Issues**: See [LINUX_COMPLETE_SETUP_GUIDE.md](LINUX_COMPLETE_SETUP_GUIDE.md)
- **Bug Reports**: Open an issue on GitHub
- **Feature Requests**: Open an issue with the "enhancement" label

## 🏗️ Development Status

- ✅ **Linux Support**: Fully implemented and tested
- ✅ **GUI Applications**: Complete with custom icons
- ✅ **Documentation**: Comprehensive setup guides
- ✅ **Testing**: Automated installation verification
- 🔄 **macOS Support**: Maintained (original platform)
- 🔄 **Windows Support**: Community contributions welcome
