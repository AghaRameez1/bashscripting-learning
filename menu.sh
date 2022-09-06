#!/bin/sh
show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${menu} Show top 10 process by Memory Cossumption ${normal}\n"
    printf "${menu}**${number} 2)${menu} Show top 10 process by CPU utilization ${normal}\n"
    printf "${menu}**${number} 3)${menu} Show System HDD ${normal}\n"
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
            ps -eo pid,ppid,cmd,comm,%mem,%cpu --sort=-%mem | head -10
            show_menu;
        ;;
        2) clear;
            option_picked "Option 2 Picked";
            ps -eo pid,ppid,cmd,comm,%mem,%cpu --sort=-%cpu | head -10
            
            show_menu;
        ;;
        3) clear;
            option_picked "Option 3 Picked";
            df -h
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
