#!/bin/bash

#target=

count=$(ping -c 1 10.31.27.157 | grep icmp* | wc -l)

if [ $count -eq 0 ]
then

    echo "Not alive"

else

    echo "Alive"

fi
