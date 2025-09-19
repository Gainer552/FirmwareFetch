#!/bin/bash

# CyberFirmwareFetch - Security-focused firmware info for Linux
# Author: Your Name
# License: MIT

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m"

echo -e "${GREEN}=== Cybersecurity Firmware Info ===${NC}"

# ----------------------------
# Kernel
# ----------------------------
KERNEL=$(uname -r)
echo -e "${YELLOW}Kernel:${NC} $KERNEL"

# ----------------------------
# CPU / Microcode
# ----------------------------
CPU_MODEL=$(lscpu | grep "Model name" | sed 's/Model name:[[:space:]]*//')
CPU_FLAGS=$(lscpu | grep "Flags" | sed 's/Flags:[[:space:]]*//')
CPU_MICROCODE=$(dmesg | grep microcode | tail -n1 | awk '{print $NF}')
echo -e "${YELLOW}CPU:${NC} $CPU_MODEL"
echo -e "${YELLOW}CPU Microcode:${NC} $CPU_MICROCODE"
echo -e "${YELLOW}CPU Flags:${NC} $CPU_FLAGS"

# ----------------------------
# BIOS / UEFI
# ----------------------------
if [ -f /sys/class/dmi/id/bios_version ]; then
    BIOS_VER=$(cat /sys/class/dmi/id/bios_version)
    BIOS_DATE=$(cat /sys/class/dmi/id/bios_date)
    echo -e "${YELLOW}BIOS Version:${NC} $BIOS_VER"
    echo -e "${YELLOW}BIOS Date:${NC} $BIOS_DATE"
fi

if [ -d /sys/firmware/efi ]; then
    echo -e "${YELLOW}Firmware Interface:${NC} UEFI"
else
    echo -e "${YELLOW}Firmware Interface:${NC} Legacy BIOS"
fi

# Secure Boot Status
if command -v mokutil &>/dev/null; then
    SECURE_BOOT=$(mokutil --sb-state | awk '{print $3}')
    echo -e "${YELLOW}Secure Boot:${NC} $SECURE_BOOT"
fi

# ----------------------------
# TPM
# ----------------------------
if command -v tpm2_getcap &>/dev/null; then
    TPM_VERSION=$(tpm2_getcap -c properties-fixed | grep "TPM2_PT_FIRMWARE_VERSION_1" | awk '{print $2}')
    echo -e "${YELLOW}TPM Firmware Version:${NC} $TPM_VERSION"
else
    echo -e "${YELLOW}TPM:${NC} Not Found or tpm2-tools missing"
fi

# ----------------------------
# Network / NIC
# ----------------------------
for IFACE in $(ls /sys/class/net | grep -v lo); do
    if command -v ethtool &>/dev/null; then
        NIC_FW=$(ethtool -i $IFACE 2>/dev/null | grep firmware-version | awk '{print $2}')
        if [ ! -z "$NIC_FW" ]; then
            echo -e "${YELLOW}NIC ($IFACE) Firmware:${NC} $NIC_FW"
        fi
    fi
done

# ----------------------------
# Storage / Disk
# ----------------------------
for DISK in $(lsblk -dn -o NAME,TYPE | grep disk | awk '{print $1}'); do
    if command -v smartctl &>/dev/null; then
        DISK_FW=$(sudo smartctl -i /dev/$DISK | grep "Firmware Version" | awk -F: '{print $2}' | xargs)
        echo -e "${YELLOW}Disk (/dev/$DISK) Firmware:${NC} $DISK_FW"
    fi
done

# ----------------------------
# Optional: OS / Distro
# ----------------------------
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo -e "${YELLOW}OS:${NC} $NAME $VERSION"
fi

echo -e "${GREEN}==============================${NC}"
