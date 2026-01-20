#!/usr/bin/env bash

setgit() {
    while (( "$#" )); do
        git config "$1" "$2"
        shift 2
    done
}

git_options=(

    branch.autosetuprebase always

    fetch.prune true

    pull.default current

    pull.rebase true

    push.autoSetupRemote true

    push.default current

    rebase.autoSquash true

    rebase.autoStash true

    rebase.stat true

    rerere.autoUpdate true

    rerere.enabled true
)

setgit "${git_options[@]}"
