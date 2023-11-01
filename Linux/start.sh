#!/bin/sh

# simple shell script for linux hardening
# Frin

# recomended to run as root 'su -' or sudo


help()
{
    echo 
    echo "Usage: [option]"
    echo "\t-m, --minimal"
    echo "\t-a, --all"
    echo "\t--firewall-false"
    echo
    echo "Description:"
    echo "\t-m,\t\t\t minimal changes, should not be invasive"
    echo "\t-a,\t\t\t all changes"
    echo "\t--firewall-false\t do not modify firewall"
    exit 1 # Exit script after printing help
}



while [ "${1:-}" != "" ]; do
    case "$1" in
        "-m" | "--minimal" )
            firewall="FALSE" ;;

        "-a" | "--all" )
            firewall="TRUE" ;;

        "--firewall-false" ) 
            firewall="FALSE" ;;

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




apt update

apt upgrade



# ufw

if  [ "$firewall" = "TRUE" ]
then
    apt remove ufw

    apt install ufw

    systemctl start ufw

    ufw default deny

    ufw enable
fi

# !ufw

