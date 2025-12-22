import subprocess
import threading
import time
import os
import sys
from pathlib import Path

RESULTS_DIR = Path("test_results")
RESULTS_DIR.mkdir(exist_ok=True)

# ---- EMULATOR MANAGEMENT ----
AVD_NAME = None
def ensure_ai_emulator():
    global AVD_NAME
    # Find emulator prefixed with "AI"
    print("Checking for Android AVDs...")
    avd_output = subprocess.check_output(["avdmanager", "list", "avd"]).decode()
    lines = avd_output.splitlines()
    found_ai = False
    for line in lines:
        if line.strip().startswith("Name:"):
            name = line.split(":")[1].strip()
            if name.startswith("AI"):
                AVD_NAME = name
                found_ai = True
                print(f"Using existing emulator: {AVD_NAME}")
                break
    if not found_ai:
        # Create a new AVD named 'AI_Memverse' using Pixel_4_API_31 (as representative)
        print("No 'AI' AVD found. Creating AI_Memverse emulator...")
        try:
            subprocess.check_call([
                "avdmanager", "create", "avd", "-n", "AI_Memverse", "-k", "system-images;android-31;google_apis;x86_64", "-d", "pixel_4"
            ])
        except subprocess.CalledProcessError as e:
            print(f"Failed to create AVD: {e}. Trying anyway in case it already exists...")
        AVD_NAME = "AI_Memverse"

    # Start emulator if not running
    print("Checking running emulator devices...")
    emulator_list = subprocess.check_output(["adb", "devices"]).decode()
    if not any('emulator-' in l and 'device' in l for l in emulator_list.splitlines()):
        print(f"Starting emulator {AVD_NAME} in headless mode...")
        subprocess.Popen([
            "emulator", "-avd", AVD_NAME, "-no-audio", "-no-window", "-wipe-data"
        ])
        # Wait for device boot
        print("Waiting for emulator to boot...")
        booted = False
        for _ in range(60):
            devices = subprocess.check_output(["adb", "devices"]).decode()
            if any('emulator-' in l and 'device' in l for l in devices.splitlines()):
                # Confirm sys.boot_completed
                try:
                    bc = subprocess.check_output([
                        "adb", "shell", "getprop", "sys.boot_completed"
                    ]).decode().strip()
                    if bc == '1':
                        booted = True
                        print("Emulator booted!")
                        break
                except:
                    pass
            time.sleep(3)
        if not booted:
            print("Warning: Emulator failed to boot in 3 minutes. Tests may fail.")
    else:
        print("Emulator already running.")

# ---- TEST JOBS ----
# Test commands and output names
TESTS = [
    {
        "name": "adb_screenshot",
        "cmd": "adb exec-out screencap -p > test_results/emulator_screen.png",
        "desc": "ADB screenshot after launch",
        "log": "adb_screenshot.log",
        "timeout": 30,
    },
    {
        "name": "maestro",
        "cmd": "maestro test maestro/flows/happy_path.yaml > test_results/maestro.log 2>&1",
        "desc": "Maestro happy_path UI flow",
        "log": "maestro.log",
        "timeout": 120,
    },
    {
        "name": "integration_test",
        "cmd": "flutter test integration_test/ --dart-define=INTEGRATION_TEST=true > test_results/integration_test.log 2>&1",
        "desc": "Flutter integration tests",
        "log": "integration_test.log",
        "timeout": 300,
    },
    {
        "name": "widget_bdd_test",
        "cmd": "flutter test test/ --tags bdd > test_results/widget_bdd_test.log 2>&1",
        "desc": "Widget BDD-feature tests (bdd-widget)",
        "log": "widget_bdd_test.log",
        "timeout": 120,
    },
    {
        "name": "bdd_feature_test",
        "cmd": "flutter test integration_test/app_ui_bdd_test_test.dart > test_results/bdd_feature_test.log 2>&1",
        "desc": "Integration BDD-feature flow",
        "log": "bdd_feature_test.log",
        "timeout": 120,
    },
]

results = {}
threads = []

def run_test(test):
    name = test["name"]
    t0 = time.time()
    try:
        proc = subprocess.Popen(
            test["cmd"],
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            executable="/bin/bash",
        )
        try:
            outs, _ = proc.communicate(timeout=test["timeout"])
            status = "PASS" if proc.returncode == 0 else f"FAIL (code {proc.returncode})"
        except subprocess.TimeoutExpired:
            proc.kill()
            outs, _ = proc.communicate()
            status = "TIMEOUT"
        finally:
            with open(RESULTS_DIR / test["log"], "wb") as f:
                f.write(outs if outs else b"")
        elapsed = int(time.time() - t0)
        results[name] = dict(
            desc=test["desc"], status=status, log=str(RESULTS_DIR/test["log"]), seconds=elapsed
        )
    except Exception as e:
        results[name] = dict(desc=test["desc"], status=f"EXCEPTION: {e}", log=None, seconds=int(time.time()-t0))

def main():
    print("\n===== Memverse Parallel Test Runner =====\n")
    ensure_ai_emulator()
    for test in TESTS:
        thread = threading.Thread(target=run_test, args=(test,))
        thread.start()
        threads.append(thread)
    for thread in threads:
        thread.join()
    print("\n========= RESULTS =========")
    for name, result in results.items():
        print(f"{result['desc']} [{name}]: {result['status']} (elapsed: {result['seconds']}s)")
        if result['log']:
            print(f"  log: {result['log']}")
    print("\nArtifacts (screenshots/logs) are saved in test_results/\n")
    print("Review ALL logs if there's any FAIL/TIMEOUT/EXCEPTION above.\n")

if __name__ == "__main__":
    main()
