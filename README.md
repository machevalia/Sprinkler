# Sprinkler

Sprinkler is a bash script which will conduct password spraying over SMB using rpcclient. 

The reason I created this tool is that occasionally I have a client who wants to limit passwordspraying to a specific time frame and there weren't many good tools out there for that. Eventually, I'll add more features and support more authentication protocols but for now this does what I need it to do. Hopefully it will be helpful to you as well.

Arguments in this order:
1. If you plan to run the script overnight where the times would be something like 2200 - 0600, then throw the "-n" flag as argument 1.
2. Start-time in 24-hour format with just the hour value. E.g., 10 PM is 22 or 6 AM is 6.
3. End-time in 24-hour format with just the hour value.
4. Username list
5. Password list 
6. Sleep time in seconds - for example if you wanted to spray a single password every 15 minutes - 15 * 60 = 900
7. Finally, the IP address of the host you want to spray against. 

Example image below demonstrates calling the script, output, me pausing the script by putting my system clock out of the authorized times, then resumption of the script once I put my system clock back in authorized times. 

*Note example image shows support for 24-hour time with minutes. The script was changed to just the hour # because some of my larger lists (most) ended up running beyond the authorized hours. So, ending the script on evenly on an hour, even if a bit ahead of your authorized hour is advised. If you want to support minutes, add %M to instances of CURRENT_TIME. 

<img src=/spray_example.png>


