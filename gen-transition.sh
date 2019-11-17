#!/bin/bash

set -e

bg_dir="$1"
root_dir="$2"
root_prefix="$3"

if [[ -n "${root_dir}" ]]
then
    root_path="$(realpath "${root_dir}")"
fi

unset first_bg_path
unset prev_bg_path

## Header ======================================================================

cat << _EOF
<background>
  <starttime>
    <year>2009</year>
    <month>08</month>
    <day>04</day>
    <hour>00</hour>
    <minute>00</minute>
    <second>00</second>
  </starttime>
_EOF

## Backgrounds =================================================================

pushd "${bg_dir}" >&2

for bg in *
do
    ## Check is image ----------------------------------------------------------
    
    bgext="${bg: -4}"
    
    if [[ "${bgext,,}" == '.xml' ]]
    then
        continue
    fi

    ## Get file path -----------------------------------------------------------

    if [[ -z "${root_dir}" ]]
    then
        bg_path="$(realpath "${bg}")"
    else
        bg_path="${root_prefix}$(realpath --relative-to="${root_path}" "${bg}")"
    fi
    
    ## Transition --------------------------------------------------------------
    
    if [[ -n "${prev_bg_path}" ]]
    then
        cat << _EOF
  <transition type="overlay">
    <duration>5.0</duration>
    <from>${prev_bg_path}</from>
    <to>${bg_path}</to>
  </transition>
_EOF
    fi
    
    ## Static background -------------------------------------------------------

    cat << _EOF
  <static>
    <duration>895.0</duration>
    <file>${bg_path}</file>
  </static>
_EOF

    ## Save previous and first background paths --------------------------------

    prev_bg_path="${bg_path}"
    
    if [[ -z "${first_bg_path}" ]]
    then
        first_bg_path="${bg_path}"
    fi
    
    ## -------------------------------------------------------------------------

done

popd >&2

## Footer ======================================================================

cat << _EOF
  <transition type="overlay">
    <duration>5.0</duration>
    <from>${prev_bg_path}</from>
    <to>${first_bg_path}</to>
  </transition>
</background>
_EOF

