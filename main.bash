#!/bin/bash

# --- Config ---
version="BetaTask V0.4.0"
author="cwolfe1080"
date="04/01/26"

# Visuals (Optional: Adds a subtle terminal glow)
GREEN='\033[0;32m'
NC='\033[0m' # No Color

clear
echo -e "${GREEN}$version${NC}"
echo "Type 'help' for available commands."
echo ""

while true; do
    # The prompt
    echo -n ">>> "
    read -r input

    case "$input" in
        "help")
            echo "Commands: help, info, temp, clear, status, log, exit"
            echo "Type 'help(command_name)' for more information about a command."
            ;;
        "help(help)")
        	echo "Displays help info and commands."
        	;;
        "help(info)")
        	echo "Provides basic info about BetaTask."
        	;;
        "help(temp)")
        	echo "Reads the current CPU temperature in Celcius."
        	;;
        "help(clear)")
        	echo "Clears the terminal output."
        	;;
        "help(status)")
        	echo "Provides vital system statistics."
        	;;
        "help(log)")
        	echo "Logs an entry to the system log. Anything that comes after 'log ' will be logged."
        	;;
        "help(exit)")
        	echo "Quits BetaTask"
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
