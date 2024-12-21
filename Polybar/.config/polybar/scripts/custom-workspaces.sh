#!/bin/bash

# Get list of workspaces
workspaces=$(wmctrl -d | awk '{print $1, $2, $9}')

# Separate numbers and non-numeric entries, and sort them
numbers=$(echo "$workspaces" | awk '{print $3}' | grep -E '^[0-9]+$' | sort -n)
letters=$(echo "$workspaces" | awk '{print $3}' | grep -E '^[^0-9]' | grep -v 'NSP' | sort)
# letters=$(echo "$workspaces" | awk '{print $3}' | grep -E '^[^0-9]' | sort)

# Combine numbers first, then letters, all on one line
formatted=$(echo -e "$numbers\n$letters" | tr '\n' ' ' | sed 's/ $//')

# Display for Polybar
echo "$formatted"

##!/bin/bash
#
## Get list of workspaces
#workspaces=$(wmctrl -d | awk '{print $1, $2, $9}')
#
## Separate numbers and non-numeric entries, and sort them
#numbers=$(echo "$workspaces" | awk '{print $3}' | grep -E '^[0-9]+$' | sort -n)
#letters=$(echo "$workspaces" | awk '{print $3}' | grep -E '^[^0-9]' | sort)
#
## Combine numbers first, then letters
#formatted=$(echo -e "$numbers\n$letters")
#
## Display for Polybar
#echo "$formatted"

##!/bin/bash
#
## Get list of workspaces
#workspaces=$(wmctrl -d | awk '{print $1, $2, $9}')
#
## Sort workspaces numerically based on the last column
#sorted_workspaces=$(echo "$workspaces" | sort -k3,3n)
#
## Format output for Polybar
#formatted=$(echo "$sorted_workspaces" | awk '{print $3}')
#
## Display for Polybar
#echo $formatted
