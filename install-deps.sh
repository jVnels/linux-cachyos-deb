#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1 || ! command -v dpkg-query >/dev/null 2>&1; then
    echo "This dependency installer is for Debian/Ubuntu-style systems with apt and dpkg." >&2
    exit 1
fi

packages=(
    autoconf
    bc
    bison
    build-essential
    cpio
    curl
    debhelper
    devscripts
    dkms
    dwarves
    fakeroot
    flex
    gawk
    gcc
    kmod
    libelf-dev
    libiberty-dev
    libncurses-dev
    libpci-dev
    libssl-dev
    libudev-dev
    llvm
    make
    openssl
    rsync
    rustc
    wget
    whiptail
)

missing=()
for package in "${packages[@]}"; do
    if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
        missing+=("$package")
    fi
done

if [ "${#missing[@]}" -eq 0 ]; then
    echo "All build dependencies are already installed."
    exit 0
fi

echo "Installing missing dependencies:"
printf '  %s\n' "${missing[@]}"

sudo apt-get update
sudo apt-get install -y "${missing[@]}"

echo "Dependency install complete."
