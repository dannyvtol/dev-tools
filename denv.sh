#!/bin/bash

ACTION=$1
ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

help() {
    echo 'Dash is a Docker toolset for managing multiple docker-projects'
    echo -e 'locally without the port bind issue\n'
    echo 'List of available commands:'
    echo -e '\tstart\tStart the docker services.'
    echo -e '\tstop\tStop the docker services.'
    echo -e '\tdestroy\tDetroy the docker services and its volumes.'
}

start() {
    docker compose --file $ROOT/docker-compose.yml --project-name denv up
}

stop() {
    docker compose --file $ROOT/docker-compose.yml --project-name denv stop
}

destroy() {
    docker compose --file $ROOT/docker-compose.yml --project-name denv down
}

case $ACTION in
    'start')
        start
        ;;
    'stop')
        stop
        ;;
    'destroy')
        destroy
        ;;
    'help')
        help
        ;;
    '')
        help
        ;;
    *)
        echo -e "$ACTION is an unknown command\n"
        help
        ;;
esac