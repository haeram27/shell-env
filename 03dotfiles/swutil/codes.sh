#!/usr/bin/env bash
set -eo pipefail

readonly REAL_PATH="$(readlink -f "${BASH_SOURCE[0]:-$0}")"
readonly SCRIPT_DIR="$(dirname "$REAL_PATH")"
readonly SCRIPT_NAME="$(basename "$REAL_PATH")"

: ${SRC_PATH:=${HOME}/src}

readonly PROJECT_DEVLOG="devlog"
readonly PROJECT_DEVLANG_JAVA="dev-lang-sample/java"
readonly PROJECT_DEVLANG_KOTLIN="dev-lang-sample/kotlin"

projects_all=("${PROJECT_DEVLOG}" "${PROJECT_DEVLANG_JAVA}" "${PROJECT_DEVLANG_KOTLIN}")


launch() {
    local project=${1}

    if [[ -z $project ]]; then
        return 127
    fi

    local path="${SRC_PATH}"/"${project}"
    echo launch path: $path

    if [[ ! -d $path ]]; then
        echo "$path is NOT existed"
        return 127
    fi

    code $path || :
}


launch_all() {
    local group=("$@")

    # 1. check is array (index array 'a' or associate array 'A')
    if [[ ! ${group@a} =~ [aA] ]]; then
        echo "Error: $group is NOT array"
        return 1
    fi

    # 2. check array is empty 
    # ${#array[@]} returns the number of elements of array
    if [[ ${#group[@]} -eq 0 ]]; then
        echo "$group is empty"
        return 0
    fi

    for p in "${group[@]}"; do
        launch ${p} || :
    done
}


help() {
    cat <<HELP
$(basename $0) Usage: [SRC_PATH=/path/to/source/root] codesw.sh project-group-name
    all
    beconsole 
HELP
}


_main() {
    local arg=${1:-empty}
    case ${arg} in
        "all") launch_all "${projects_all[@]}" ;;
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
