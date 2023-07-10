#!/usr/bin/env bash

# Version
version="1.0.1"

# Some colours:
red=$'\e[1;31m'
yellow=$'\e[1;93m'
bold=$'\e[1m'
reset=$'\e[0m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
green=$'\e[1;32m'
cyan=$'\e[1;36m'
white=$'\e[0m'
underline=$'\e[21m'

# Test colours

# echo "
# ${underline}underline
# ${reset}${bold}bold${reset}
# ${red}red
# ${yellow}yellow
# ${blue}blue
# ${magenta}magenta
# ${green}green
# ${cyan}cyan
# ${white}white
# "

# Some shapes
rarrow="${blue}==>${reset}"                                   # ==>
larrow="${blue}<==${reset}"                                   # <==
error="${bold}[${red}+${reset}${bold}] ${red}ERROR:${reset}"  # [+] ERROR: 

# Make sure `gron` is installed
if ! [[ $(which gron 2> /dev/null) ]]; then
    echo "$error 'gron' is required but not installed!"
    exit 1
fi

help() {
    echo ""
    echo "=========================${rarrow} ${bold}crt.sh v${version}${reset} ${larrow}========================="
    echo " Pull down all subdomains of domain/organization from ${underline}https://crt.sh${reset}"
    echo ""
    echo " By: Mr. Misconception (${blue}@MisconceivedSec${reset}: GitHub, Discord, Twitter...)"
    echo "======================================================================="
    echo ""
    echo "${blue}Usage:${reset} ${green}crt.sh${reset} [OPTIONS...]"
    echo ""
    echo "${blue}Options:${reset}"
    echo ""
    echo "    ${magenta}-h -help${reset}                                            Print this help message"
    echo "    ${magenta}-u -update${reset} <path to crt.sh cloned repo>             Update crt.sh to latest version"
    echo "    ${magenta}-t -target${reset} domain.com | \"organization inc\"          Target domain/organization"
    echo "    ${magenta}-o -output${reset} <path to output file>                    Path to output file"
    echo ""
}

# Get those subdomains!
get_subdomains() {
    target="$1"
    output="$2"

    if [[ "$output" ]]; then
        curl -s "https://crt.sh/?q=${target}&output=json" | gron | grep common.name | cut -d ' ' -f 3 | sed -e "s/\"//g" -e "s/;//g" | sort -u | tee "$output"
    else
        curl -s "https://crt.sh/?q=${target}&output=json" | gron | grep common.name | cut -d ' ' -f 3 | sed -e "s/\"//g" -e "s/;//g" | sort -u
    fi
}

flags() {

    # Make sure arguments are parsed
    if [[ "$#" -eq 0 ]]; then
        echo "$error Missing arguments, parse \"-help\" for more information"
        exit 1
    fi

    while [[ "$1" != "" ]]
    do
        case $1 in
            -h|-help)
                help
                exit
                ;;
            -u|-update)
                if [[ "$1" || ! -d "$1" || $(ls "$1" | grep crt.sh) ]]; then
                    shift
                    cd $1
                    sudo ./setup.sh install
                    cd - &> /dev/null
                else
                    echo "$error \"-u|-update\" requires a non-empty argument"
                    exit 1
                fi

                exit
                ;;
            -t|-target)
                if [ "$2" ]; then
                    shift
                    target="$1"
                else
                    echo "$error \"-t|-target\" requires a non-empty argument"
                    exit 1
                fi
                ;;
            -o|-output)
                if [[ "$2" && -d $(dirname "$2") && ! -d "$2" ]]; then
                    shift
                    output="$1"
                else
                    echo "$error \"-o|-output\" requires a valid path for a file"
                    exit 1
                fi
                ;;
            -?*) # Invalid flags
                echo "$error Unknown flag: $1"
                exit 1
                ;;
            *)
                break
                ;;
        esac
        shift
    done

    if [[ ! "$target" ]]; then
        echo "$error Missing arguments, parse \"-help\" for more information"
        exit 1
    fi
}



flags "$@"
get_subdomains "$target" "$output"