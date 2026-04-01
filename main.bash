#!/bin/bash

clear

version="BetaTask V0.2.2"
echo "$version"
echo ""
while true; do
	echo -n ">>> "

	read -r input
	if [ "$input" == "help" ]; then
		echo "Commands:"
		echo "help - Open this help menu"
		echo "exit - Quit BetaTask"
		echo "info - See BetaTask Version Info"
		echo "temp - Get CPU temp"
		echo "clear - Clear the terminal"
	elif [ "$input" == "exit" ]; then
		clear
		exit
	elif [ "$input" == "info" ]; then
		echo "$version by cwolfe1080"
		echo "Version date: 04/01/26 MM/DD/YYYY"
	elif [ "$input" == "temp" ]; then
		vcgencmd measure_temp
	elif [ "$input" == "clear" ]; then
		clear
	

	else
		echo "Command '$input' was not recognized"	
	fi
done
