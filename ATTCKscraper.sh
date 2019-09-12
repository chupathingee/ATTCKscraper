#!/bin/bash

##############################################################################
# Script Name	:ATTCKscraper.sh                                                                                              
# Description	:Scrapes ATT&CK website for technique and returns desired info                                                                                 
# Args          :ATT&CK technique id, eg. T0001                                                                                           
# Author       	:Matt Brenton                                                
# GitHub URL   	:github.com/chupathingee                                           
##############################################################################


# Check for technique ID

if [ "$1" = "" ]; then 
	echo "ERROR: this script must be run followed by a technique ID, eg ./ATTCKscraper.sh T0001"; exit
else
	echo "
=========================
Scraping ATT&CK for $1
========================="
fi

# Download technique page using wget

wget -q https://attack.mitre.org/techniques/$1; 

# Parse and print description

echo "
-------------------------
Description
-------------------------"
cat $1 | grep -A 1 '<div class="col-md-8 description-body">' | tail -n 1 | sed -e 's/<[^>]*>//g' | sed -e 's/\[[^\]]*\]//g' | sed -e 's/^\W*//g'

# Parse and print platform(s)

echo "
-------------------------
Platform(s):
-------------------------"
cat $1 | grep 'Platform:&nbsp;</span>' | cut -f4 -d'>' | cut -f1 -d'<'

# Parse and print permissions required

echo "
-------------------------
Permissions Required:
-------------------------"
cat $1 | grep 'Permissions Required:&nbsp;</span>' | cut -f4 -d'>' | cut -f1 -d'<'

# Parse and print data sources

echo "
-------------------------
Data Sources:
-------------------------"
cat $1 | grep 'Data Sources:&nbsp;</span>' | cut -f4 -d'>' | cut -f1 -d'<'

# Parse and print examples in format groups | software

echo "
-------------------------
Examples:
-------------------------"
echo "Groups:" $(cat $1 | grep '<a href="https://attack.mitre.org/groups/' | cut -f2 -d'>' | cut -f1 -d'<' | sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}') "| Software:" $(cat $1 | grep '<a href="https://attack.mitre.org/software/' | cut -f2 -d'>' | cut -f1 -d'<' | sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}')

# Cleanup and exit

rm $1*; exit
