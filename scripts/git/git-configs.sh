#!/usr/bin/env bash # git shell one day maybey I dont now is necessery

setgit() {
    while (( "$#" )); do
        git config "$1" "$2"
        shift 2
    done
}

git_options=(
)

setgit "${git_options[@]}"
