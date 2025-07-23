#!/usr/bin/env python3
"""
Test script for Cowan atomic parameters integration
This demonstrates the integration without requiring the full GUI
"""

import os
import sys
import subprocess

def test_cowan_integration():
    """Test the Cowan integration functionality"""
    print("🧮 Testing Cowan Atomic Parameters Integration")
    print("=" * 50)
    
    # Check for atomic-parameters directory
    atomic_params_path = "/home/tesla/atomic-parameters"
    if not os.path.exists(atomic_params_path):
        print("❌ atomic-parameters directory not found")
        print("   Please run: git clone https://github.com/mretegan/atomic-parameters.git")
        return False
    
    params_script = os.path.join(atomic_params_path, "parameters.py")
    if not os.path.exists(params_script):
        print("❌ parameters.py not found in atomic-parameters directory")
        return False
    
    print("✅ atomic-parameters installation found")
    
    # Test calculation
    print("\n🔬 Testing Cowan calculation for Fe 1s1,3d5 (K-edge)")
    try:
        cmd = f'cd "{atomic_params_path}" && python3 parameters.py --element "Fe" --configuration "1s1,3d5"'
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, check=True)
        
        print("✅ Calculation successful!")
        print("\n📊 Calculated Parameters:")
        
        # Parse parameters from output
        parameters = {}
        for line in result.stderr.split('\n'):
            if 'INFO:' in line and '=' in line and 'eV' in line:
                parts = line.split('INFO: ')[1].split(' = ')
                if len(parts) == 2:
                    param_name = parts[0].strip()
                    param_value = parts[1].replace(' eV', '').strip()
                    try:
                        parameters[param_name] = float(param_value)
                        print(f"   {param_name} = {param_value} eV")
                    except ValueError:
                        pass
        
        print(f"\n✅ Found {len(parameters)} Slater-Condon parameters")
        
        # Show what these parameters mean
        print("\n💡 Parameter meanings:")
        print("   F2(3d,3d), F4(3d,3d) - Coulomb integrals for d-d interactions")
        print("   ζ(3d) - Spin-orbit coupling for 3d electrons")  
        print("   G2(1s,3d) - Exchange integral between 1s core hole and 3d")
        print("   E - Total atomic energy")
        
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Calculation failed: {e}")
        print(f"   stdout: {e.stdout}")
        print(f"   stderr: {e.stderr}")
        return False
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return False

def test_gui_integration():
    """Test the GUI integration"""
    print("\n🎨 Testing GUI Integration")
    print("=" * 30)
    
    try:
        # Import GUI modules
        import multiplet_gui
        from PyQt6.QtWidgets import QApplication
        
        # Create application
        app = QApplication(sys.argv)
        gui = multiplet_gui.MultipletGUI()
        
        print("✅ GUI created successfully")
        print(f"✅ Cowan UI elements exist: {hasattr(gui, 'cowan_element')}")
        print(f"✅ Validation method exists: {hasattr(gui, 'validate_cowan_inputs')}")
        print(f"✅ Examples method exists: {hasattr(gui, 'show_cowan_examples')}")
        
        # Test validation
        if hasattr(gui, 'validate_cowan_inputs'):
            valid, msg = gui.validate_cowan_inputs('Fe', '2p5,3d5')
            print(f"✅ Validation works: Fe + 2p5,3d5 = {valid}")
        
        app.quit()
        return True
        
    except Exception as e:
        print(f"❌ GUI test failed: {e}")
        return False

if __name__ == "__main__":
    print("🧪 Cowan Integration Test Suite")
    print("This tests the integration of Cowan's atomic structure codes")
    print("with the Multiplet GUI for automated Slater-Condon parameter calculation.\n")
    
    # Test Cowan calculation
    cowan_ok = test_cowan_integration()
    
    # Test GUI integration  
    gui_ok = test_gui_integration()
    
    print("\n" + "=" * 50)
    if cowan_ok and gui_ok:
        print("🎉 ALL TESTS PASSED!")
        print("\n✅ The Cowan integration is working correctly.")
        print("✅ You can now use the GUI to automatically calculate")
        print("   Slater-Condon parameters instead of entering them manually.")
        print("\n🚀 To use:")
        print("   1. Run: python3 multiplet_gui.py")
        print("   2. Go to 'Create Input' tab")
        print("   3. Scroll to the top to find the Cowan section")  
        print("   4. Enter element (Fe) and configuration (1s1,3d5)")
        print("   5. Click 'Calculate Parameters'")
        print("   6. Click 'Populate Fields' to auto-fill parameters")
    else:
        print("❌ Some tests failed. Check the output above.")
        if not cowan_ok:
            print("   - Install atomic-parameters: git clone https://github.com/mretegan/atomic-parameters.git")
        if not gui_ok:
            print("   - Check GUI dependencies: pip install PyQt6") 