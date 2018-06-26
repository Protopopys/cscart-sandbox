#!/bin/bash

checkExist () {
    if [ ! -f $1 ]; then
        echo "File $1 not found!"
        exit 1
    fi
}

getParams () {
    var=$1
    case ${var} in

        local)
            dockerCommand="docker-compose -f ./compose/global.yml -f ./compose/local.yml --project-name sandbox"
        ;;

        external)
            dockerCommand="docker-compose -f ./compose/global.yml -f ./compose/external.yml --project-name sandbox"
        ;;

        wildcard)
            wildcard=$(cat .env | grep WILDCARD | cut -f 2 -d =)
            domain=$(cat .env | grep DOMAIN | cut -f 2 -d =)
            sslPath=$(cat .env | grep CSCART_SSL | cut -f 2 -d =)
            cert=${sslPath}/${domain}
        ;;

        *)
            echo ""
            echo "Error!!! Not found ${var}."
            exit 1
        ;;


    esac
}

doWork () {
    do=$1
    case ${do} in

        external)
            checkExist .env
            getParams ${do}
            doWork wildcard
            ${dockerCommand} up -d php56-fpm php70-fpm php71-fpm php72-fpm mysql
            sleep 3
            ${dockerCommand} up -d 
        ;;

        local)
            checkExist .env
            getParams ${do}
            ${dockerCommand} up -d php56-fpm php70-fpm php71-fpm php72-fpm mysql
            sleep 3
            ${dockerCommand} up -d
        ;;

        wildcard)
            checkExist .env
            getParams ${do}
            if [[ "${wildcard}" = "yes" ]]; then
                ${dockerCommand} up -d proxy
                while [ ! -f ${cert} ]; do
                    echo " Please waiting for a certificate "
                    sleep 10
                done
            fi
        ;;

        *)
            echo ""
            echo "Error!!! ${do} is not specified."
            exit 1
        ;;

    esac

}

doWork $1