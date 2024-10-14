# Geekbench MultiTester

**Geekbench MultiTester** is a multiplatform benchmarking tool designed to simplify and accelerate CPU performance testing. It offers features such as automatic swap management, SHA-256 security checks, and detailed result outputs with personal save links.

## Features

- **Cross-Platform Compatibility:** Works on x86_64, aarch64, and riscv64 architectures.
- **Optimized for Performance:** Reduces download times for Geekbench 5, especially for users in mainland China.
- **Security:** Includes SHA-256 checksum verification to prevent malicious programs.
- **Automatic Swap Management:** Automatically adds swap for servers with less than 1GB of RAM.
- **No Residual Files:** Cleans up any test files and swap space after testing.
- **Detailed Reporting:** Provides comprehensive results and personal save links for results.
- **CPU Comparison Links:** Offers reference links for similar CPU types.

## Installation

To run the Geekbench MultiTester script, use the following command:

```bash
bash <(curl -sL https://raw.githubusercontent.com/melthehe/GeekbenchMultiTester/main/gb5-test.sh)
```

or

```bash
bash <(wget -qO- https://raw.githubusercontent.com/melthehe/GeekbenchMultiTester/main/gb5-test.sh)
```

## Python Multiplatform Script

This project includes a Python script that is designed to work across multiple platforms. You can execute the benchmarking tests directly using Python. Here's how to run it:

1. Ensure you have Python 3.x installed.
2. Clone the repository:

   ```bash
   git clone https://github.com/melthehe/GeekbenchMultiTester.git
   cd GeekbenchMultiTester
   ```

3. Run the Python script:

   ```bash
   python3 geekbench_multitester.py
   ```

### Sample `geekbench_multitester.py`

Here’s a simple example of what the `geekbench_multitester.py` script might look like:

```python
import os
import platform
import subprocess
import hashlib

def verify_checksum(file_path, expected_hash):
    """Verify the SHA-256 checksum of the downloaded file."""
    sha256_hash = hashlib.sha256()
    with open(file_path, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest() == expected_hash

def download_geekbench():
    """Download Geekbench for the current platform."""
    system = platform.system().lower()
    if system == "linux":
        url = "https://cdn.geekbench.com/Geekbench-5.4.4-Linux.tar.gz"
        # Add code to download the file
    elif system == "darwin":
        url = "https://cdn.geekbench.com/Geekbench-5.4.4-Mac.tar.gz"
        # Add code to download the file
    elif system == "windows":
        url = "https://cdn.geekbench.com/Geekbench-5.4.4-Windows.zip"
        # Add code to download the file
    else:
        print("Unsupported platform.")
        return None
    return url

def run_benchmark():
    """Run the Geekbench benchmark."""
    geekbench_path = download_geekbench()
    if geekbench_path:
        # Add code to extract and run Geekbench
        pass

if __name__ == "__main__":
    run_benchmark()
```

Make sure to customize the download and extraction logic as needed.

## Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/melthehe/GeekbenchMultiTester.git
   cd GeekbenchMultiTester
   ```

2. Execute the script:

   ```bash
   bash gb5-test.sh
   ```

   or for Python:

   ```bash
   python3 geekbench_multitester.py
   ```

3. Follow the on-screen instructions to perform the benchmark.

## Example Output

```
# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #
#            Geekbench MultiTester              #
#                 v2023-08-07                   #
#        https://github.com/melthehe/GeekbenchMultiTester  #
# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #

Current Time: 2023-08-07 08:22:28 UTC
Net Test Duration: 2 minutes 47 seconds

Geekbench 5 Test Results

System Information
  Operating System              Red Hat Enterprise Linux 9.2 (Plow)
  Kernel                        Linux 5.14.0-284.11.1.el9_2.x86_64 x86_64
  Model                         Xen HVM domU
  Motherboard                   N/A
  BIOS                          Xen 4.11.amazon

Processor Information
  Name                          Intel Xeon E5-2676 v3
  Topology                      1 Processor, 1 Core
  Identifier                    GenuineIntel Family 6 Model 63 Stepping 2
  Base Frequency                2.39 GHz
  L1 Instruction Cache          32.0 KB
  L1 Data Cache                 32.0 KB
  L2 Cache                      256 KB
  L3 Cache                      30.0 MB

Memory Information
  Size                          769 MB

Single-Core Score: 683
Multi-Core Score: 681
Detailed Results Link: https://browser.geekbench.com/v5/cpu/21552304
Reference Links: https://browser.geekbench.com/search?k=v5_cpu&q=Intel%20Xeon%20E5-2676%20v3

Personal Save Link: https://browser.geekbench.com/v5/cpu/21552304/claim?key=485945
```

## TODO

- Display scores directly in the terminal.
- Provide comparisons for similar CPUs after testing.
- Add more CPU-related tests.
- Fix issues with adding swap in LXC.
- Support for ARM architectures.
- Integrate Geekbench 6.
- Conduct basic CPU tests before running Geekbench tests, including disk tests if swap is involved.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue to discuss improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Special thanks to the developers of Geekbench for their benchmark tools.
