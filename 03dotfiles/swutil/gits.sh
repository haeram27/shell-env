#!/usr/bin/env bash
set -eo pipefail

readonly REAL_PATH="$(readlink -f "${BASH_SOURCE[0]:-$0}")"
readonly SCRIPT_DIR="$(dirname "$REAL_PATH")"
readonly SCRIPT_NAME="$(basename "$REAL_PATH")"

: ${SRC_PATH:=${HOME}/src}

readonly REPOS_PREFIX="git@github.com:haeram27"
readonly REPO_DEVLOG="devlog"
readonly REPO_DEVLANG_SAMPLE="dev-lang-sample"
readonly REPO_SHELL_ENV="shell-env"
readonly REPO_SPRING_VANILA="spring-msa-vanila"
readonly REPO_THE_READER="the-reader"
readonly REPO_WEBHOOK_GO="webhook-go"

projects=("${REPO_DEVLOG}" "${REPO_DEVLANG_SAMPLE}" "${REPO_SHELL_ENV}" "${REPO_SPRING_VANILA}" "${REPO_THE_READER}" "${REPO_WEBHOOK_GO}")

git_clone() {
    local project=${1}

    if [[ -z $project ]]; then
        return 127
    fi

    local path="${SRC_PATH}"/"${project}"
    if [[ -d $path ]]; then
        echo "$path is already existed"
        return 127
    fi

    local repo="${REPOS_PREFIX}"/"${project}"
    echo "## git clone $repo"

    git clone "${repo}" "$path"
}


git_pull() {
    local project=${1}

    if [[ -z $project ]]; then
        return 127
    fi

    local path="${SRC_PATH}"/"${project}"
    echo
    echo "## git pull $path"
    if [[ ! -d $path ]]; then
        echo "invalid path"
        return 127
    fi

    cd ${path}
    git pull --recurse-submodules=yes --rebase=true --autostash
}

git_push() {
    local project=${1}

    if [[ -z $project ]]; then
        return 127
    fi

    local path="${SRC_PATH}"/"${project}"
    echo
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

clone_all() {
    for project in "${projects[@]}"; do 
        git_clone ${project} || :
    done
}

push_all() {
    for path in "${projects[@]}"; do
        git_push ${path} || :
    done 
}

pull_all() {
    for path in "${projects[@]}"; do 
        git_pull ${path} || :
    done
}

help() {
    cat <<HELP
Usage: SRC_PATH=/path/to/source/root $(basename $0) pull
    clone
    push
    pull
HELP
}

_main() {
    local arg=${1:-empty}
    case ${arg} in
        "clone") clone_all ;;
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
