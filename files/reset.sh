#!/bin/bash

echo "Are you sure you want to erase cmdtaggr from your system?"
read input
case $input in 
yes|y)
	rm -rf ~/.cmdtaggr
        rm -rf files/tags
	sudo rm /usr/bin/cmdtaggr
	;;
*)
	exit
esac