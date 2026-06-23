#!/usr/bin/env bash
set -eo pipefail

readonly REAL_PATH="$(readlink -f "${BASH_SOURCE[0]:-$0}")"
readonly SCRIPT_DIR="$(dirname "$REAL_PATH")"
readonly SCRIPT_NAME="$(basename "$REAL_PATH")"

: ${SRC_ROOT:=${HOME}/src}

readonly PROJECT_DEV_LOG="${HOME}/src/devlog"

projects_all=(\
"dev-lang-sample/java" \
"devlog"
)

launch_path() {
    local path=${1}

    if [[ -z $path ]]; then
        echo "path is NOT defined"
        return 127
    fi

    echo launch path: $path

    if [[ ! -d $path ]]; then
        echo "$path is NOT existed"
        return 127
    fi

    code $path || :
}

launch_paths() {
    local paths=("$@")

    # 1. check is array (index array 'a' or associate array 'A')
    if [[ ! ${paths@a} =~ [aA] ]]; then
        echo "Error: $paths is NOT array"
        return 1
    fi

    # 2. check array is empty 
    # ${#array[@]} returns the number of elements of array
    if [[ ${#paths[@]} -eq 0 ]]; then
        echo "$paths is empty"
        return 0
    fi

    for p in "${paths[@]}"; do 
        launch_path ${p} || :
    done
}

launch_with_src_root() {
    local projects=("$@")

    # 1. check is array (index array 'a' or associate array 'A')
    if [[ ! ${projects@a} =~ [aA] ]]; then
        echo "Error: $projects is NOT array"
        return 1
    fi

    # 2. check array is empty 
    # ${#array[@]} returns the number of elements of array
    if [[ ${#projects[@]} -eq 0 ]]; then
        echo "$projects is empty"
        return 0
    fi

    for p in "${projects[@]}"; do 
        launch_path ${SRC_ROOT}/${p} || :
    done
}


help() {
    cat <<HELP
Usage: [SRC_ROOT=/path/to/source/root] $(basename $0) project-group-name
    all 
HELP
}


_main() {
    local arg=${1:-empty}
    case ${arg} in
        "all") launch_with_src_root "${projects_all[@]}" ;;
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
