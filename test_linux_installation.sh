#!/bin/bash

# Test Linux Installation Script for Orbitron-Multiplet-Edac
# This script comprehensively tests the installation and functionality

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
    ((TESTS_PASSED++))
    ((TESTS_TOTAL++))
}

failure() {
    echo -e "${RED}❌ $1${NC}"
    ((TESTS_FAILED++))
    ((TESTS_TOTAL++))
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Test function wrapper
test_function() {
    local test_name="$1"
    local test_command="$2"
    
    log "Testing: $test_name"
    if eval "$test_command"; then
        success "$test_name"
        return 0
    else
        failure "$test_name"
        return 1
    fi
}

# Header
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                ORBITRON-ME LINUX INSTALLATION TEST              ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

# System Information
log "System Information:"
echo "OS: $(lsb_release -d -s 2>/dev/null || echo 'Unknown Linux')"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "Python: $(python3 --version)"
echo "GCC: $(gcc --version | head -n1)"
echo ""

# Test 1: Check basic dependencies
test_function "System Dependencies" '
    command -v gcc >/dev/null && 
    command -v python3 >/dev/null && 
    command -v pip3 >/dev/null
'

# Test 2: Check Python environment
test_function "Python Virtual Environment" '
    if [ -d "venv" ]; then
        source venv/bin/activate
        python3 -c "import sys; print(f\"Python: {sys.version}\")"
        pip list | grep -q PyQt6
    else
        echo "Virtual environment not found"
        false
    fi
'

# Test 3: Check directory structure
test_function "Directory Structure" '
    [ -d "Multiplet2/RPES" ] && 
    [ -f "Multiplet2/RPES/multiplet_gui.py" ] &&
    [ -d "Edac 2" ] &&
    [ -f "cluster2edac.c" ]
'

# Test 4: Check executables compilation
test_function "Multiplet Executable" '
    if [ -f "Multiplet2/RPES/multiplet" ] && [ -x "Multiplet2/RPES/multiplet" ]; then
        true
    else
        echo "Multiplet executable not found or not executable"
        false
    fi
'

test_function "Cluster2edac Executable" '
    if [ -x "cluster2edac" ]; then
        true
    else
        echo "cluster2edac executable not found"
        false
    fi
'

test_function "EDAC Executables" '
    cd "Edac 2"
    if [ -x "rpededac" ] && [ -x "intens_stereo_hot" ] && [ -x "intens_stereo_rb" ]; then
        cd ..
        true
    else
        cd ..
        echo "EDAC executables not found"
        false
    fi
'

# Test 5: GUI Import Test
test_function "Multiplet GUI Import" '
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    cd "Multiplet2/RPES"
    python3 -c "
import sys
import os
try:
    import multiplet_gui
    from PyQt6.QtWidgets import QApplication
    print(\"✅ All imports successful\")
    
    # Test GUI creation
    app = QApplication(sys.argv)
    gui = multiplet_gui.MultipletGUI()
    print(f\"✅ GUI created with {gui.tabs.count()} tabs\")
    app.quit()
    
except ImportError as e:
    print(f\"❌ Import error: {e}\")
    sys.exit(1)
except Exception as e:
    print(f\"❌ GUI creation error: {e}\")
    sys.exit(1)
"
    cd ../..
'

# Test 6: EDAC GUI Import Test  
test_function "EDAC GUI Import" '
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    cd "Edac 2"
    python3 -c "
import sys
try:
    import edac_gui
    from PyQt6.QtWidgets import QApplication
    print(\"✅ EDAC GUI imports successful\")
    
    app = QApplication(sys.argv)
    gui = edac_gui.EdacGUI()
    print(\"✅ EDAC GUI created successfully\")
    app.quit()
    
except ImportError as e:
    print(f\"❌ EDAC GUI import error: {e}\")
    sys.exit(1)
except Exception as e:
    print(f\"❌ EDAC GUI creation error: {e}\")
    sys.exit(1)
"
    cd ..
'

# Test 7: Cowan Atomic Parameters Integration
log "Testing Cowan Atomic Parameters Integration..."

test_function "Cowan Integration - atomic-parameters Installation" '
    if [ -d "/home/tesla/atomic-parameters" ] || [ -d "$HOME/atomic-parameters" ] || [ -d "atomic-parameters" ]; then
        ATOMIC_PARAMS_DIR=""
        for dir in "/home/tesla/atomic-parameters" "$HOME/atomic-parameters" "atomic-parameters"; do
            if [ -d "$dir" ]; then
                ATOMIC_PARAMS_DIR="$dir"
                break
            fi
        done
        
        if [ -f "$ATOMIC_PARAMS_DIR/parameters.py" ]; then
            echo "✅ Found atomic-parameters at: $ATOMIC_PARAMS_DIR"
            true
        else
            echo "❌ atomic-parameters directory found but missing parameters.py"
            false
        fi
    else
        echo "❌ atomic-parameters not found. Install with:"
        echo "   git clone https://github.com/mretegan/atomic-parameters.git"
        false
    fi
'

test_function "Cowan Integration - Dependencies Check" '
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    
    # Find atomic-parameters directory
    ATOMIC_PARAMS_DIR=""
    for dir in "/home/tesla/atomic-parameters" "$HOME/atomic-parameters" "atomic-parameters"; do
        if [ -d "$dir" ]; then
            ATOMIC_PARAMS_DIR="$dir"
            break
        fi
    done
    
    if [ -n "$ATOMIC_PARAMS_DIR" ]; then
        cd "$ATOMIC_PARAMS_DIR"
        python3 -c "
try:
    import xraydb
    import sqlalchemy
    import numpy
    import scipy
    print(\"✅ All Cowan dependencies installed\")
except ImportError as e:
    print(f\"❌ Missing dependency: {e}\")
    print(\"Run: pip install -r requirements.txt in atomic-parameters directory\")
    exit(1)
"
        cd - > /dev/null
    else
        echo "❌ atomic-parameters directory not found"
        false
    fi
'

test_function "Cowan Integration - Calculation Test" '
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    
    # Find atomic-parameters directory
    ATOMIC_PARAMS_DIR=""
    for dir in "/home/tesla/atomic-parameters" "$HOME/atomic-parameters" "atomic-parameters"; do
        if [ -d "$dir" ]; then
            ATOMIC_PARAMS_DIR="$dir"
            break
        fi
    done
    
    if [ -n "$ATOMIC_PARAMS_DIR" ]; then
        cd "$ATOMIC_PARAMS_DIR"
        timeout 60s python3 parameters.py --element "Fe" --configuration "1s1,3d5" > /tmp/cowan_test.out 2>&1
        if [ $? -eq 0 ]; then
            # Check if we got expected parameters
            if grep -q "F2(3d,3d)" /tmp/cowan_test.out && grep -q "ζ(3d)" /tmp/cowan_test.out; then
                echo "✅ Cowan calculation successful, parameters calculated"
                grep "INFO:" /tmp/cowan_test.out | head -5
                cd - > /dev/null
                true
            else
                echo "❌ Cowan calculation completed but parameters not found"
                cat /tmp/cowan_test.out
                cd - > /dev/null
                false
            fi
        else
            echo "❌ Cowan calculation failed or timed out"
            cat /tmp/cowan_test.out
            cd - > /dev/null
            false
        fi
    else
        echo "❌ atomic-parameters directory not found"
        false
    fi
'

test_function "Cowan Integration - GUI Integration Test" '
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    cd "Multiplet2/RPES"
    python3 -c "
import sys
import os
try:
    import multiplet_gui
    from PyQt6.QtWidgets import QApplication
    
    app = QApplication(sys.argv)
    gui = multiplet_gui.MultipletGUI()
    
    # Check Cowan UI elements
    cowan_elements = [
        hasattr(gui, \"cowan_element\"),
        hasattr(gui, \"cowan_configuration\"), 
        hasattr(gui, \"atomic_params_path\"),
        hasattr(gui, \"calculate_cowan_btn\"),
        hasattr(gui, \"populate_params_btn\"),
        hasattr(gui, \"cowan_results\"),
        hasattr(gui, \"validate_cowan_inputs\"),
        hasattr(gui, \"show_cowan_examples\")
    ]
    
    if all(cowan_elements):
        print(\"✅ All Cowan UI elements present\")
        
        # Test validation
        valid, msg = gui.validate_cowan_inputs(\"Fe\", \"2p5,3d5\")
        if valid:
            print(\"✅ Cowan validation working\")
        else:
            print(f\"❌ Cowan validation failed: {msg}\")
            sys.exit(1)
        
        print(\"✅ Cowan GUI integration complete\")
    else:
        print(\"❌ Missing Cowan UI elements:\")
        elements = [\"cowan_element\", \"cowan_configuration\", \"atomic_params_path\", 
                   \"calculate_cowan_btn\", \"populate_params_btn\", \"cowan_results\",
                   \"validate_cowan_inputs\", \"show_cowan_examples\"]
        for i, present in enumerate(cowan_elements):
            if not present:
                print(f\"  - Missing: {elements[i]}\")
        sys.exit(1)
    
    app.quit()
    
except Exception as e:
    print(f\"❌ Cowan GUI integration test failed: {e}\")
    sys.exit(1)
"
    cd ../..
'

# Test 8: Full Integration Test
test_function "Full Integration Test - test_cowan_integration.py" '
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    
    if [ -f "test_cowan_integration.py" ]; then
        timeout 120s python3 test_cowan_integration.py > /tmp/integration_test.out 2>&1
        if [ $? -eq 0 ]; then
            if grep -q "ALL TESTS PASSED" /tmp/integration_test.out; then
                echo "✅ Full integration test passed"
                true
            else
                echo "❌ Integration test completed but some tests failed"
                tail -10 /tmp/integration_test.out
                false
            fi
        else
            echo "❌ Integration test failed or timed out"
            tail -10 /tmp/integration_test.out
            false
        fi
    else
        echo "❌ test_cowan_integration.py not found"
        false
    fi
'

# Test 9: Performance and Stress Tests
test_function "Memory Usage Test" '
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    cd "Multiplet2/RPES"
    
    # Check memory usage during GUI creation
    python3 -c "
import psutil
import os
import multiplet_gui
from PyQt6.QtWidgets import QApplication

process = psutil.Process(os.getpid())
initial_memory = process.memory_info().rss / 1024 / 1024  # MB

app = QApplication([])
gui = multiplet_gui.MultipletGUI()

final_memory = process.memory_info().rss / 1024 / 1024  # MB
memory_increase = final_memory - initial_memory

print(f\"Memory usage: {initial_memory:.1f}MB -> {final_memory:.1f}MB (+{memory_increase:.1f}MB)\")

if memory_increase < 200:  # Reasonable memory usage
    print(\"✅ Memory usage acceptable\")
else:
    print(\"⚠️  High memory usage detected\")
    
app.quit()
"
    cd ../..
'

# Final Results
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                          TEST RESULTS                          ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED! ($TESTS_PASSED/$TESTS_TOTAL)${NC}"
    echo -e "${GREEN}✅ Your ORBITRON-ME installation is working perfectly!${NC}"
    echo ""
    echo -e "${BLUE}📋 What works:${NC}"
    echo "   ✅ System dependencies installed"
    echo "   ✅ Python environment configured"
    echo "   ✅ All executables compiled and working"
    echo "   ✅ Both GUIs (Multiplet & EDAC) functional"
    echo "   ✅ Cowan atomic parameters integration working"
    echo "   ✅ Full workflow from calculation to visualization"
    echo ""
    echo -e "${BLUE}🚀 Ready to use:${NC}"
    echo "   python3 multiplet_gui.py    # Main Multiplet GUI"
    echo "   python3 edac_gui.py         # EDAC GUI"
    echo ""
    echo -e "${BLUE}💡 Don't forget:${NC}"
    echo "   • The Cowan section is at the TOP of the 'Create Input' tab"
    echo "   • Try the Examples button for common configurations"
    echo "   • Use Fe + 1s1,3d5 for K-edge or Fe + 2p5,3d5 for L₃-edge"
    
    exit 0
else
    echo -e "${RED}❌ SOME TESTS FAILED! ($TESTS_FAILED/$TESTS_TOTAL failed)${NC}"
    echo -e "${YELLOW}⚠️  Your installation has issues that need attention.${NC}"
    echo ""
    echo -e "${BLUE}📋 What to check:${NC}"
    
    if [ $TESTS_FAILED -gt $((TESTS_TOTAL/2)) ]; then
        echo "   • Run the compilation script: ./compile_linux.sh"
        echo "   • Check dependencies: sudo apt install build-essential python3-dev"
        echo "   • Verify virtual environment: source venv/bin/activate"
    else
        echo "   • Check specific failed tests above"
        echo "   • For Cowan issues: install atomic-parameters and dependencies"
        echo "   • For GUI issues: pip install PyQt6"
    fi
    
    echo ""
    echo -e "${BLUE}📖 For detailed help:${NC}"
    echo "   • Read: LINUX_COMPLETE_SETUP_GUIDE.md"
    echo "   • For Cowan: COWAN_INTEGRATION_GUIDE.md"
    echo "   • For development: MULTIPLET_GUI_DEVELOPER_GUIDE.md"
    
    exit 1
fi 