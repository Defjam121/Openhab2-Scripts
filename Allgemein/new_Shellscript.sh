#!/bin/bash 
#title           :mkscript.sh
#description     :This script will make a header for a bash script.
#author          :bgw
#date            :20111101
#version         :0.4
#usage           :bash mkscript.sh
#notes           :Install Vim and Emacs to use this script.
#bash_version    :4.1.5(1)-release
#==============================================================================

today=$(date +%d-%m-%Y)
div=======================================

/usr/bin/clear

_select_title(){

    # Get the user input.
    printf "Titel: " ; read -r title

    # Remove the spaces from the title if necessary.
    title=${title// /_}

    # Convert uppercase to lowercase.
    title=${title,,}

    # Add .sh to the end of the title if it is not there already.
    [ "${title: -3}" != '.sh' ] && title=${title}.sh

    # Check to see if the file exists already.
    if [ -e $title ] ; then
        printf "\n%s\n%s\n\n" "The script \"$title\" already exists." \
        "Please select another title."
        _select_title
    fi

}

_select_title

printf "Beschreibung: " ; read -r dscrpt
printf "Dein Name: " ; read -r name
printf "Version?: " ; read -r vnum

# Format the output and write it to a file.
printf "%-16s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%s\n\n\n" '#!/bin/bash -' '#SCRIPT:' ":$title" '#description' \
":${dscrpt}" '#AUTOR:' ":$name" '#DATE' ":$today" '#REV' \
":$vnum" '#USAGE' ":./$title" '#NOTES' ':' '#BASH_VERSION' \
":${BASH_VERSION}" \#$div${div} > $title

# Make the file executable.
chmod +x $title

/usr/bin/clear

_select_editor(){

    # Select between Vim or Emacs.
    printf "%s\n%s\n%s\n\n" "Select an editor." "1 for Vim." "2 for Emacs."
    read -r editor

    # Open the file with the cursor on the twelth line.
    case $editor in
        1) vim +12 $title
            ;;
        2) emacs +12 $title &
            ;;
        *) /usr/bin/clear
           printf "%s\n%s\n\n" "I did not understand your selection." \
               "Press <Ctrl-c> to quit."
           _select_editor
            ;;
    esac

}

_select_editor
