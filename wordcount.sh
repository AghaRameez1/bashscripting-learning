#!/bin/sh
show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${menu} Total Characters${normal}\n"
    printf "${menu}**${number} 2)${menu} Total Words ${normal}\n"
    printf "${menu}**${number} 3)${menu} Total 5 duplicated words (repeated words) ${normal}\n"
    printf "${menu}**${number} 4)${menu} Top 5 longest character words (with respect to length)${normal}\n"
    printf "${menu}**${number} 5)${menu} Capital Letter Count${normal}\n"
    printf "${menu}**${number} 6)${menu} Small Letter Count${normal}\n"
    printf "${menu}*********************************************${normal}\n"
    printf "Please enter a menu option and enter or ${fgred}x to exit. ${normal}"
    read opt
}

option_picked(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}

clear
show_menu
while [ $opt != '' ]
    do
    if [ $opt = '' ]; then
      exit;
    else
      case $opt in
        1) clear;
            option_picked "Option 1 Picked";
            awk 'BEGIN{FS=""}{for(i=1;i<=NF;i++)c++}END{print "total chars:"c}' data.txt
            show_menu;
        ;;
        2) clear;
            option_picked "Option 2 Picked";
            data=$(wc -l data.txt)
            echo "Total Words:${data}"
            show_menu;
        ;;
        3) clear;
            option_picked "Option 3 Picked";
            data=$(tr -c '[:alnum:]' '[\n*]' < data.txt | sort | uniq -c | sort -nr | head  -10)
            echo "List of duplicated words: ${data}"  
            show_menu;
        ;;
        4) clear;
            option_picked "Option 4 Picked";
            longest=0
            for word in $(cat data.txt)
            do
                len=${#word}
                if [ $len -gt $longest ]
                then
                    longest=$len
                    longword=$word
                fi
            done
            printf 'The longest word is %s and its length is %d.\n' "$longword" "$longest";
            show_menu;
        ;;
        5) clear;
            option_picked "Option 5 picked";
            data=$(grep -o '[[:upper:]]' data.txt | wc -l)
            echo "Total Capital Letter count: ${data}";
            show_menu;
        ;;
        6) clear;
            option_picked "Option 6 picked";
            data=$(grep -o '[[:lower:]]' data.txt | wc -l)
            echo "Total Small Letter count: ${data}";
            show_menu;
        ;;
        x)exit;
        ;;
        \n)exit;
        ;;
        *)clear;
            option_picked "Pick an option from the menu";
            show_menu;
        ;;
      esac
    fi
done
