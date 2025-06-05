#!/bin/bash

# test_linux_installation.sh
# Test script for Orbitron-Multiplet-Edac Linux installation
# This script verifies that all components are properly compiled and configured

echo "=============================================="
echo "  Orbitron-Multiplet-Edac Installation Test"
echo "=============================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print test results
print_result() {
    local test_name="$1"
    local success="$2"
    local message="$3"
    
    if [ "$success" = "true" ]; then
        echo -e "${GREEN}✓${NC} $test_name"
        [ -n "$message" ] && echo "  $message"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${NC} $test_name"
        [ -n "$message" ] && echo "  ${RED}Error:${NC} $message"
        ((TESTS_FAILED++))
    fi
}

echo -e "${BLUE}1. Checking System Information${NC}"
echo "================================"

# System info
echo "Linux Distribution:"
if command -v lsb_release >/dev/null 2>&1; then
    lsb_release -d | sed 's/Description:/  /'
else
    grep PRETTY_NAME /etc/os-release | cut -d'"' -f2 | sed 's/^/  /'
fi

echo "Kernel:"
echo "  $(uname -r)"

echo "Architecture:"
echo "  $(uname -m)"

echo ""

echo -e "${BLUE}2. Checking Dependencies${NC}"
echo "============================"

# Check GCC
if command -v gcc >/dev/null 2>&1; then
    gcc_version=$(gcc --version | head -n1)
    print_result "GCC Compiler" "true" "$gcc_version"
else
    print_result "GCC Compiler" "false" "gcc not found - install with: sudo apt install gcc"
fi

# Check G++
if command -v g++ >/dev/null 2>&1; then
    gpp_version=$(g++ --version | head -n1)
    print_result "G++ Compiler" "true" "$gpp_version"
else
    print_result "G++ Compiler" "false" "g++ not found - install with: sudo apt install g++"
fi

# Check gfortran
if command -v gfortran >/dev/null 2>&1; then
    gfortran_version=$(gfortran --version | head -n1)
    print_result "Gfortran Compiler" "true" "$gfortran_version"
else
    print_result "Gfortran Compiler" "false" "gfortran not found - install with: sudo apt install gfortran"
fi

# Check Python3
if command -v python3 >/dev/null 2>&1; then
    python_version=$(python3 --version)
    print_result "Python 3" "true" "$python_version"
else
    print_result "Python 3" "false" "python3 not found - install with: sudo apt install python3"
fi

# Check pip
if command -v pip >/dev/null 2>&1 || command -v pip3 >/dev/null 2>&1; then
    if command -v pip >/dev/null 2>&1; then
        pip_version=$(pip --version | head -n1)
    else
        pip_version=$(pip3 --version | head -n1)
    fi
    print_result "Python Pip" "true" "$pip_version"
else
    print_result "Python Pip" "false" "pip not found - install with: sudo apt install python3-pip"
fi

echo ""

echo -e "${BLUE}3. Checking Virtual Environment${NC}"
echo "==================================="

# Check if virtual environment directory exists
if [ -d "venv" ]; then
    print_result "Virtual Environment Directory" "true" "venv/ directory found"
    
    # Check if we can activate it
    if [ -f "venv/bin/activate" ]; then
        print_result "Virtual Environment Activation Script" "true" "venv/bin/activate exists"
        
        # Test PyQt6 installation in venv
        if source venv/bin/activate 2>/dev/null && python3 -c "import PyQt6.QtWidgets" 2>/dev/null; then
            print_result "PyQt6 in Virtual Environment" "true" "PyQt6 successfully imported"
        else
            print_result "PyQt6 in Virtual Environment" "false" "PyQt6 not installed or not working - run: pip install PyQt6"
        fi
    else
        print_result "Virtual Environment Activation Script" "false" "venv/bin/activate not found"
    fi
else
    print_result "Virtual Environment Directory" "false" "venv/ not found - create with: python3 -m venv venv"
fi

echo ""

echo -e "${BLUE}4. Checking Compiled Executables${NC}"
echo "=================================="

# Check Multiplet executable
multiplet_path="Multiplet2/RPES/multiplet"
if [ -x "$multiplet_path" ]; then
    print_result "Multiplet Executable" "true" "$multiplet_path exists and is executable"
else
    if [ -f "$multiplet_path" ]; then
        print_result "Multiplet Executable" "false" "$multiplet_path exists but not executable - run: chmod +x $multiplet_path"
    else
        print_result "Multiplet Executable" "false" "$multiplet_path not found - compile in Multiplet2/RPES/src/"
    fi
fi

# Check cluster2edac
if [ -x "cluster2edac" ]; then
    print_result "cluster2edac Executable" "true" "cluster2edac exists and is executable"
else
    if [ -f "cluster2edac" ]; then
        print_result "cluster2edac Executable" "false" "cluster2edac exists but not executable - run: chmod +x cluster2edac"
    else
        print_result "cluster2edac Executable" "false" "cluster2edac not found - compile with: gcc -o cluster2edac cluster2edac.c -lm"
    fi
fi

# Check EDAC executables
edac_dir="Edac 2"
if [ -d "$edac_dir" ]; then
    # Check main EDAC executable
    if [ -x "$edac_dir/edac.exe" ]; then
        print_result "EDAC Main Executable" "true" "$edac_dir/edac.exe exists and is executable"
    else
        if [ -f "$edac_dir/edac.exe" ]; then
            print_result "EDAC Main Executable" "false" "$edac_dir/edac.exe exists but not executable"
        else
            print_result "EDAC Main Executable" "false" "$edac_dir/edac.exe not found - compile in Edac 2/ directory"
        fi
    fi
    
    # Check rpededac
    if [ -x "$edac_dir/rpededac" ]; then
        print_result "rpededac Executable" "true" "$edac_dir/rpededac exists and is executable"
    else
        if [ -f "$edac_dir/rpededac" ]; then
            print_result "rpededac Executable" "false" "$edac_dir/rpededac exists but not executable"
        else
            print_result "rpededac Executable" "false" "$edac_dir/rpededac not found - compile with: gcc -o rpededac rpededac.c"
        fi
    fi
    
    # Check visualization tools
    for tool in "intens_stereo_hot" "intens_stereo_rb"; do
        if [ -x "$edac_dir/$tool" ]; then
            print_result "$tool" "true" "$edac_dir/$tool exists and is executable"
        else
            if [ -f "$edac_dir/$tool" ]; then
                print_result "$tool" "false" "$edac_dir/$tool exists but not executable"
            else
                print_result "$tool" "false" "$edac_dir/$tool not found - compile with: gcc -o $tool $tool.c -lm"
            fi
        fi
    done
else
    print_result "EDAC Directory" "false" "Edac 2/ directory not found"
fi

echo ""

echo -e "${BLUE}5. Checking Configuration Files${NC}"
echo "==============================="

# Check icon file
if [ -f "icon.png" ]; then
    print_result "Custom Icon File" "true" "icon.png found in root directory"
else
    print_result "Custom Icon File" "false" "icon.png not found - GUI will use default Python icon"
fi

# Check EDAC input file
if [ -f "$edac_dir/edac.in" ]; then
    # Check if emitter indices are valid (quick sanity check)
    if grep -q "emitters.*[0-9][0-9][0-9]" "$edac_dir/edac.in"; then
        print_result "EDAC Input File" "false" "edac.in may contain invalid emitter indices (>100) - check for segfault issues"
    else
        print_result "EDAC Input File" "true" "edac.in exists and appears to have reasonable emitter indices"
    fi
else
    print_result "EDAC Input File" "false" "edac.in not found in Edac 2/ directory"
fi

# Check cluster file
if [ -f "$edac_dir/ni111.clus" ]; then
    atom_count=$(grep -E "^[[:space:]]*[0-9]" "$edac_dir/ni111.clus" | wc -l)
    print_result "Cluster File" "true" "ni111.clus found with $atom_count atoms"
else
    print_result "Cluster File" "false" "ni111.clus not found in Edac 2/ directory"
fi

echo ""

echo -e "${BLUE}6. Running Functionality Tests${NC}"
echo "==============================="

# Test EDAC calculation (if possible)
if [ -x "$edac_dir/edac.exe" ] && [ -f "$edac_dir/edac.in" ]; then
    echo "Testing EDAC calculation..."
    cd "$edac_dir"
    if timeout 30 ./edac.exe < edac.in > test_output.tmp 2>&1; then
        if grep -q "That's all, folks!" test_output.tmp; then
            print_result "EDAC Calculation Test" "true" "EDAC completed successfully"
        else
            print_result "EDAC Calculation Test" "false" "EDAC ran but may not have completed properly"
        fi
    else
        if grep -q "Segmentation fault" test_output.tmp; then
            print_result "EDAC Calculation Test" "false" "EDAC segmentation fault - check emitter indices in edac.in"
        else
            print_result "EDAC Calculation Test" "false" "EDAC failed or timed out"
        fi
    fi
    rm -f test_output.tmp
    cd ..
else
    print_result "EDAC Calculation Test" "false" "Cannot test - EDAC executable or input file missing"
fi

# Test GUI import (if possible)
if [ -d "venv" ] && [ -f "venv/bin/activate" ]; then
    echo "Testing GUI imports..."
    if source venv/bin/activate 2>/dev/null && python3 -c "
import sys
sys.path.append('Multiplet2/RPES')
sys.path.append('Edac 2')
try:
    from PyQt6.QtWidgets import QApplication
    from PyQt6.QtGui import QIcon
    print('GUI imports successful')
except ImportError as e:
    print(f'GUI import failed: {e}')
    sys.exit(1)
" 2>/dev/null; then
        print_result "GUI Import Test" "true" "All GUI modules imported successfully"
    else
        print_result "GUI Import Test" "false" "GUI imports failed - check PyQt6 installation"
    fi
fi

echo ""
echo "=============================================="
echo -e "${BLUE}Test Summary${NC}"
echo "=============================================="
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 All tests passed! Your installation appears to be working correctly.${NC}"
    echo ""
    echo "You can now run the applications:"
    echo "  1. Activate virtual environment: source venv/bin/activate"
    echo "  2. Run Multiplet GUI: cd Multiplet2/RPES && python3 multiplet_gui.py"
    echo "  3. Run EDAC GUI: cd 'Edac 2' && python3 edac_gui.py"
else
    echo ""
    echo -e "${YELLOW}⚠️  Some tests failed. Please fix the issues above before using the software.${NC}"
    echo ""
    echo "Common solutions:"
    echo "  - Install missing dependencies with your package manager"
    echo "  - Recompile executables following the compilation guide"
    echo "  - Check file permissions with chmod +x"
    echo "  - Set up virtual environment and install PyQt6"
    echo ""
    echo "For detailed instructions, see: LINUX_COMPLETE_SETUP_GUIDE.md"
fi

echo ""
echo "=============================================="

exit $TESTS_FAILED 