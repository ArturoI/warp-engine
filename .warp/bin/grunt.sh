#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/grunt_help.sh"

function grunt_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        grunt_help_usage 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "Los contenedores no estan corriendo"
        warp_message_error "este comando necesita previamente que ejecutes warp start"

        exit 1;
    fi

    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "grunt $*"
}

function grunt_main()
{
    case "$1" in
        grunt)
            shift 1
            grunt_command $*
        ;;

        -h | --help)
            grunt_help_usage
        ;;

        *)            
            grunt_help_usage
        ;;
    esac
}