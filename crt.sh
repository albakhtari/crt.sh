#!/usr/bin/env bash

# Version
version="1.1"

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

print_error()
{
    echo -e "\n${red}ERROR:${reset} ${bold}$1${reset} \n"
    exit 1
}

# Make sure `gron` is installed
if ! [[ $(which gron 2> /dev/null) ]]; then
    print_error "'gron' is required but not installed!"
    exit 1
fi

help() {
    echo "${yellow}Description:${reset} Pull all subdomains of domain/organization from ${bold}https://crt.sh${reset}"
    echo "${yellow}Usage:${reset} cert.sh [OPTIONS]..."
    echo "${yellow}Version:${reset} $version"
    echo ""
    echo "${magenta}-t${reset} | ${magenta}-target${reset} domain.com | \"organization inc\"          Target domain/organization"
    echo "${magenta}-o${reset} | ${magenta}-output${reset} <path to output file>                    Path to output file"
    echo "${magenta}-h${reset} | ${magenta}-help${reset}                                            ${bold}Standalone:${reset} Print this help message"
    echo "${magenta}-u${reset} | ${magenta}-update${reset} <path to crt.sh local repo>              ${bold}Standalone:${reset} Update crt.sh to latest version"
    echo "${magenta}-v${reset} | ${magenta}-version${reset}                                         ${bold}Standalone:${reset} Print version"
    echo ""
    echo ""
}

# Get those subdomains!
get_subdomains() {
    target="$1"
    output="$2"

    if [[ "$output" ]]; then
        # Curl the JSON version of query results   | Make JSON grepable | Get url Parameter | Extract URL |  Remove unneeded symbols | sort & delete dupes | Print to output file
        curl -s "https://crt.sh/?q=${target}&output=json" | gron | grep common.name | cut -d ' ' -f 3 | sed -e "s/\"//g" -e "s/;//g" | sort -u | tee "$output"
    else
        curl -s "https://crt.sh/?q=${target}&output=json" | gron | grep common.name | cut -d ' ' -f 3 | sed -e "s/\"//g" -e "s/;//g" | sort -u
    fi
}

flags() {

    # Make sure arguments are parsed
    if [[ "$#" -eq 0 ]]; then
        print_error "Missing arguments, parse \"-help\" for more information"
        exit 1
    fi

    while [[ "$1" != "" ]]
    do
        case $1 in
            -h|-help) # Print help message
                help
                exit
                ;;
            -v|-version) # Print version
                echo "crt.sh v$version"
                exit
                ;;
            -u|-update) # Update crt.sh script
                if [[ "$2" ]]; then
                    shift  
                    if [[ -d "$1" && $(basename $1) = *"crt.sh"* ]]; then
                        cd $1
                        printMessage "Updating 'crt.sh'"
                        sudo ./setup.sh install
                        cd - &> /dev/null
                        shift
                    else
                        print_error "\"-u|-update\" requires a path to the local crt.sh repository"
                    fi
                fi
                exit
                ;;
            -t|-target) # Define the target domain/organization
                if [ "$2" ]; then
                    shift
                    target="$1"
                else
                    print_error "\"-t|-target\" requires a non-empty argument"
                    exit 1
                fi
                ;;
            -o|-output) # Define output file
                if [[ "$2" && -d $(dirname "$2") && ! -d "$2" ]]; then # Make sure that a directory is given and not a file
                    shift
                    output="$1"
                else
                    print_error "\"-o|-output\" requires a valid path for a file"
                    exit 1
                fi
                ;;
            -?*) # Invalid flags
                print_error "Unknown flag: $1"
                exit 1
                ;;
            *)
                break
                ;;
        esac
        shift
    done

    if [[ ! "$target" ]]; then # If target is missing error out
        print_error "Missing arguments, parse \"-help\" for more information"
        exit 1
    fi
}



flags "$@" # Handle all flags
get_subdomains "$target" "$output"