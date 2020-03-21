#!/bin/bash

#	Script2.sh
#	by Sam Dinkelman
#	02/03/2019
#This script looks at the status information in /proc
#it will return the name, state and pid of every process 
#in that directory. This script can also look at just processes
#that are idle, sleeping, stopped and running. 

#saves path to directories in /proc that are numbers only into an array variable
proc=$( sudo ls -d /proc/*[[:digit:]]*/status )

#function searches processes in /proc for PID, Name, State
proc_state(){
	#for every path found give the name, state and Pid
	for i in $proc
	do
		sudo cat "${i}" | egrep -w 'Pid:|Name:|State:'; echo
	done
}

#function searches idle processes in /proc for name, state and pid  
proc_idle(){
	#saves path to processes containing I for idle
	proc_idle=$( grep -lw 'I' $proc )
	#for every path print the name, state and pid
	for i in $proc_idle
	do 
		sudo cat "${i}" | egrep -w 'Pid:|Name:|State:';echo
	done
}

#function searches sleeping processes in /proc for name, state and pid
proc_sleeping(){
	#saves path to process containing S for sleeping
        proc_sleeping=$( grep -lw 'S' $proc )
	#for every path print the name, state and pid
        for i in $proc_sleeping
        do
                sudo cat "${i}" | egrep -w 'Pid:|Name:|State:';echo
        done
}

#function searches stopped processes in /proc for name, state and pid
proc_stopped(){
	#saves the path to process containing T for stopped
        proc_stopped=$( grep -lw 'T' $proc )
	#for every path print the name, state and pid
        for i in $proc_stopped
        do
                sudo cat "${i}" | egrep -w 'Pid:|Name:|State:';echo
        done
}

#function searches for running processes in /proc for name, state and pid
proc_running(){
	#saves the path to process containing R for running
        proc_running=$( grep -lw 'R' $proc )
	#for every path print the name, state and pid
        for i in $proc_running
        do
                sudo cat "${i}" | egrep -w 'Pid:|Name:|State:';echo
        done
}

#check command line for 1 to 3 arguments
if [ $# -lt 1 ] || [ $# -gt 2 ]
then
	#prints usage
	echo Usage: sudo $0 "[-argument 1]" "[-argument 2]"
	echo $0 -h for more info
	echo

#displays help if requested
elif [ "-h" = $1 ]
then
	echo
	echo ARGUMENTS:
	printf "\n-s\n"
	printf "\t returns the name, state and Pid of all processes\n\n"
	printf "\n-s -idle \n"
	printf "\treturns the name, state and Pid of all the processes currently idle\n\n"
	printf "\n-s -sleeping\n"
	printf "\treturns the name, state and Pid of all the processes currently sleeping\n\n"
	printf "\n-s -stopped\n"
	printf "\treturns the name, state and Pid of all the processes currently stopped\n\n"
	printf "\n-s -running\n"
	printf "\treturns the name, state and Pid of all the processes currently running\n\n"
	sudo ./script2.sh

#if the user enters -s and -running then show running processes
elif [ "-running" = $2 ] && [ "-s" = $1 ]
then
	proc_running 

#if the user enters -s and -stopped then show stopped processes
elif [ "-stopped" = $2 ] && [ "-s" = $1 ] 
then
	proc_stopped

#if the user enters -s and -sleeping then show sleeping processes
elif [ "-sleeping" = $2 ] && [ "-s" = $1 ]
then
	proc_sleeping

#if the user enters -s and -idle then show idle processes
elif [ "-idle" = $2 ] && [ "-s" = $1 ] 
then
        proc_idle

#if the user enters -s then show all processes
elif [ "-s" = $1 ] 
then
	proc_state
	

#restates usage if invalid arguments entered
else
	echo Usage: sudo $0 "[-argument 1]" "[-argument 2]"
	exit
fi
