#!/bin/bash

makeDepth(){

	until [ "$currDepth" -lt "0" ]; do

    	folderList=(`ls`)

    	# Represent breadth as number of folders in current folder
    	numFolders="${#folderList[@]}"

	    # If haven't reached max depth and can still make folders
	    # Make a folder, step into it
    	if [ "$currDepth" -lt "$depth" ] && [ "$numFolders" -lt "$breadth" ]; then

			# Increment counter for each folder name
			((folderNumber++))

			mkdir $folderNumber

			# Visit our new folder
			cd $folderNumber > /dev/null

			((currDepth++))

	    # If reached maximum depth but can still make folders
	    elif [ "$currDepth" -eq "$depth" ] && [ "$numFolders" -le "$breadth" ]; then

			# Go up one directory since can't make
			# more folders at max folder depth
			cd ../  > /dev/null

			((currDepth--))
	
    	# If reached maximum depth && can't make any more folders
	    else

			cd ../

			((currDepth--))

	    fi

	done

	exit 1
    
}

makeBreadth(){

    folderList=(`ls`)

    # Represent breadth as number of folders in current folder
    numFolders="${#folderList[@]}"

    # If haven't reached max breadth and depth, make folders recursively
    if [ "$numFolders" -lt "$breadth" ] && [ "$currDepth" -le "$currLevel" ]; then
	
		((folderNumber++))
		
		mkdir $folderNumber

		makeBreadth

    # If have reached max breadth but not max depth, cd into each folder recursively
    # Then step out of folder
    elif [ "$numFolders" -eq "$breadth" ] && [ "$currDepth" -le "$currLevel" ]; then

		for folder in ${folderList[@]}; do
		    
		    cd $folder

		    ((currDepth++))

		    makeBreadth

		    cd ../

		    ((currDepth--))

		done

    fi
    
}

breadthFirst(){

    # While not on the last level of the tree
    # call makeBreadth until we are
    while [ "$currLevel" -lt "$depth" ]; do

		makeBreadth
	
		((currLevel++))
	
    done
    
}

main(){

    if [ "${pathExtension}" == "depth" ]; then

		echo 

		echo "Creating depth-first directory tree at:"

		echo "   \"${path}-${pathExtension}\""

		echo

		makeDepth

    elif [ "${pathExtension}" == "breadth" ]; then

		echo 

		echo "Creating breadth-first directory tree at:"

		echo "   \"${path}-${pathExtension}\""

		echo

		breadthFirst

    else

		echo "The path name you entered is invalid"

    fi
    
}

# Initialize variables #
depth=$1
breadth=$2
path=$3
pathExtension=$4
currDepth=0
currBreadth=0
folderNumber=0
currLevel=0
numFolders=0

# Keeps folder tree in user-specified folder
mkdir "${path}-${pathExtension}"
cd "${path}-${pathExtension}"

# Run program
main
