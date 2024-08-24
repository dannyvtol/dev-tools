#!/bin/bash

ACTION=$1
DOCKER_ENV_DIR=$( cd "$(dirname "$( readlink -f "$0")")" && pwd )/../docker-env

help() {
    echo 'Dash is a Docker toolset for managing multiple docker-projects'
    echo -e 'locally without the port bind issue\n'
    echo 'List of available commands:'
    echo -e '\tstart\tStart the docker services.'
    echo -e '\tstop\tStop the docker services.'
    echo -e '\trestart\tRestart the docker services.'
    echo -e '\tdestroy\tDetroy the docker services and its volumes.'
}

start() {
    docker compose --file $DOCKER_ENV_DIR/docker-compose.yml --project-directory $DOCKER_ENV_DIR --project-name docker-env up -d
}

stop() {
    docker compose --file $DOCKER_ENV_DIR/docker-compose.yml --project-directory $DOCKER_ENV_DIR --project-name docker-env stop
}

restart() {
    docker compose --file $DOCKER_ENV_DIR/docker-compose.yml --project-directory $DOCKER_ENV_DIR --project-name docker-env restart
}

destroy() {
    docker compose --file $DOCKER_ENV_DIR/docker-compose.yml --project-directory $DOCKER_ENV_DIR --project-name docker-env down
}

createSslCert() {
    if [[ ! -d "$DOCKER_ENV_DIR/certs" ]]; then
        mkdir $DOCKER_ENV_DIR/certs
    fi
    if [[ -f "$DOCKER_ENV_DIR/certs/localhost.crt" ]] && [[ -f "$DOCKER_ENV_DIR/certs/localhost.key" ]]; then
        return
    fi

    # Create a key and certificate sign request
    openssl req -newkey rsa:2048 -noenc -keyout $DOCKER_ENV_DIR/certs/localhost.key -out $DOCKER_ENV_DIR/certs/localhost.csr \
    -subj '/CN=localhost' -extensions EXT -config <( \
    printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost,DNS:*.localhost,DNS:*.*.localhost,DNS:*.*.*.localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth") \
    > /dev/null 2>&1

    # Generate certificate
    openssl x509 -signkey $DOCKER_ENV_DIR/certs/localhost.key -in $DOCKER_ENV_DIR/certs/localhost.csr -req -days 36525 -out $DOCKER_ENV_DIR/certs/localhost.crt > /dev/null 2>&1

    rm $DOCKER_ENV_DIR/certs/localhost.csr > /dev/null 2>&1
}

createSslCert

case $ACTION in
    'start')
        start
        ;;
    'stop')
        stop
        ;;
    'restart')
        restart
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
