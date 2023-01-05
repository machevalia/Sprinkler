# Sprinkler

Sprinkler is a bash script which will conduct password spraying over SMB using rpcclient. 

The reason I created this tool is that occasionally I have a client who wants to limit passwordspraying to a specific time frame and there weren't many good tools out there for that. Eventually, I'll add more features and support more authentication protocols but for now this does what I need it to do. Hopefully it will be helpful to you as well.

Arguments in this order:
1. Start-time in 24-hour format.
2. End-time in 24-hour format.
3. Username list
4. Password list 
5. Sleep time in seconds - for example if you wanted to spray a single password every 15 minutes - 15 * 60 = 900
6. Finally, the IP address of the host you want to spray against. 

Example image below demonstrates calling the script, output, me pausing the script by putting my system clock out of the authorized times, then resumption of the script once I put my system clock back in authorized times.

<img src=/spray_example.png>

**There is an untested version of the script in python3 available as well.**
