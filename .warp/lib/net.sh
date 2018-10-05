#!/bin/bash

#telnet 127.0.0.1 80
#sudo netstat -plnt


##
# Print a list of used ports on host
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
##
function warp_net_get_used_ports() {

    raw=$(netstat -plnt |  tr -s ' ' | cut -d ' ' -f 4)

    #echo "$raw" #For debug

    while read -r line; do
        #echo "... $line ..."

        if [[ $line =~ ([0-9]+)$ ]]; then
            strresult=${BASH_REMATCH[1]}
            echo "- $strresult"
        else
            echo "unable to parse string $line"
        fi

    done <<< "$raw"
}

##
# Check if a given number port is used by an application 
# Use:
#    if ! warp_net_port_in_use 80 ; then
#        echo "Free port"
#    else
#        echo "Bussy port"
#    fi;
#
# Globals:
#   None
# Arguments:
#   $1 Port number. Ex. 8080
# Returns:
#   0 when port is in use
#   1 when port is free
##
function warp_net_port_in_use() {
    port=$1

    # raw=$(netstat -plnt 2>/dev/null |  tr -s ' ' | cut -d ' ' -f 4 | grep ":$port$" | tail -n 1)
    
    # if [[ "$raw" = "" ]]; then
    #     return 1 #Port in free
    # else
    #     return 0 #Port is bussy
    # fi

    nc -z 127.0.0.1 $port
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi

}
