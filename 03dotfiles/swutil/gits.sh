#!/usr/bin/env bash
set -eo pipefail

readonly REAL_PATH="$(readlink -f "${BASH_SOURCE[0]:-$0}")"
readonly SCRIPT_DIR="$(dirname "$REAL_PATH")"
readonly SCRIPT_NAME="$(basename "$REAL_PATH")"

: ${SRC_PATH:=${HOME}/src}

readonly DEVLOG_PATH="${SRC_PATH}/devlog"
readonly SHELL_ENV_PATH="${SRC_PATH}/shell-env"
readonly DEVLANG_SAMPLE_PATH="${SRC_PATH}/dev-lang-sample"
readonly SPRING_VANILA_PATH="${SRC_PATH}/spring-msa-vanila"
readonly THE_READER_PATH="${SRC_PATH}/the-reader"

repos=("${DEVLOG_PATH}" "${SHELL_ENV_PATH}" "${DEVLANG_SAMPLE_PATH}" "${SPRING_VANILA_PATH}" "${THE_READER_PATH}")

git_pull() {
    local path=${1}
    if [[ -z $path ]]; then
        return 127
    fi

    echo "## git pull $path"
    if [[ ! -d $path ]]; then
        echo "invalid path"
        return 127
    fi

    cd ${path}
    git pull --recurse-submodules=yes --rebase=true --autostash
}

git_push() {
    local path=${1}
    if [[ -z $path ]]; then
        return 127
    fi

    echo "## git push $path"
    if [[ ! -d $path ]]; then
        echo "invalid path"
        return 127
    fi

    cd ${path}
    git add .
    git commit -m "$(date --rfc-3339=seconds)"
    git push
}

pull_all() {
    for path in "${repos[@]}"; do 
        git_pull ${path} || :
    done
} 

push_all() {
    for path in "${repos[@]}"; do 
        git_push ${path} || :
    done 
}

help() {
    cat <<HELP
$(basename $0) Usage: SRC_PATH=/path/to/source/root gitsw.sh pull
    push
    pull
HELP
}

_main() {
    local arg=${1:=empty}
    case ${arg} in
        "push") push_all ;;
        "pull") pull_all ;;
        *) help ;;
    esac
}

_is_sourced() {
    local executed_script=$(basename ${0#-})
    local this_script=$(basename ${BASH_SOURCE})
    if [[ ${executed_script} = ${this_script} ]]; then
        return 1
    fi

    return 0
}

if ! _is_sourced; then
    _main "$@"
fi
