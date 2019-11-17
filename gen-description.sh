#!/bin/bash

set -e

dm="$1"
bg_dir="$2"
root_dir="$3"
root_prefix="$4"

if [[ -n "${root_dir}" ]]
then
    root_path="$(realpath "${root_dir}")"
fi

## Header ======================================================================

cat << _EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "${dm}-wp-list.dtd">
<wallpapers>
_EOF

## Backgrounds =================================================================

pushd "${bg_dir}" >&2

for bg in *
do

    echo "$bg" >&2

    ## Gen background name -----------------------------------------------------

    bg_name="${bg//_/\ }"
    bg_name="$(echo "${bg_name%.*}" | tr "[A-Z]" "[a-z]" | sed "s/\( \|^\)\(.\)/\1\u\2/g" )"
    
    ## Get background path -----------------------------------------------------
    
    if [[ -z "${root_dir}" ]]
    then
        bg_path="$(realpath "${bg}")"
    else
        bg_path="${root_prefix}$(realpath --relative-to="${root_path}" "${bg}")"
    fi
    
    ## Background --------------------------------------------------------------

    cat << _EOF
        <wallpaper>
            <name>${bg_name}</name>
            <filename>${bg_path}</filename>
            <options>zoom</options>
            <pcolor>#000000</pcolor>
            <scolor>#000000</scolor>
            <shade_type>solid</shade_type>
        </wallpaper>
_EOF

    ## -------------------------------------------------------------------------

done

popd >&2

## Footer ======================================================================

cat << _EOF
</wallpapers>
_EOF



