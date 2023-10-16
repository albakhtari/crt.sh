#!/usr/bin/env bash

# Colours + Formatting
red=$'\e[31m'
yellow=$'\e[93m'
blue=$'\e[34m'
magenta=$'\e[35m'
bold=$'\e[1m'
underline=$'\e[4m'
reset=$'\e[0m'

# Version
version="1.4"

print_error()
{
    echo -e "${red}ERROR:${reset} ${bold}$1${reset}"
    exit 1
}

print_message() 
{
    echo -e "\n    ${blue}[+]${reset}${bold} $1${reset} \n"
}

help() {
    echo "${bold}${yellow}Description:${reset} Pull all subdomains of domain/organization from ${underline}https://crt.sh${reset}"
    echo "${bold}${yellow}Usage:${reset} $0 [OPTIONS]..."
    echo "${bold}${yellow}Version:${reset} $version"
    echo ""
    echo "${magenta}-t${reset} | ${magenta}-target${reset} <domain.com | ${blue}\"organization inc\"${reset}>        Target domain/organization"
    echo "${magenta}-o${reset} | ${magenta}-output${reset} <path/to/output/file>                    Path to output file"
    echo "${magenta}-u${reset} | ${magenta}-update${reset} <path/to/repo/crt.sh/>                    ${bold}Standalone:${reset} Update crt.sh to latest version"
    echo "${magenta}-h${reset} | ${magenta}-help${reset}                                            ${bold}Standalone:${reset} Print this help message"
    echo "${magenta}-v${reset} | ${magenta}-version${reset}                                         ${bold}Standalone:${reset} Print version"
}

# Get those subdomains!
get_subdomains() {
    target="$1"
    output="$2"
    # Curl the JSON version of query results | get 'name_value' parameter | sort & delete dupes | Print to output file (if exists)
    curl -s "https://crt.sh/?q=${target}&output=json" | jq -r .[].name_value | sort -u | tee $output
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
                        print_message "Updating 'crt.sh'"
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