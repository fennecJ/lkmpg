#!/usr/bin/env bash
FORMAT="%aN,%>|(20) % %% <%aE>"
TARGET="examples lkmpg.tex"

function gen-list()
{
    git log --pretty="$FORMAT" $TARGET | sort -u | sed -E '$s/,/\./'
}

gen-list > lib/contrib.tex