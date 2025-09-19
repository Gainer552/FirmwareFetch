Description:
FirmwareFetch is a lightweight Bash script that displays key cybersecurity-relevant firmware information for Linux systems. It gathers information about the system BIOS/UEFI, CPU microcode, TPM, network interface firmware, disk firmware, and the operating system.

Usage:
1. Ensure the script has execute permissions: chmod +x firmwarefetch.sh
2. Run the script: ./firmwarefetch.sh
3. Some features (like disk firmware) may require root privileges: sudo ./firmwarefetch.sh

Features:
• Displays kernel version.
• Shows CPU model, microcode version, and CPU flags.
• Displays BIOS/UEFI version, release date, and firmware interface type.
• Shows Secure Boot status.
• Displays TPM firmware version (if tpm2-tools is installed).
• Lists firmware versions for network interfaces.
• Shows firmware versions for disks/SSDs (requires smartctl).
• Displays OS/distro information.

Requirements:
• Linux system
• Bash shell
• Optional tools for full functionality: smartctl, ethtool, tpm2-tools, mokutil

Legal Disclaimer:
FirmwareFetch is provided for informational and educational purposes only. The author assumes no responsibility for any misuse, damage, or security breaches resulting from the use of this script. Users are responsible for compliance with their local laws and organizational policies when running this program. Always use FirmwareFetch on systems you own or have explicit permission to analyze.