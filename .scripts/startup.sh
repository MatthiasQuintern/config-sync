#! /bin/bash
# script for boot
# load nvidia display settings
nvidia-settings --load-config-only

# remap numpad , to .
xmodmap -e "keysym KP_Separator = KP_Delete KP_Decimal KP_Decimal KP_Decimal KP_Decimal"

echo "startup.sh executed"
