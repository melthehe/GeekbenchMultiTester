#!/bin/bash

##### Custom Constants #####

# Script release version
script_version="v2024-05-08"

# Geekbench5 release version
geekbench_version="5.5.1"

# Official SHA-256 for Geekbench5
geekbench_x86_64_official_sha256="32037e55c3dc8f360fe16b7fbb188d31387ea75980e48d8cf028330e3239c404"
geekbench_aarch64_official_sha256="9eb3ca9ec32abf0ebe1c64002b19108bfea53c411c6b556b0c2689514b8cbd6f"
geekbench_riscv64_official_sha256="65070301ccedd33bfd4797a19e9d28991fe719cc38570dbc445b8355a5b9bc64"

# Download sources
url_1="https://cdn.geekbench.com"
url_2="https://asset.bash.icu/https://cdn.geekbench.com"

# Test working directory
dir="./gb5-github-i-abc"

##### Colors #####

_red() {
    echo -e "\033[0;31;31m$1\033[0m"
}

_yellow() {
    echo -e "\033[0;31;33m$1\033[0m"
}

_blue() {
    echo -e "\033[0;31;36m$1\033[0m"
}

##### Banner #####
_banner() {
    echo -e "# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #"
    echo -e "#           Geekbench 5 Test for Servers        #"
    echo -e "#                 $script_version                  #"
    echo -e "#         $(_yellow "bash <(curl -sL bash.icu/gb5)")    #"
    echo -e "#         https://github.com/melthehe/GeekbenchMultiTester #"
    echo -e "# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #"
    echo
}

##### Check locale configuration and override with C locale #####
_check_locale() {
    if locale -a 2>/dev/null | grep -q "^C$"; then
        export LC_ALL=C
    fi
}

##### Check if a package is installed, and install it if not. Currently only supports RedHat and Debian systems #####
_check_package() {
    _yellow "Checking if required package $1 is installed"
    # Check if the package is installed
    if ! command -v $1; then
        # Identify the package manager and install the package
        if command -v dnf; then
            sudo dnf -y install $2
        elif command -v yum; then
            sudo yum -y install $2
        elif command -v apt; then
            sudo apt -y install $2
        else
            _blue "This machine is neither RedHat nor Debian based. Automatic package installation is not supported."
            exit
        fi
        # Recheck if the package is installed
        if ! command -v $1; then
            _red "Failed to automatically install the required package $1"
            echo "Please manually install $1 before running this script again"
            exit
        fi
    fi
}

##### Confirm architecture and corresponding tarball #####
# Geekbench 5 and 6 only support 64-bit, i.e., x86_64, aarch64, and riscv64
_check_architecture() {
    # Exit if not 64-bit
    if [ "$(getconf LONG_BIT)" != "64" ]; then
        echo "This script only supports 64-bit processors"
        exit
    fi

    # Check whether it's x86_64, aarch64, or riscv64
    if [ "$(uname -m)" == "x86_64" ]; then
        _blue "Machine architecture: x86_64"
        geekbench_tar_name=Geekbench-$geekbench_version-Linux.tar.gz
        geekbench_tar_folder=Geekbench-$geekbench_version-Linux
        geekbench_official_sha256=$geekbench_x86_64_official_sha256
        geekbench_software_name=geekbench5
    elif [ "$(uname -m)" == "aarch64" ]; then
        _blue "Machine architecture: aarch64"
        geekbench_tar_name=Geekbench-$geekbench_version-LinuxARMPreview.tar.gz
        geekbench_tar_folder=Geekbench-$geekbench_version-LinuxARMPreview
        geekbench_official_sha256=$geekbench_aarch64_official_sha256
        geekbench_software_name=geekbench5
    elif [ "$(uname -m)" == "riscv64" ]; then
        _blue "Machine architecture: riscv64"
        geekbench_tar_name=Geekbench-$geekbench_version-LinuxRISCVPreview.tar.gz
        geekbench_tar_folder=Geekbench-$geekbench_version-LinuxRISCVPreview
        geekbench_official_sha256=$geekbench_riscv64_official_sha256
        geekbench_software_name=geekbench5
    else
        echo "This script only supports x86_64, aarch64, and riscv64 architectures"
        exit
    fi
    _blue "Machine virtualization: $(systemd-detect-virt)"
}

##### Create directory #####
_make_dir() {
    # Remove any existing leftover files
    sudo swapoff $dir/swap &>/dev/null
    rm -rf $dir

    # Create the directory
    mkdir $dir
}

##### Check memory and add swap if needed #####
_check_swap() {
    # Check memory
    mem=$(free -m | awk '/Mem/{print $2}')
    old_swap=$(free -m | awk '/Swap/{print $2}')
    old_ms=$((mem + old_swap))
    _blue "Machine memory: ${mem}Mi"
    _blue "Machine swap: ${old_swap}Mi"
    _blue "Total memory plus swap: ${old_ms}Mi\n"

    # If memory is less than 1G or total memory + swap is less than 1.25G, add swap
    if [ "$mem" -ge "1024" ]; then
        _yellow "Memory is greater than 1G, meeting GB5 test requirements\n"
    elif [ "$old_ms" -ge "1280" ]; then
        _yellow "Memory + swap is greater than 1.25G, meeting GB5 test requirements\n"
    else
        echo "Memory is less than 1G, and memory + swap is less than 1.25G, not meeting GB5 test requirements. Here are your options:"
        echo "1. Add swap (this will be done automatically and reverted after the test)"
        echo -e "2. Exit the test\n"
        _yellow "Please enter your choice (number): \c"
        read -r choice_1
        echo -e "\033[0m"
        case "$choice_1" in
        2)
            exit
            ;;
        # Add swap
        1)
            _yellow "Adding swap. Completion time depends on disk speed, please be patient.\n"
            need_swap=$((1300 - old_ms))
            # fallocate -l "$need_swap"M $dir/swap
            # fallocate fails to create swap on RHEL6, 7. See https://access.redhat.com/solutions/4570081
            sudo dd if=/dev/zero of=$dir/swap bs=1M count=$need_swap
            sudo chmod 0600 $dir/swap
            sudo mkswap $dir/swap
            sudo swapon $dir/swap

            # Recheck if memory + swap is less than 1.25G
            new_swap=$(free -m | awk '/Swap/{print $2}')
            new_ms=$((mem + new_swap))
            if [ "$new_ms" -ge "1280" ]; then
                echo
                _blue "Memory + swap is now ${new_ms}Mi, meeting GB5 test requirements\n"
            else
                echo
                echo "Unfortunately, due to an unknown reason, swap failed to add. Memory + swap is still ${new_ms}Mi, not meeting GB5 test requirements. Here are your options:"
                echo "1. Force run GB5 test"
                echo -e "2. Exit the test\n"
                _yellow "Please enter your choice (number): \c"
                read -r choice_2
                echo -e "\033[0m"
                case "$choice_2" in
                2)
                    exit
                    ;;
                1)
                    echo
                    ;;
                *)
                    _red "Invalid input, please rerun the script"
                    exit
                    ;;
                esac
            fi
            ;;
        *)
            _red "Invalid input, please rerun the script"
            exit
            ;;
        esac
    fi
}

##### Check IP type #####
# Running the test on IPv6-only servers is meaningless,
# because the results need to be uploaded to browser.geekbench.com to get the final scores,
# but browser.geekbench.com only supports IPv4, not IPv6, making the test useless.
_check_ip() {
    if ! curl -s 'https://browser.geekbench.com' --connect-timeout 5 >/dev/null; then
        echo "This server does not have an IPv4 network connection"
        exit
    fi
}

##### Confirm the region of the server (whether it's China or not), and select the appropriate download source #####
_check_region() {
    ip_info=$(curl -m 5 -s ipinfo.io 2>/dev/null)
    if echo "$ip_info" | grep -q '"country": "CN"'; then
        echo "This server is in China, using the mirror source"
        url=$url_2
    else
        echo "This server is outside China, using the default source"
        url=$url_1
    fi
}

##### Download tarball #####
_download() {
    cd $dir
    rm -rf $geekbench_tar_name

    _yellow "Downloading from $url"
    wget $url/geekbench5/$geekbench_tar_name

    if [ $? != 0 ]; then
        _red "Download failed"
        exit
    fi
}

##### Check SHA-256 #####
_check_sha256() {
    _yellow "Verifying the integrity of the Geekbench5 tarball"
    geekbench_tar_sha256=$(sha256sum $geekbench_tar_name | awk '{print $1}')
    if [ "$geekbench_tar_sha256" != "$geekbench_official_sha256" ]; then
        _red "Geekbench5 SHA-256 does not match the official one, test aborted"
        exit
    fi
}

##### Unpack tarball #####
_unpack() {
    _yellow "Unpacking"
    tar zxf $geekbench_tar_name
    cd $geekbench_tar_folder
}

##### Test #####
_run() {
    _yellow "Running GB5 test"
    result=$(./$geekbench_software_name 2>&1)
    url=$(echo "$result" | grep "https://browser.geekbench.com/v5/.*")
    single=$(echo "$result" | grep " single-core " | awk '{print $4}')
    multi=$(echo "$result" | grep " multi-core " | awk '{print $4}')

    echo
    _blue "Single-core score: $single"
    _blue "Multi-core score: $multi"
    echo "Results link: $url"
    echo
    echo "$result" >>$dir/geekbench-result.log
}

##### Cleanup #####
_cleanup() {
    echo "Cleaning up temporary files"
    sudo swapoff $dir/swap &>/dev/null
    rm -rf $dir
}

##### End #####
_end() {
    _yellow "GB5 test completed"
    echo -e "This script is open source and free to use. Source code: https://github.com/i-abc/gb5\n"
    echo
}

##### Main #####
main() {
    _banner
    _check_locale
    _check_architecture
    _check_package wget wget
    _check_package tar tar
    _check_package perl perl
    _make_dir
    _check_swap
    _check_ip
    _check_region
    _download
    _check_sha256
    _unpack
    _run
    _cleanup
    _end
}
main
