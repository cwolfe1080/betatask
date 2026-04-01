#!/bin/bash

# --- Config ---
version="BetaTask V0.3.0"
author="cwolfe1080"
date="04/01/26"

# Visuals (Optional: Adds a subtle terminal glow)
GREEN='\033[0;32m'
NC='\033[0m' # No Color

clear
echo -e "${GREEN}$version - Remote Station Online${NC}"
echo "Type 'help' for available protocols."
echo ""

while true; do
    # The prompt
    echo -n ">>> "
    read -r input

    case "$input" in
        "help")
            echo "Protocols: help, info, temp, clear, status, log, exit"
            ;;
        "info")
            echo "$version by $author"
            echo "Last Update: $date"
            ;;
        "temp")
            # Falls back to a standard check if vcgencmd isn't there
            vcgencmd measure_temp || echo "Sensor data unavailable."
            ;;
        "status")
            echo "--- Station Integrity ---"
            df -h / | awk 'NR==2 {print "Storage: " $5 " used"}'
            free -m | awk 'NR==2 {print "Memory: " $3 "MB / " $2 "MB"}'
            ;;
        "log "*) # Matches 'log' followed by anything
            msg="${input#log }"
            echo "[$(date +%T)] $msg" >> station_log.txt
            echo "Entry recorded."
            ;;
        "clear")
            clear
            ;;
        "exit")
            clear
            exit
            ;;
        "") # Do nothing on empty enter
            ;;
        *)
            echo "Protocol '$input' not recognized. Check 'help'."
            ;;
    esac
done
