#!/usr/bin/env bash

#
# a small wrapper around the python script to avoid docker commands
#

input_file=${1}
filename=$(basename "${1}")
ext=${filename: -3}
prefix=${filename%.${ext}}
loc=$(readlink -nf "${input_file}")
location=$(dirname "${loc}")

function error(){
    echo -e "\n*********************************************\n"
    echo "ERROR: ${@}"
    echo -e "\n*********************************************\n"
    exit 1
}

docker --version >/dev/null
if [[ $? -ne 0 ]]; then
    error "Docker is not reachable - script may not work"
fi

[[ ! -e ${location}/${filename} ]] && error "${input_file} does not exist."

mkdir -p "${location}/${prefix}_Notes" &>/dev/null

# If script is able to create _Notes directory it'll write to it or will write to stdout without any PNG files
if [[ -d "${location}/${prefix}_Notes" ]]; then

    echo "Saving all the notes in ${location}/${prefix}_Notes"

    touch "${location}/${prefix}_Notes/${prefix}.txt"
    [[ $? -eq 0 ]] || error "Unable to write to directory ${location}/${prefix}_Notes"

    cp "${input_file}" "${location}/${prefix}_Notes/"
    docker run -v "${location}/${prefix}_Notes":/notes --user $(id -u):$(id -u)  \
        vsukt/extract_pdf_notes:latest "${filename}" >"${location}/${prefix}_Notes/${prefix}.txt"
    rm "${location}/${prefix}_Notes/${filename}"

else
    echo -e "Failed to create _Notes directory at ${location}. Sending all annotations to stdout\n Won't be able to create any PNG files\n\n"
    docker run -v "${location}/":/notes --user $(id -u):$(id -u)  \
        vsukt/extract_pdf_notes:latest "${filename}"
    error "No images extracted - target location read-only"
fi
