#!/bin/bash

function string_finder() {
    echo ""
	echo "STRING FINDER"
    echo "-------------"
	echo "What string are you looking for?"
    read searched_str
    echo "ocurring more then how many times in the file?"
    read number_of_times
        for file in $( ls ); do
            i=1
            count=0
                while read line; do
                    if [[ "$line" == *"$searched_str"* ]]; then
                        ((count++))
                    fi
                i=$((i+1))  
                done < $file
            if [ $count -gt $number_of_times ]; then
                echo "F O U N D:"
                echo "$file | $count"
            fi
        done
}

function mismatch_finder() {
    echo ""
	echo "MISMATCH FINDER"
    echo "-------------"
	echo "This script lists files where server_name is different then file (domain) name"
    #read searched_str
    #echo "ocurring more then how many times in the file?"
    #read number_of_times
        for file in $( ls ); do
        FILE_NAME=$file
        DOMAIN=${FILE_NAME%.conf}
        SERVER="$(grep -m 1 "server_name" $FILE_NAME)" #getting file name
        SERVER2=${SERVER//[[:blank:]]/}                #removing spaces, tabs
        SERVER3=${SERVER2:11}                          #removing server_name string
        SERVER4=${SERVER3%;}                           #removing ; from the end
        if [[ "$FILE_NAME" == *".conf" ]] && ! grep -q "$DOMAIN" <<< "$SERVER" && [[ "$FILE_NAME" != "template.conf" ]]; then
        echo "MISMATCH: $DOMAIN | $SERVER"
        echo "$SERVER"
        echo "$SERVER2"
        echo "$SERVER3"
        echo "$SERVER4"

        fi
        done
}

function file_set_gen() {
	echo "FILES GENERATOR"
    echo "---------------"
    echo "This script is to generate new set of nginx configs in new_set folder nested in current folder which is:"
    echo $(pwd)
    echo "based on provided template within the folder"
    echo "What cluster?"
    read CLUSTER
    mkdir new_set
    #looping
    for file in $( ls ); do
        FILE_NAME=$file
        if [[ "$FILE_NAME" == *".conf" ]]; then
            echo "Generating file for $FILE_NAME"
            variable="$(grep -m 1 "server_name" $FILE_NAME)"
            DOMAIN=${FILE_NAME%.conf}
            echo "$DOMAIN"
            SSL_CERT=$(grep -m 1 "ssl_certificate" $FILE_NAME)
            SSL_CERT_KEY=$(grep -m 1 "ssl_certificate_key" $FILE_NAME)
            SERVER="$(grep -m 1 "server_name" $FILE_NAME)" #getting file name
            SERVER2=${SERVER//[[:blank:]]/}                #removing spaces, tabs
            SERVER3=${SERVER2:11}                          #removing server_name string
            SERVER_NAME=${SERVER3%;}                       #removing ; from the end
            echo "$SSL_CERT"
            echo "$SSL_CERT_KEY"
            echo "$SERVER_NAME"
            cat template.conf > new_set/$file
            sed -i '' "s/{{SERVER_NAME}}/$SERVER_NAME/g" "new_set/$file"
            sed -i '' "s/{{DOMAIN}}/$DOMAIN/g" "new_set/$file"
            sed -i '' "s|{{SSL_CERTIFICATE}}|$SSL_CERT|" "new_set/$file"
            sed -i '' "s|{{SSL_CERTIFICATE_KEY}}|$SSL_CERT_KEY|" "new_set/$file"
            sed -i '' "s|{{CLUSTER}}|$CLUSTER|" "new_set/$file"

        fi 
    done
    echo "---------------------------------------"
    echo "New set of conf files has been generated and stored in subfolder new_set"
    echo "If you want to replace original files with new set use option 3 !!"
}

function replace_files() {
    echo ""
	echo "REPLACING FILES"
    echo "---------------"
    echo "This script will move old files to backup folder and replace them with the newly created set"
    echo "Are you sure you want to replace the files? (y/n)"
    read DECISION
    if [[ "$DECISION" == "y" ]]; then
        echo "Replacing the files to make them ready to be pushed to repo"
        mkdir backup
        mv *.conf backup
        cd new_set
        mv *.conf ..
        cd ..
        echo "Files have been replaced. Branch ready for add, commit and push"
        echo "If you are not happy with the new set and want to start the process again"
        echo "Use option 4 to rollback all changes"
    else
        echo "Files have not been replaced, branch is not ready to push"
    fi
}

function files_rollback() {
	echo "FILES ROLLBACK"
	echo "--------------"
    echo "This script will move original files back to main folder and newly created set to folder new_set"
    echo "Are you sure you want to rollback ? (y/n)"
    read DECISION
    if [[ "$DECISION" == "y" ]]; then
        echo "Rolling back the original files to main folder and new set to folder new_set"
        mv *.conf new_set
        cd backup
        mv *.conf ..
        cd ..
        rm -d backup
        rm -r new_set
        echo "Files have been rolled back. Folder is back to original state"
        echo "-------------------------------------------------------------"
        echo "DO NOT USE OPTION 3 OR 4 UNTIL YOU USE OPTION 2 FIRST !"
    else
        echo "Files have not been rolled back"
    fi
}

##
# Color  Variables
##
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

##
# Color Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}

menu(){
echo -ne "
   Nginx conf files generator
-----------------------------------
$(ColorGreen '1)') String finder
$(ColorGreen '2)') Files generator
$(ColorGreen '3)') Files crossover
$(ColorGreen '4)') Files rollback
$(ColorGreen '5)') Server names mismatch finder
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) string_finder ; menu ;;
	        2) file_set_gen ; menu ;;
	        3) replace_files ; menu ;;
	        4) files_rollback ; menu ;;
            5) mismatch_finder ; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; menu;;
        esac
}

# Call the menu function
menu