#!/bin/bash

# --- Config ---
version="BetaTask V1.2.0"
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
            echo "Commands: help, info, temp, clear, status, log, exit, ping, update, uptime, readlog"
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
        "help(ping)")
        	echo "Pings google (8.8.8.8)"
        	;;
        "help(update)")
        	echo "Runs sudo apt update, sudo apt upgrade, and sudo apt autoremove."
        	;;
        "help(uptime)")
        	echo "Checks how long the system has been running"
        	;;
        "help(readlog)")
        	echo "Reads the contents of the station_log file. Usage 'readlog' reads the last 10 entries 'readlog [number]' reads the specified amount of entries."
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
            echo "[$(date +%m/%d/%Y) - $(date +%T)] $msg" >> station_log.txt
            echo "Entry recorded."
            ;;
		"ping")
			echo "Checking connectivity to Google..."
			ping -c 3 8.8.8.8 || echo "Network unreachable."
			;;
		"update")
			echo "Updating... (1/3)"
			sudo apt update
			echo "Updating... (2/3)"
			sudo apt upgrade
			echo "Updating... (3/3)"
			sudo apt autoremove
			;;
		"uptime")
			uptime -p
			;;
		"readlog"*) # Matches 'readlog' or 'readlog [number]'
            count="${input#readlog }"
            # If no number is provided, default to 10
            if [ "$count" == "readlog" ] || [ -z "$count" ]; then
                count=10
            fi

            if [ -f station_log.txt ]; then
                echo "--- Last $count Log Entries ---"
                tail -n "$count" station_log.txt
                echo "----------------------------"
            else
                echo "Error: No station_log.txt found."
            fi
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
            echo "Command '$input' not recognized. Check 'help'."
            ;;
    esac
done
