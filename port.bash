#!/bin/bash
#
# A template for creating command line scripts taking options, commands
# and arguments.
#
# Exit values:
#  0 on success
#  1 on failure
#



# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"



#
# Message to display for usage and help.
#
function usage
{
    local txt=(
"Utility $SCRIPT for doing stuff."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  command1             Demo of command."
"  command2 [anything]  Demo of command using arguments."
"  calendar [events]    Print out current calendar with(out) events."
""
"Options:"
"  --help, -h     Print help."
"  --version, -h  Print version."
    )
    
    printf "%s\n" "${txt[@]}"
}



#
# Message to display when bad usage.
#
function badUsage
{
    local message="$1"
    local txt=(
"For an overview of the command, execute:"
"$SCRIPT --help"
    )
    
    [[ $message ]] && printf "$message\n"

    printf "%s\n" "${txt[@]}"
}



#
# Message to display for version.
#
function version
{
    local txt=(
"$SCRIPT version $VERSION"
    )

    printf "%s\n" "${txt[@]}"
}



#
# Function for taking care of specific command. Name the function as the
# command is named.
#
function app-view
{
    local user="$1";

    if [[ $user ]]; then
        sqlite3 --column port.sqlite "SELECT server, port FROM Port WHERE owner=\"$user\";"
    else
        sqlite3 --column port.sqlite "SELECT server, port, owner FROM Port;"
    fi
}



#
# Function for taking care of specific command. Name the function as the
# command is named.
#
function app-allocate
{
    local user="$1";

    if [[ ! $user ]]; then
        badUsage "Missing username."
        exit 1
    fi

    local hasPort=$( app-view "$user" )
    if [[ $hasPort ]]; then
        echo "You have already allocated ports."
        exit 1
    fi

    sqlite3 port.sqlite "UPDATE Port SET owner = \"$user\" WHERE id IN ((SELECT MIN(port) FROM Port WHERE owner IS NULL));"
}



#
# Function for taking care of specific command. Name the function as the
# command is named.
#
function app-get
{
    local user="$1";

    if [[ ! $user ]]; then
        badUsage "Missing username."
        exit 1
    fi

    local port=$( sqlite3 --column port.sqlite "SELECT port FROM Port WHERE owner=\"$user\";" )

    if [[ $port ]]; then
        echo $port
        exit 0
    fi

    sqlite3 port.sqlite "UPDATE Port SET owner = \"$user\" WHERE port = (SELECT MIN(port) FROM Port WHERE owner IS NULL);"

    port=$( sqlite3 --column port.sqlite "SELECT port FROM Port WHERE owner=\"$user\";" )

    if [[ $port ]]; then
        echo $port
        exit 0
    fi

    exit 2
}



#
# Process options
#
while (( $# ))
do
    case "$1" in

        --help | -h)
            usage
            exit 0
        ;;

        --version | -v)
            version
            exit 0
        ;;

        view             \
        | allocate       \
        | get            \
        | calendar)
            command=$1
            shift
            app-$command $*
            exit 0
        ;;
        
        *)
            badUsage "Option/command not recognized."
            exit 1
        ;;
        
    esac
done

badUsage
exit 1
