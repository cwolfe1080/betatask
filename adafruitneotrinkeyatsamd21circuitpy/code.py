import time
import usb_hid
import sys
import gc
import os
import microcontroller
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keyboard_layout_us import KeyboardLayoutUS
import adafruit_ducky

import touchio # pylint: disable=unused-import
import board
import neopixel
from digitalio import DigitalInOut, Pull # pylint: disable=unused-import

# Uncomment for Neo Trinkey
touch1 = touchio.TouchIn(board.TOUCH1)
touch2 = touchio.TouchIn(board.TOUCH2)

# Uncomment for NeoKey Trinkey
#button = DigitalInOut(board.SWITCH)
#button.switch_to_input(pull=Pull.DOWN)
#button_state = False

pixels = neopixel.NeoPixel(board.NEOPIXEL, 4)

pixels[0] = (3, 3, 3)

version = "BetaTask (NeoTrinkey ATSAMD21) V0.1.0"
date = "04/02/26"

print(version)
print("Type 'help' for available commands.\n")

while True:
    condition = any([touch1.value, touch2.value])
    first = input(">>> ")
    if first == "help":
        print('Commands: help, info, temp, clear, exit, status')
        print("Type 'help(command_name)' for more infomration about a command.")
    elif first == "help(help)":
        print("Displays help info and commands.")
    elif first == "help(info)":
        print("Provides basic info about BetaTask")
    elif first == "help(temp)":
        print("Reads the current CPU temperature in Celcius.")
    elif first == "help(clear)":
        print("Clears the serial/terminal output.")
    elif first == "help(exit)":
        print("Quits BetaTask")
    elif first == "help(status)":
        print("Provides vital system statistics.")
        

        
    elif first == "info":
        print(version + " by cwolfe1080")
        print("Last Update: " + date)
    elif first == "temp":
        cpu_temp = microcontroller.cpu.temperature
        cpu_temp = str(cpu_temp)
        print("temp=" + cpu_temp)
    elif first == "clear":
        print("\033[2J\033[H", end="")
    elif first == "exit":
        break
    elif first == "status":
        print('--- Station Integrity ---')
        fs_stat = os.statvfs('/')
        total_space = fs_stat[0] * fs_stat[2]
        free_space = fs_stat[0] * fs_stat[3]
        used_space = total_space - free_space
        percent_used = (used_space / total_space) * 100
        print(f"Storage: {percent_used:.1f}%" + " used")
        free_ram = gc.mem_free()
        print('Memory Free: ' + str(free_ram) + " bytes")

    else:
        print("Command '" + first + "' not recognized. Check 'help'.")
    
    time.sleep(0.01)  # small delay to avoid busy-waiting

pixels[0] = (0, 0, 0)
