#!/bin/bash

# Update Existing ORBITRON-ME Installation Script
# This script helps existing users get the new Cowan integration

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    ORBITRON-ME UPDATE SCRIPT - Cowan Integration Upgrade       ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "multiplet_gui.py" ] && [ ! -d "Multiplet2" ]; then
    if [ -d "ORBITRON-ME" ]; then
        echo -e "${YELLOW}⚠️  Entering ORBITRON-ME directory...${NC}"
        cd ORBITRON-ME
    else
        echo -e "${RED}❌ Error: Not in ORBITRON-ME directory and can't find it${NC}"
        echo "Please run this script from your ORBITRON-ME directory"
        exit 1
    fi
fi

echo -e "${BLUE}📋 Step 1: Updating Repository${NC}"
echo "Pulling latest changes from GitHub..."

# Check git status
if git status > /dev/null 2>&1; then
    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        echo -e "${YELLOW}⚠️  You have uncommitted changes in your repository.${NC}"
        echo "Git status:"
        git status --short
        echo ""
        echo "Would you like to:"
        echo "1. Stash your changes and continue (recommended)"
        echo "2. Continue anyway (may cause conflicts)"
        echo "3. Exit and handle manually"
        read -p "Choose option (1/2/3): " choice
        
        case $choice in
            1)
                echo "Stashing your changes..."
                git stash
                echo -e "${GREEN}✅ Changes stashed${NC}"
                ;;
            2)
                echo -e "${YELLOW}⚠️  Continuing with uncommitted changes...${NC}"
                ;;
            3)
                echo "Exiting. Please commit or stash your changes first."
                exit 0
                ;;
            *)
                echo "Invalid choice. Exiting."
                exit 1
                ;;
        esac
    fi
    
    # Pull the latest changes
    echo "Pulling from origin/main..."
    if git pull origin main; then
        echo -e "${GREEN}✅ Repository updated successfully${NC}"
        
        # Show what's new
        echo ""
        echo -e "${BLUE}🆕 What's New:${NC}"
        echo "  • Cowan Atomic Parameters Calculator"
        echo "  • Automated Slater-Condon parameter calculation"
        echo "  • Enhanced documentation and guides"
        echo "  • Comprehensive testing suite"
        echo ""
    else
        echo -e "${RED}❌ Failed to pull updates${NC}"
        echo "Please resolve conflicts manually or contact support"
        exit 1
    fi
else
    echo -e "${RED}❌ This doesn't appear to be a git repository${NC}"
    echo "Please re-clone from: https://github.com/TeslaYet/ORBITRON-ME"
    exit 1
fi

echo -e "${BLUE}📋 Step 2: Installing Cowan Dependencies${NC}"

# Check if atomic-parameters exists
if [ -d "../atomic-parameters" ]; then
    echo -e "${GREEN}✅ Found existing atomic-parameters directory${NC}"
    cd ../atomic-parameters
    echo "Updating atomic-parameters..."
    git pull origin main || echo -e "${YELLOW}⚠️  Could not update atomic-parameters (may still work)${NC}"
    cd ../ORBITRON-ME
elif [ -d "atomic-parameters" ]; then
    echo -e "${GREEN}✅ Found atomic-parameters in current directory${NC}"
else
    echo "Installing atomic-parameters..."
    cd ..
    if git clone https://github.com/mretegan/atomic-parameters.git; then
        echo -e "${GREEN}✅ atomic-parameters cloned successfully${NC}"
        cd ORBITRON-ME
    else
        echo -e "${RED}❌ Failed to clone atomic-parameters${NC}"
        echo "You can install it manually later with:"
        echo "git clone https://github.com/mretegan/atomic-parameters.git"
        cd ORBITRON-ME
    fi
fi

# Install dependencies
if [ -d "../atomic-parameters" ]; then
    echo "Installing Cowan dependencies..."
    cd ../atomic-parameters
    
    # Activate virtual environment if it exists
    if [ -d "../ORBITRON-ME/venv" ]; then
        source ../ORBITRON-ME/venv/bin/activate
        echo -e "${GREEN}✅ Activated virtual environment${NC}"
    fi
    
    if pip install -r requirements.txt; then
        echo -e "${GREEN}✅ Cowan dependencies installed${NC}"
    else
        echo -e "${YELLOW}⚠️  Some dependencies may have failed to install${NC}"
        echo "You may need to install them manually"
    fi
    
    # Test the installation
    echo "Testing Cowan installation..."
    if timeout 30s python3 parameters.py --element "Fe" --configuration "1s1,3d5" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Cowan calculation test passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Cowan test failed or timed out (may still work in GUI)${NC}"
    fi
    
    cd ../ORBITRON-ME
else
    echo -e "${YELLOW}⚠️  atomic-parameters not found, skipping dependency installation${NC}"
fi

echo ""
echo -e "${BLUE}📋 Step 3: Testing Updated Installation${NC}"

# Activate virtual environment
if [ -d "venv" ]; then
    source venv/bin/activate
    echo -e "${GREEN}✅ Activated virtual environment${NC}"
else
    echo -e "${YELLOW}⚠️  Virtual environment not found${NC}"
fi

# Run integration test
if [ -f "test_cowan_integration.py" ]; then
    echo "Running Cowan integration test..."
    if timeout 60s python3 test_cowan_integration.py > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Integration test passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Integration test failed (check dependencies)${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Integration test not found${NC}"
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🎉 UPDATE COMPLETE!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}🚀 To use the new Cowan integration:${NC}"
echo ""
echo "1. Launch the GUI:"
echo "   cd Multiplet2/RPES"
echo "   python3 multiplet_gui.py"
echo ""
echo "2. In the GUI:"
echo "   • Go to 'Create Input' tab"
echo "   • Scroll to the TOP to find 'Cowan Atomic Parameters Calculator'"
echo "   • Try: Element=Fe, Configuration=1s1,3d5"
echo "   • Click 'Calculate Parameters' then 'Populate Fields'"
echo ""
echo -e "${BLUE}📖 Documentation:${NC}"
echo "   • User Guide: COWAN_INTEGRATION_GUIDE.md"
echo "   • Developer Guide: MULTIPLET_GUI_DEVELOPER_GUIDE.md"
echo "   • Setup Guide: LINUX_COMPLETE_SETUP_GUIDE.md"
echo ""
echo -e "${BLUE}💡 Benefits:${NC}"
echo "   ⚡ Automated parameter calculation (no more manual lookup!)"
echo "   🎯 Accurate Slater-Condon parameters from Cowan's codes"
echo "   🔄 Consistent parameter sets for all elements"
echo "   📚 No need for extensive literature knowledge"
echo ""
echo -e "${GREEN}Happy calculating! 🔬⚛️${NC}" 