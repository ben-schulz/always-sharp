#!/bin/bash

#
# Replace a string in all files matching pathglob,
# and print line-numbered replacement results to stdout.
#
# h/t to this helpful reference
# on colorizing text in the shell:
#
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
#
#
# \0 (2018.09.18)

if [ 3 -ne $# ]; then
    echo "usage: $0 string replacement path"
    exit 1
fi

oldname=$1
newname=$2

path=$3

esc='\e'

red="$esc\[30m"
reset_format="$esc[0m"

function colorize(){
    echo "\x1B[31m$1\x1B[0m"
}

function matching_files(){
    echo $(ls $path | xargs)
}

function temp_filename(){
    echo "$1.tmp"
}

function show_replacements(){

    local file=$1
    local oldname=$2
    local newname=$3

    local colorized_newname=$(colorize $newname)

    local interleave_alternating='
      1~2 { h };
      2~2 {
        x;
        G;
        s/\n/: /g;
        p
      }'
    
    local replace_and_colorize="
      /$oldname/ {
        =;
        s/$oldname/$colorized_newname/g;
        P
      }"

    local sed="sed --quiet --expression"

    $sed "$interleave_alternating" <(
	      $sed "$replace_and_colorize" <(
	        cat "$file"))
	
}

function make_replacements(){

    local file=$1
    local oldname=$2
    local newname=$3
    local dest=$(temp_filename $file)

    cat "$file" |
	  sed --expression "s/$oldname/$newname/g" > "$dest"
}

for file in $(matching_files); do

    echo "$file"

    tempfile=$(temp_filename $file)
    
    show_replacements $file $oldname $newname
    $(make_replacements $file $oldname $newname) &&
        cp $tempfile $file &&
            rm $tempfile    
    echo ''
done
