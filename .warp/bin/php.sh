#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/php_help.sh"

function php_info()
{

    PHP_VERSION=$(warp_env_read_var PHP_VERSION)

    if [ ! -z "$PHP_VERSION" ]
    then
        warp_message ""
        warp_message_info "* PHP Info"
        warp_message "PHP_VERSION:                $(warp_message_info $PHP_VERSION)"
        warp_message "XDEBUG FILE:                $(warp_message_info $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini)"
        warp_message "XDEBUG CONFIG:              $(warp_message_info 'http://discourse.summasolutions.net/t/configuring-xdebug/545')"
        warp_message "LOGS PHP:                   $(warp_message_info $PROJECTPATH/.warp/docker/volumes/php-fpm/logs)"

        warp_message ""
    fi
}

function php_connect_ssh() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        php_ssh_help 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "Los contenedores no estan corriendo"
        warp_message_error "este comando necesita previamente que ejecutes warp start"

        exit 1;
    fi

    if [ "$1" = "--root" ]
    then
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash
    else
        docker-compose -f $DOCKERCOMPOSEFILE exec php bash
    fi;    
}

function php_main()
{
    case "$1" in
        ssh)
            shift 1
            php_connect_ssh $*
        ;;

        info)
            php_info
        ;;

        -h | --help)
            php_help_usage
        ;;

        *)            
            php_help_usage
        ;;
    esac
}