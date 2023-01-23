# Sprinkler

Sprinkler is a bash script which will conduct password spraying over SMB using rpcclient. 

The reason I created this tool is that occasionally I have a client who wants to limit passwordspraying to a specific time frame and there weren't many good tools out there for that. Eventually, I'll add more features and support more authentication protocols but for now this does what I need it to do. Hopefully it will be helpful to you as well.

Arguments in this order:
1. If running overnight the logic in the script has to be flipped. Therefore, the first argument should desginate day (-d) or (-n). Ex. 0600 to 1000 is -d, 2200 - 0600 is -n
2. Start-time in 24-hour format.
3. End-time in 24-hour format.
4. Username list
5. Password list 
6. Sleep time in seconds - for example if you wanted to spray a single password every 15 minutes - 15 * 60 = 900
7. Finally, the IP address of the host you want to spray against. 

Example daytime run:
```./sprinkler.sh -d 0600 1000 users.txt passwords.txt 900 localhost```

Example overnight run:
```./sprinkler.sh -n 2200 0700 users.txt passwords.txt 900 localhost```


