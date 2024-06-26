#!/bin/bash
# setting variables
run=1
#opening prompt
while [[ $run == 1 ]]; do
	input=1
	clear
	echo "Welcome to cmdtaggr!"
	echo "Please choose an action from the following options:"
	echo "c) Create a new tag"
	echo "l) Print a list of existing tags"
	echo "f) List the files in a tag"
	echo "s) Search within a tag"
	echo "a) Add files to an existing tag"
	echo "r) Remove files from a tag"
	echo "d) Delete a tag"
	echo "e) Exit the program"
	while [[ $input == 1 ]]; do
		read choice
		case $choice in 
			c)
				echo "What should the tag be named?"
				read tagname
				touch ~/.cmdtaggr/tags/$tagname
				echo "What files should be included in this tag?"
				echo "Provide full paths to the files followed by hitting ENTER"
				echo "Enter "EXIT" when you are finished"
				c=1
				while [[ $c == 1 ]]; do
					read file
					if [[ $file == EXIT ]]; then
						c=0
					else
						inode=$(ls -li $file | awk 'NR==1{print $1}')
						echo $inode >> $tgdr/$tagname
					fi
				done
				read -p "Tag $tagname successfully created!"
				input=0
			;;
			l)
				ls -p ~/.cmdtaggr/tags | grep -v /
				read -p "Press ENTER to continue"
				input=0
			;;
			f)
				echo "Which tag?"
				read tagname
				for line in $(cat $tgdr/$tagname); do
				  sudo debugfs -R "ncheck $line" $homesys >> ~/.cmdtaggr/fl 2> /dev/null
				done
				awk 'NR % 2 != 1{print $2}' ~/.cmdtaggr/fl
				if [[ $keepfl == 0 ]]; then 
					rm ~/.cmdtaggr/fl
				elif [[ $keepfl == 1 ]]; then
					mv ~/.cmdtaggr/fl $tgdr/fl/$2
				else
					rm ~/.cmdtaggr/fl 
					echo The keepfl value in config.sh is improperly configured.
					echo Please ensure that it is set to either 1 or 0
					echo By default, the file has been removed.
				fi	
				read -p "Press ENTER to continue"
				input=0
			;;
			s)
				echo "Which tag?"
				read tagname
					for line in $(cat $tgdr/$tagname); do
				    sudo debugfs -R "ncheck $line" $homesys >> ~/.cmdtaggr/fl 2> /dev/null
				done
				awk 'NR % 2 != 1{print $2}' ~/.cmdtaggr/fl >> ~/.cmdtaggr/fls
				rm ~/.cmdtaggr/fl
				echo "Enter your search query"
				read sinclair
				grep "$sinclair" ~/.cmdtaggr/fls
				rm ~/.cmdtaggr/fls
			;;
			a)
				echo "What tag would you like to add to?"
				read tagname
				echo "What files should be included in this tag?"
				echo "Provide full paths to the files followed by hitting ENTER"
				echo "Enter "EXIT" when you are finished"
				c=1
				while [[ $c == 1 ]]; do
					read file
					if [[ $file == EXIT ]]; then
						c=0
					else
						inode=$(ls -li $file | awk 'NR==1{print $1}')
						echo $inode >> $tgdr/$tagname
					fi
				done
				input=0
			;;
			r)
				echo "What tag would you like to remove files from?"
				read tagname
				echo "What files should be removed from this tag?"
				echo "Provide full paths to the files followed by hitting ENTER"
				echo "Enter "EXIT" when you are finished"
				c=1
				while [[ $c == 1 ]]; do
					read file
					if [[ $file == EXIT ]]; then
						c=0
					else
						inode=$(ls -li $file | awk 'NR==1{print $1}')
						sed -i "/$inode/d" $tgdr/$tagname      
					fi
				done
				input=0
			;;
			d)
				echo "Which tag would you like to remove?"
				read rmtag
				rm $tgdr/$rmtag
				input=0
			;;
			e)
				exit
			;;
			*)
				echo "Invalid input"	
			;;
		esac
	done
done