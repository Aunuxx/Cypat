#!/bin/bash

# simple shell script for debian/ubuntu hardening
# frin

# need to do:
# PAM
# Crontab
# Check sudoers
# rootkit
# apache

if [ ! "$BASH_VERSION" ] ; then
    chmod +x "$0"
    echo "Execute directly '$0 --help' or use 'bash $0 --help'" 1>&2
    exit 1
fi


if [[ $EUID -ne 0 ]]
then
    echo "You must be root to run this script. run with sudo."
    exit 1
fi


help(){
    echo 
    echo -e "Usage: [option]"

    echo -e "\tShorthand\tLong Name\t\tDescription\t\t\t\tNon-Invasive?\t\tList?"

    echo -e "\t-m\t\t--minimal\t\tenables non-invasive changes\t\tYes"
    echo -e "\t-a\t\t--all\t\t\tall changes excluding list option"
    echo -e "\t-la\t\t--all-list\t\tall changes and list options"
    echo
    echo -e "\t-l\t\t--list\t\t\tenable options that output a list\tYes"
    echo
    echo -e "\t-f\t\t--firewall\t\ttoggle firewall changes"
    echo -e "\t-u\t\t--full-update\t\ttoggle full update"
    echo -e "\t-t\t\t--telent\t\ttoggle telnet removal"
    echo -e "\t-s\t\t--ssh\t\t\ttoggle ssh removal"
    echo -e "\t-f\t\t--ftp\t\t\ttoggle ftp removal"
    echo -e "\t-M\t\t--malware\t\ttoggle malware removal"
    echo -e "\t-b\t\t--banned\t\ttoggle banned file listing\t\tYes\t\t\tYes"
    echo
    exit 1 # Exit script after printing help
}


# set default in function, minimal
minimal(){
    firewall=false
    update=false
    telnet=false
    ssh=false
    ftp=false
    malware=false
    banned=false
}

minimal

all(){
    firewall=true
    update=true
    telnet=true
    ssh=true
    ftp=true
    malware=true
    banned=false
}
out(){
    banned=true
}



while [ "${1:-}" != "" ]; do
    case "$1" in
        "-m" | "--minimal" )
            minimal ;;

        "-a" | "--all" )
            all ;;

        "-l" | "--list" )
            out ;;

        "-la" | "--all-list" )
            all
            out ;;

        "-f" | "--firewall" ) 
            if [ "$firewall" = true ]
            then
            firewall=false
            elif [ "$firewall" = false ]
            then
                firewall=true
            else
                echo "err toggle"
            fi ;;

        "-u" | "--full-update" )
            if [ "$update" = true ]
            then
            update=false
            elif [ "$update" = false ]
            then
                update=true
            else
                echo "err toggle"
            fi ;;

        "-t" | "--telnet" )
            if [ "$telnet" = true ]
            then
            telnet=false
            elif [ "$telnet" = false ]
            then
                telnet=true
            else
                echo "err toggle"
            fi ;;

        "-s" | "--ssh" )
            if [ "$ssh" = true ]
            then
            ssh=false
            elif [ "$ssh" = false ]
            then
                ssh=true
            else
                echo "err toggle"
            fi ;;

        "-f" | "--ftp" )
            if [ "$ftp" = true ]
            then
            ftp=false
            elif [ "$ftp" = false ]
            then
                ftp=true
            else
                echo "err toggle"
            fi ;;

        "-M" | "--malware" )
            if [ "$malware" = true ]
            then
            malware=false
            elif [ "$malware" = false ]
            then
                malware=true
            else
                echo "err toggle"
            fi ;;

        "-b" | "--banned" )
            if [ "$banned" = true ]
            then
            banned=false
            elif [ "$banned" = false ]
            then
                banned=true
            else
                echo "err toggle"
            fi ;;

        "-h" | "--help" )
            help ;;
        * ) 
            echo "Invalid option: $1"
            help ;;
        \? )
            echo "? err"
            help ;;
    esac
    shift
done



unalias -a #Get rid of aliases
echo "unalias -a" >> ~/.bashrc
echo "unalias -a" >> /root/.bashrc



sudo sysctl -w net.ipv4.tcp_syncookies=1
sudo sysctl -w net.ipv4.ip_forward=0
sudo sysctl -w net.ipv4.conf.all.send_redirects=0
sudo sysctl -w net.ipv4.conf.default.send_redirects=0
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.default.accept_redirects=0
sudo sysctl -w net.ipv4.conf.all.secure_redirects=0
sudo sysctl -w net.ipv4.conf.default.secure_redirects=0
sudo sysctl -p



# normal update
if [ "$update" = false ]
then
apt-get update
apt-get upgrade
fi
# !normal update

# full update
if [ "$update" = true ]
then
    # Make sure to listen to what's happening. Something important might require your verification.
    sudo apt-get update
    sudo apt-get dist-upgrade -y
    sudo apt-get install -f -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y
    sudo apt-get check
fi
# !full update

# ufw
if [ "$firewall" = false ]
then
    apt-get install ufw
    systemctl start ufw
    ufw default deny
    ufw enable
elif [ "$firewall" = true ]
then
    apt-get remove ufw
    apt-get install ufw
    systemctl start ufw
    ufw default deny
    ufw enable
fi
# !ufw

# telnet
if [ "$telnet" = true ]
then
sudo apt-get purge telnet
fi
# !telnet

# ssh
if [ "$ssh" = true ]
then
    sudo apt-get -y purge openssh-server* 
fi
# !ssh

# ftp
if [ "$ftp" = true ]
then
    sudo apt-get -y purge vsftpd*
    fi
# !ftp

# malware
if [ "$malware" = true ]
then
    sudo apt-get -y purge hydra*
    sudo apt-get -y purge john* # John the Ripper, brute forcing software
    sudo apt-get -y purge nikto* # Website pentesting
fi
# !malware

# find banned file types
if [ "$banned" = true ]
then
    if [ "$banned" = true ]
    then
        for suffix in mp3 txt wav wma aac mp4 mov avi gif jpg png bmp img exe msi bat sh
        do
        sudo find /home -name *.$suffix
        done
    fi | less
fi
# !find banned file types

