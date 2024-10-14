import os
import platform
import subprocess
import hashlib
import urllib.request
import shutil
import time
import requests

# Constants
SCRIPT_VERSION = "v2024-05-08"
GEEKBENCH_VERSION = "5.5.1"

# Official SHA-256 hashes
GEEKBENCH_X86_64_SHA256 = "32037e55c3dc8f360fe16b7fbb188d31387ea75980e48d8cf028330e3239c404"
GEEKBENCH_AARCH64_SHA256 = "9eb3ca9ec32abf0ebe1c64002b19108bfea53c411c6b556b0c2689514b8cbd6f"
GEEKBENCH_RISCV64_SHA256 = "65070301ccedd33bfd4797a19e9d28991fe719cc38570dbc445b8355a5b9bc64"

# Download sources
URL_1 = "https://cdn.geekbench.com"
URL_2 = "https://asset.bash.icu/https://cdn.geekbench.com"

# Test directory
DIR = "./gb5-github-i-abc"

# Helper functions for colored text output
def print_red(text):
    print(f"\033[91m{text}\033[0m")

def print_yellow(text):
    print(f"\033[93m{text}\033[0m")

def print_blue(text):
    print(f"\033[96m{text}\033[0m")

# Banner function
def banner():
    print("# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #")
    print("#            Geekbench Test Script            #")
    print(f"#                 {SCRIPT_VERSION}                 #")
    print("#        https://github.com/i-abc/gb5         #")
    print("# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #")
    print()

# Check architecture
def check_architecture():
    arch = platform.machine()
    if arch not in ['x86_64', 'AMD64', 'aarch64', 'riscv64']:
        print("This script only supports x86_64, aarch64, and riscv64 architectures.")
        exit(1)

    if arch in ['x86_64', 'AMD64']:
        print_blue("Architecture: x86_64")
        return "Geekbench-{}-Linux.tar.gz".format(GEEKBENCH_VERSION), GEEKBENCH_X86_64_SHA256
    elif arch == 'aarch64':
        print_blue("Architecture: aarch64")
        return "Geekbench-{}-LinuxARMPreview.tar.gz".format(GEEKBENCH_VERSION), GEEKBENCH_AARCH64_SHA256
    elif arch == 'riscv64':
        print_blue("Architecture: riscv64")
        return "Geekbench-{}-LinuxRISCVPreview.tar.gz".format(GEEKBENCH_VERSION), GEEKBENCH_RISCV64_SHA256

# Create directory
def make_dir():
    if os.path.exists(DIR):
        shutil.rmtree(DIR)
    os.makedirs(DIR)

# Download Geekbench tarball
def download_geekbench(tar_name):
    print_yellow("Downloading Geekbench...")
    tar_url = f"{URL_1}/{tar_name}"
    tar_path = os.path.join(DIR, tar_name)
    urllib.request.urlretrieve(tar_url, tar_path)
    return tar_path

# Calculate and check SHA-256 checksum
def check_sha256(file_path, official_sha256):
    print_yellow("Verifying SHA-256 checksum...")
    sha256_hash = hashlib.sha256()
    with open(file_path, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    download_sha256 = sha256_hash.hexdigest()

    if download_sha256 == official_sha256:
        print_blue("SHA-256 checksum is valid.")
    else:
        print_red("SHA-256 checksum is invalid! Exiting.")
        exit(1)

# Extract tarball
def extract_tar(tar_path):
    print_yellow("Extracting tarball...")
    shutil.unpack_archive(tar_path, DIR)

# Run Geekbench test
def run_geekbench(geekbench_executable):
    print_yellow("Running Geekbench test...")
    start_time = time.time()
    result_file = os.path.join(DIR, "result.txt")

    with open(result_file, "w") as f:
        subprocess.run([geekbench_executable], stdout=f, text=True)

    end_time = time.time()
    run_time = end_time - start_time
    minutes = int(run_time // 60)
    seconds = int(run_time % 60)
    print(f"Test completed in {minutes} minutes {seconds} seconds.")

# Download test result HTML
def download_result_html(result_url):
    result_html_path = os.path.join(DIR, "result.html")
    response = requests.get(result_url)
    with open(result_html_path, "wb") as f:
        f.write(response.content)
    print_blue(f"Test result saved to {result_html_path}")

# Display summary
def output_summary():
    result_file = os.path.join(DIR, "result.txt")
    if os.path.exists(result_file):
        with open(result_file, "r") as f:
            result_text = f.read()
        print_yellow("Geekbench Test Result:")
        print(result_text)
    else:
        print_red("Result file not found!")

# Main function
def main():
    banner()
    arch_info = check_architecture()
    tar_name, official_sha256 = arch_info

    make_dir()
    tar_path = download_geekbench(tar_name)
    check_sha256(tar_path, official_sha256)
    extract_tar(tar_path)

    # Running the Geekbench test (assuming the executable is in the extracted folder)
    geekbench_executable = os.path.join(DIR, f"Geekbench-{GEEKBENCH_VERSION}-Linux", "geekbench5")
    run_geekbench(geekbench_executable)

    # Assuming the result contains a URL to download the result as HTML (mocked here)
    result_url = "https://browser.geekbench.com/cpu/benchmark_results.html"
    download_result_html(result_url)

    output_summary()

if __name__ == "__main__":
    main()
