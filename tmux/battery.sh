#!/usr/bin/env bash

# This file needs to be executable (`chmod u+x battery.sh`)

echo "$(cat /sys/class/power_supply/*/capacity)"

