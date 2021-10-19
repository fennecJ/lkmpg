#!/usr/bin/env bash
FORMAT="%aN,<%aE>"      #Name,[left align 30 chars] % <Email> //Capital in aN and aE means replace str in .mailmap
TARGET=(examples lkmpg.tex)
DIR=`git rev-parse --show-toplevel`  #Get root dir of the repo
TARGET=("${TARGET[@]/#/$DIR/}")      #Concat $DIR BEFORE ALL elements in array TARGET

function gen-raw-list()
{
    git log --pretty="$FORMAT" ${TARGET[@]} | sort -u
}

function parse-list()
{
    Excluded=`awk < Exclude -F "//" '{print $1}'`
    while read -r line; do
        User=`echo "$line" | awk -F "," '{print $1}'`
        if [[ `echo "$Excluded" | grep "$User"` ]]; then
            continue;
        fi
        MainMail=`echo "$line" | awk -F "[<*>]" '{print $2}'`
        Emails=(`cat $DIR/.mailmap | grep "$User" | awk -F "[<*>]" '{print $4}' | sort -u`)
        for Email in ${Emails[@]}; do
            if [[ "$Email" != "$MainMail" ]]; then
                line="$line,<$Email>";
            fi
        done
        echo "$line" >> Contributors
        echo "$User" >> Exclude
    done <<< $(gen-raw-list)
}

function sort-list()
{
    if [[ `git diff Contributors` ]]; then
        sort -o Contributors{,}
        sort -o Exclude{,}
        git add $DIR/scripts/Contributors
    fi
}

function gen-tex-file()
{
    #list=`cat Contributors | awk -F "," '{printf("%-20s %% %s\n",$1",",$2)}'`;
    #echo "$list" | sed -E '$s/,/\./'
    cat Contributors | awk -F "," '
         BEGIN{k=0}{n[k]=$1;e[k++]=$2}
         END{
            for(i=0;i<k;i++){
                n[i]=(i<k-1)?n[i]",":n[i]".";
                printf("%-30s %% %s\n",n[i],e[i]);
                }
            }
        '
}

parse-list
sort-list
gen-tex-file
gen-tex-file > $DIR/lib/contrib.tex
