#!/usr/bin/env bash
FORMAT="%an,%>|(20) % %% <%ae>"
TARGET="../examples ../lkmpg.tex"

gen-list(){
    git log --pretty="$FORMAT" $TARGET | sort -u
}

gen-list
