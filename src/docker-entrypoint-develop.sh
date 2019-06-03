#!/usr/bin/env bash
set -euo pipefail

YELLOW="\e[0;93m"
GREEN="\e[0;92m"
BOLD="\e[1m"
RESET="\e[0m"

HOME_APP=/home/app
ENVIRONMENT=development

step()    { echo -e "${YELLOW}${BOLD}===> ${RESET}${*}${RESET}"; }
success() { echo -e "${RESET}${GREEN}${BOLD}${*}${RESET}"; }

step "Environment: ${ENVIRONMENT}"
step "Current dir: $(pwd)"
step "Python version: $(python --version)"

# SETUP AND CHECK DEFINITIONS

function setup_shell() {
    if [[ -L ${HOME_APP}/.bashrc ]]; then return 0; fi

    chown app.app ${HOME_APP}/
    gosu app ln -sf /app/.bashrc ${HOME_APP}/.bashrc

    step "Setup shell $(success [Done])"
}

function setup_python_env() {
    if [[ -f /python/bin/python ]]; then return 0; fi

    (
        set -x
        mkdir -p /python
        chown app.app -R /python
        gosu app python -m venv /python
        gosu app /python/bin/pip install --quiet setuptools wheel
    )

    step "Python environment $(success [Done])"
}

function setup_initialized() {
    if [[ -f /app/.initialized ]]; then return 0; fi

    step "Installing requirements"

    (
        set -x

        chown app.app -R /python

        gosu app pip install -U \
            setuptools \
            wheel \
            pip \
            pip-tools | cat

        gosu app pip install -r requirements-develop.txt | cat

        gosu app touch /app/.initialized
    )

    step "Initialized $(success [Done])"

    rm -f ${HOME_APP}/.bashrc

    setup_shell
}

function check_permissions() {
    (
        find /app /python \
            -not \( -name "frontend"  -prune \) \
            -not \( -name "node_modules"  -prune \) \
            -not \( -name ".git" -prune  \) \
            -not \( -name ".cache" -prune \) \
            -not -user app \
            -exec chown app.app \{\} \; >/dev/null &

        chown app.app /python >/dev/null &
        chown app.app /home/app >/dev/null &

        wait
    ) &
    step "Run permissions check $(success [OK])"
}

case "$1" in
    -)
        # Switch to app user
        if [[ ${1} = '-' ]]; then shift; fi
        set -- gosu app bash
    ;;
    --shell)
        (
            setup_shell
            setup_python_env
            check_permissions
            setup_initialized
        )

        # Switch to app user
        if [[ ${1} = '-' ]]; then shift; fi
        set -- gosu app bash
    ;;
esac

step "Running: $@"
exec "$@"
exit 0
