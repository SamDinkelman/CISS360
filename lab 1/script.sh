#!/bin/bash

#	Important Errors and failures log script
#	by Sam Dinkelman
#	01/18/2019
#This script will search through the system logs for any logs that contain
#failed, Failed, WARNING, failed:, error, error:, ERROR, Error:
#when it finds any of these it will print them to the terminal
#then it will copy all of the log files from /var/log/ to another folder
#in $HOME/backup_logs so that the logs are backed up.
#I decided after some testing to add functionality for older log files too 

echo "Would you like to look at old log file too? [Yes/No]"

read answer

#These are the syslog files I found in my system, your system may have more or less depending
log_array=("/var/log/syslog" "/var/log/syslog.1")

#These are the syslog files that were zipped and would only open with zcat
zipped_log_array=("/var/log/syslog.2.gz" "/var/log/syslog.3.gz" "/var/log/syslog.4.gz" "/var/log/syslog.4.gz" "/var/log/syslog.5.gz" "/var/log/syslog.6.gz" "/var/log/syslog.7.gz")

if [[ $answer = "no" ]] || [[ $answer = "No" ]]
then
	#Searches for keywords in the syslog files
	for i in ${log_array[@]}
	do 
		cat $i | grep failed
		cat $i | grep Failed 
		cat $i | grep WARNING 
		cat $i | grep failed: 
		cat $i | grep error
		cat $i | grep error: 
		cat $i | grep ERROR
		cat $i | grep Error:
	done
#Searches for keywords in the zipped syslog files
elif [[ $answer  = "yes" ]] || [[ $answer = "Yes" ]] 
then
	for x in ${zipped_log_array[@]}
	do
        	zcat $x | grep failed
        	zcat $x | grep Failed 
        	zcat $x | grep WARNING 
        	zcat $x | grep failed: 
        	zcat $x | grep error
        	zcat $x | grep error: 
        	zcat $x | grep ERROR
        	zcat $x | grep Error:
	done
else
	echo Please enter Yes or No
	sudo ./script.sh
fi

#Creates a directory in your home folder if it does not already exist 
#if it does exist it will do nothing
if [ -d $HOME/backup_logs ];
then
	: 
else 
	mkdir $HOME/backup_logs
fi

#This function will copy the files in the log folder into the directory we just created 
backup_logs(){ 
	cp -r /var/log/* $HOME/backup_logs
}

backup_logs
