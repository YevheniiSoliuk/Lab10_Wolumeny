#!/bin/bash
sleep 60
now=$(date)
mem=$(sed -n "2p" /proc/meminfo)
echo "Data utworzenia: $now" > info.log
echo "Dostepna pamiec: $mem" >> info.log