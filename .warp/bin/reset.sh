#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/reset_help.sh"

function reset_project() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then
        
        reset_help_usage
        exit 1
    fi

    if [ $(warp_check_is_running) = true ]; then
        warp_message_warn "the containers is running";
        warp_message_warn "Please run first warp stop";
        exit 1;
    fi

    if [ "$1" = "--hard" ] ; then
        # reset files TL
        reset_warninig_confirm_hard
    else
        # reset files DEV
        reset_warninig_confirm
    fi;
}

function reset_warninig_confirm_hard()
{
    reset_msj_delete_all=$( warp_question_ask_default "Queres eliminar todas las configuraciones del proyecto? $(warp_message_info [y/N]) " "N" )
    if [ "$reset_msj_delete_all" = "Y" ] || [ "$reset_msj_delete_all" = "y" ]
    then
        confirm_msj_delete_all=$( warp_question_ask_default "$(warp_message_warn 'Si sigue adelante deberá volver a configurar todo el proyecto, desea continuar?') $(warp_message_info [y/N]) " "N" )
        if [ "$confirm_msj_delete_all" = "Y" ] || [ "$confirm_msj_delete_all" = "y" ]
        then
            warp_message "* borrando $(basename $ENVIRONMENTVARIABLESFILE) $(warp_message_ok [ok])"
            warp_message "* borrando $(basename $ENVIRONMENTVARIABLESFILESAMPLE) $(warp_message_ok [ok])"
            warp_message "* borrando $(basename $DOCKERCOMPOSEFILE) $(warp_message_ok [ok])"
            warp_message "* borrando $(basename $DOCKERCOMPOSEFILESAMPLE) $(warp_message_ok [ok])"
            warp_message "* borrando $(basename $DOCKERCOMPOSEFILEMAC) $(warp_message_ok [ok])"
            warp_message "* borrando $(basename $DOCKERSYNCMAC) $(warp_message_ok [ok])"
            
            rm $ENVIRONMENTVARIABLESFILE 2> /dev/null
            rm $ENVIRONMENTVARIABLESFILESAMPLE 2> /dev/null
            rm $DOCKERCOMPOSEFILE 2> /dev/null
            rm $DOCKERCOMPOSEFILESAMPLE 2> /dev/null
            rm $DOCKERCOMPOSEFILEMAC 2> /dev/null
            rm $DOCKERSYNCMAC 2> /dev/null

	        rm -rf $PROJECTPATH/.warp/docker/config 2> /dev/null
            mkdir -p $PROJECTPATH/.warp/docker/config 2> /dev/null
            touch $PROJECTPATH/.warp/docker/config/.empty 2> /dev/null

            case "$(uname -s)" in
            Darwin)
                # clean data sync
                docker-sync clean
            ;;
            esac

            warp_message ""

            warp_message_warn "Archivos eliminados, para volver a comenzar ejecute: $(warp_message_bold './warp init')"
            warp_message ""
        else
            warp_message_warn "* abortando eliminacion"    
        fi

    fi
}

function reset_warninig_confirm()
{
    reset_msj_delete=$( warp_question_ask_default "Queres eliminar las configuraciones? $(warp_message_info [y/N]) " "N" )
    if [ "$reset_msj_delete" = "Y" ] || [ "$reset_msj_delete" = "y" ]
    then
        warp_message "* borrando $(basename $ENVIRONMENTVARIABLESFILE) $(warp_message_ok [ok])"
        warp_message "* borrando $(basename $DOCKERCOMPOSEFILE) $(warp_message_ok [ok])"

        rm $ENVIRONMENTVARIABLESFILE 2> /dev/null
        rm $DOCKERCOMPOSEFILE 2> /dev/null
        warp_message ""

        warp_message_warn "Archivos eliminados, para volver a comenzar ejecute: $(warp_message_bold './warp init')"
        warp_message ""
    fi
}

function reset_main()
{
    case "$1" in
        reset)
            shift 1
            reset_project $*
        ;;

        -h | --help)
            reset_help_usage
        ;;

        *)            
            reset_help_usage
        ;;
    esac
}
