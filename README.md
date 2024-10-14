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
