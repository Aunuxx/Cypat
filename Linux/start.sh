#!/bin/bash

# simple shell script for debian/ubuntu hardening
# frin

# need to do:
# PAM
# Crontab
# Check sudoers
# rootkit
# apache
# unalias

# add help to list

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

on=false
out=false

# update help
help(){
    echo 
    echo -e "Usage: [option]"

    echo -e "\tShorthand\tLong Name\t\tDescription\t\t\t\tNon-Invasive?\tList?"

    echo -e "\t-m\t\t--minimal\t\tenables non-invasive changes\t\tYes"
    echo -e "\t-a\t\t--all\t\t\tall changes excluding list option"
    echo
    echo -e "\t-l\t\t--list\t\t\tenable all list options\t\t\tYes"
    echo
    echo -e "\t-f\t\t--firewall\t\ttoggle full firewall changes"
    echo -e "\t-u\t\t--full-update\t\ttoggle full update"
    echo -e "\t-t\t\t--telent\t\ttoggle telnet removal"
    echo -e "\t-s\t\t--ssh\t\t\ttoggle ssh removal"
    echo -e "\t-f\t\t--ftp\t\t\ttoggle ftp removal"
    echo -e "\t-M\t\t--malware\t\ttoggle malware removal"
    echo -e "\t-b\t\t--banned\t\ttoggle banned file listing\t\tYes\t\tYes"
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




while [ "${1:-}" != "" ]; do
    case "$1" in
        "-m" | "--minimal" )
            minimal
            on=true ;;

        "-a" | "--all" )
            all
            on=true ;;

        "-l" | "--list" )
            out=true
            on=true ;;

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


if [ "$on" = false ] 
then
    unalias -a #Get rid of aliases
    echo "unalias -a" >> ~/.bashrc
    echo "unalias -a" >> /root/.bashrc

    echo -e "\e[1mFirst time setup complete\e[m"
    echo -e "\e[1mRun with arguments\e[m"
fi


if [ "$on" = true ]
then
    sudo sysctl -w net.ipv4.tcp_syncookies=1
    sudo sysctl -w net.ipv4.ip_forward=0
    sudo sysctl -w net.ipv4.conf.all.send_redirects=0
    sudo sysctl -w net.ipv4.conf.default.send_redirects=0
    sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
    sudo sysctl -w net.ipv4.conf.default.accept_redirects=0
    sudo sysctl -w net.ipv4.conf.all.secure_redirects=0
    sudo sysctl -w net.ipv4.conf.default.secure_redirects=0
    sudo sysctl -p
fi


# normal update
if [ "$update" = false ]
then
    if [ "$on" = true ] 
        then
        apt-get update
        apt-get upgrade -y
    fi
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
    if [ "$on" = true ] 
    then
        apt-get install ufw
        systemctl start ufw
        ufw default deny
        ufw enable
    fi
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

# PAM
if [ "$pam" = true ]
then
    sudo sed -i '1 s/^/auth optional pam_tally.so deny=5 unlock_time=900 onerr=fail audit even_deny_root_account silent\n/' /etc/pam.d/common-auth
    sudo apt-get -y install libpam-cracklib
    sudo sed -i '1 s/^/password requisite pam_cracklib.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1\n/' /etc/pam.d/common-password
fi
# !PAM



#ps -ax | less


# list options


if [ true = true ] 
then
    echo -e "\e[1mbanned file types:\e[m"
    echo -e "\e[3mmp3 txt wav wma aac mp4 mov avi gif jpg png bmp img exe msi bat sh\e[m"

    for suffix in mp3 txt wav wma aac mp4 mov avi gif jpg png bmp img exe msi bat sh
    do
    sudo find /home -name *.$suffix
    done

    echo
    echo
    echo -e "\e[1mprocesses that are stopped and running\e[m"
    echo -e "\e[3mlook for [R]unning processes\e[m"
    echo -e "you can use 'man ps' to find other 'STAT' codes"

    ps -ax
fi | less -r