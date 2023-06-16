#!/bin/bash

ACTION=$1
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

help() {
    echo 'Dash is a Docker toolset for managing multiple docker-projects'
    echo -e 'locally without the port bind issue\n'
    echo 'List of available commands:'
    echo -e '\tstart\tStart the docker services.'
    echo -e '\tstop\tStop the docker services.'
    echo -e '\tdestroy\tDetroy the docker services and its volumes.'
}

start() {
    docker compose --file $SCRIPT_DIR/docker-compose.yml --project-directory $SCRIPT_DIR --project-name denv up -d
}

stop() {
    docker compose --file $SCRIPT_DIR/docker-compose.yml --project-directory $SCRIPT_DIR --project-name denv stop
}

destroy() {
    docker compose --file $SCRIPT_DIR/docker-compose.yml --project-directory $SCRIPT_DIR --project-name denv down
}

createSslCert() {
    if [[ ! -d "$SCRIPT_DIR/certs" ]]; then
        mkdir $SCRIPT_DIR/certs
    fi
    if [[ -f "$SCRIPT_DIR/localhost.crt" ]] && [[ -f "$SCRIPT_DIR/localhost.key" ]]; then
        return
    fi
    openssl req -x509 -out $SCRIPT_DIR/certs/localhost.crt -keyout $SCRIPT_DIR/certs/localhost.key \
    -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' -extensions EXT -config <( \
    printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost,DNS:*.localhost,DNS:*.*.localhost,DNS:*.*.*.localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth") \
    > /dev/null 2>&1
}

createSslCert

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