#!/bin/bash

#Kevin Sanaycela

#Description: this code will take the username and email of the user and log into Github remotely. It then asks the user 
#for the name of the file in their local repo and pushes it onto the main branch if no sensitive info is detected.

#Gathering user information for the GitHub session
echo "Welcome! Please enter your name/desired username: "
read name
echo "Please enter your email address: "
read email 

git config --global user.name "$name"
git config --global user.email "$email"

#Gathering the name of the file that the user would like to commit 
echo "Thank you! Enter the name of the file in your local directory you'd like to commit, with the extension: " 
read file_name


#If the file that the user inputtede actually exists, run through the script. Else, send user an error message.
if [ -f $file_name ] ;
then
	echo "Would you like to add and commit the files currently in your local directory? (Yes/No) "
	read user_answer 

	ans=$(echo $user_answer | cut -c 1 | tr [:upper:] [:lower:] )

	#If user would like to push the file into Github
	if [ $ans = "y" ];
	then
        	#Regex conditional for phone number and social security 
        	if [[ $(grep -c '\(([0-9]\{3\})\|[0-9]\{3\}\)[ -]\?[0-9]\{3\}[ -]\?[0-9]\{4\}' $file_name) -eq 0 &&
             	$(grep -c '[0-9]\{3\}-\{0,1\}[0-9]\{2\}-\{0,1\}[0-9]\{4\}' $file_name) -eq 0 ]];
        	then
                	#pushes the file if no sensitive information found 
                	git add $file_name
                	git commit -am.
                	git push
        	else
                	echo "We did not push $file_name to the main repo because sensitive information was detected."
        	fi
	fi
else
	echo "It appears that $file_name does not exist in your local repo. Please rerun the script again with a file that exists."
fi
