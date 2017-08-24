#!/bin/sh

processName="/usr/sbin/httpd"
interval=5

while true
do
    isAlive=`ps -ef | grep "$processName" | grep -v grep | grep -v srvchk | wc -l`
    if [ $isAlive = 1 ]; then
        echo "php is running."
    else
        sleep $interval
        isAlive=`ps -ef | grep "$processName" | grep -v grep | grep -v srvchk | wc -l`
        if [ $isAlive = 0 ]; then
            echo "php is stopped. Stopping supervisor..."; /usr/bin/supervisorctl shutdown
        else
            echo "Server is running,"
        fi
    fi
    sleep $interval
done
