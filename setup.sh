#!/bin/bash

realuser=$(who | awk 'NR==1{print $1}')

if [[ ! $(whoami) = "root" ]]; then
    echo "Please run this script using sudo or as root."
    exit 1
fi

if [[ "$#" -ne 1 ]] || ! ([[ "$1" = "install" ]] || [[ "$1" = "uninstall" ]]); then
    echo "Invalid usage!"
    echo "Correct usage: $0 install|uninstall (Reinstalling updates the program to the latest version)"
    exit 1
fi

if [[ "$1" = "uninstall" ]]; then
    echo "Uninstalling crt.sh!"
    read -p "Are you sure? [y/N] : " userinput

    case $userinput in
      y|Y) rm -rf /usr/bin/crt.sh; \
      rm -rf /usr/share/licenses/crt.sh; \
      sleep 1; \
      echo "crt.sh uninstalled successfully!";;
      *) echo "Aborting!"; exit 1;;
    esac
elif [[ "$1" = "install" ]]; then
    echo "Updating local repository..."
    sudo -u $realuser git pull origin main

    echo ""
    read -p "Are you sure you want to install (and update) crt.sh? [y/N] : " userinput

    case $userinput in
      y|Y) sudo install -Dm755 crt.sh /usr/bin/crt.sh; \
        sudo install -Dm644 LICENSE /usr/share/licenses/crt.sh/LICENSE; \
        sleep 1; \
        echo "crt.sh installed and updated successfully!";;
      *) echo "Aborting installation!"; exit 1;;
    esac
fi