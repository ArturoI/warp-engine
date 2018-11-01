#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/mysql_help.sh"

function mysql_info()
{
    if ! warp_check_env_file ; then
        warp_message_error "No se encuentra el archivo .env"
        exit
    fi; 

    DATABASE_NAME=$(warp_env_read_var DATABASE_NAME)
    DATABASE_USER=$(warp_env_read_var DATABASE_USER)
    DATABASE_PASSWORD=$(warp_env_read_var DATABASE_PASSWORD)
    DATABASE_ROOT_PASSWORD=$(warp_env_read_var DATABASE_ROOT_PASSWORD)
    DATABASE_BINDED_PORT=$(warp_env_read_var DATABASE_BINDED_PORT)

    warp_message_info "* MySQL Info"
    warp_message_info2 "Usuario root habilitado por default"
    warp_message "Nombre DB: $(warp_message_info $DATABASE_NAME)"
    warp_message "Usuario DB: $(warp_message_info $DATABASE_USER)"
    warp_message "Clave DB: $(warp_message_info $DATABASE_PASSWORD)"
    warp_message "Clave root: $(warp_message_info $DATABASE_ROOT_PASSWORD)"
    warp_message "Puerto mapeado a tu maquina: $(warp_message_info $DATABASE_BINDED_PORT)"

}

function mysql_connect() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        mysql_dump_help 
        exit 1
    fi;

    DATABASE_ROOT_PASSWORD=$(warp_env_read_var DATABASE_ROOT_PASSWORD)

    docker-compose -f $DOCKERCOMPOSEFILE exec mysql bash -c "mysql -uroot -p$DATABASE_ROOT_PASSWORD"
}

function mysql_dump() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        mysql_dump_help 
        exit 1
    fi;

    DATABASE_ROOT_PASSWORD=$(warp_env_read_var DATABASE_ROOT_PASSWORD)

    db="$@"

    [ -z "$db" ] && warp_message_error "Debe ingresar el nombre de la base de datos" && exit 1
    
    docker-compose -f $DOCKERCOMPOSEFILE exec mysql bash -c "mysqldump -uroot -p$DATABASE_ROOT_PASSWORD $db 2> /dev/null"
}

function mysql_import()
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        mysql_import_help 
        exit 1
    fi;

    db=$1

    [ -z "$db" ] && warp_message_error "Debe ingresar el nombre de la base de datos" && exit 1

    DATABASE_ROOT_PASSWORD=$(warp_env_read_var DATABASE_ROOT_PASSWORD)
    
    docker-compose -f $DOCKERCOMPOSEFILE exec -T mysql bash -c "mysql -uroot -p$DATABASE_ROOT_PASSWORD $db 2> /dev/null"

}

function mysql_main()
{
    case "$1" in
        dump)
            shift 1
            mysql_dump $*
        ;;

        info)
            mysql_info
        ;;

        import)
            shift 1
            mysql_import $*
        ;;

        connect)
            shift 1
            mysql_connect $*
        ;;

        -h | --help)
            mysql_help_usage
        ;;

        *)            
            mysql_help_usage
        ;;
    esac
}

