#! /usr/bin/zsh
###
#
# Script to gather HW info from devices
#
###
#
# TODO:
# HDD
#    - number
#    - capacity(s)
#    - HDD vs SSD
#    - health
# Battery
#    - design capacity
#    - current capacity
#    - health
#
###

system_info=$(sudo lshw -json)

system_manufacturer=$(jq '.vendor' <<< "$system_info")
system_serial_number=$(jq '.serial' <<< "$system_info")
system_model=$(jq '.product' <<< "$system_info")
system_version=$(jq '.version' <<< "$system_info")

cpu_info=$(sudo lshw -json -class cpu)

cpu_type=$(jq '.[].product' <<< "$cpu_info")
cpu_bits=$(jq '.[].width' <<< "$cpu_info")
cpu_cores=$(jq '.[].configuration.cores' <<< "$cpu_info")

tpm_version=$(sudo cat /sys/class/tpm/tpm0/tpm_version_major)

ram_installed=$(jq '.children[] | select(.id == "core").children[] | select(.id == "memory").size ' <<< "$system_info" | numfmt --to=iec)

printf \
"# System info #

Vendor: %s
Model: %s
Version: %s
Serial Number: %s

CPU: %s
CPU bits: %s
CPU cores: %s

TPM version: %s

RAM: %s
" \
"$system_manufacturer" \
"$system_serial_number" \
"$system_model" \
"$system_version" \
"$cpu_type" \
"$cpu_bits" \
"$cpu_cores" \
"$tpm_version" \
"$ram_installed"