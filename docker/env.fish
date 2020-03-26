#!/usr/bin/env fish

function docker-env
    eval (docker-machine env default --shell fish)
end

function docker-unenv
    set -e DOCKER_TLS_VERIFY
    set -e DOCKER_HOST
    set -e DOCKER_CERT_PATH
    set -e DOCKER_MACHINE_NAME
end
