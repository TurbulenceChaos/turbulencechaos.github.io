#!/bin/bash

DIR="ResearchNotes"

# index.html
echo "Generate index.html"
for Entry in "${DIR}"/*; do
    FileName=$(basename "${Entry}")
    if [ -d "${Entry}/.git" ]; then
        echo "${FileName}: Private"
        echo "<li><a href=\"ResearchNotes/${FileName}/${FileName}.html\" target=\"_blank\">${FileName}</a></li>" >>temp_private
    else
        echo "${FileName}: Public"
        echo "<li><a href=\"ResearchNotes/${FileName}/${FileName}.html\" target=\"_blank\">${FileName}</a></li>" >>temp_public
    fi
done

cp Assets/index.html index.html
# Replace contents between <ol> and </ol> below "Public:"
sed -i '/Public:/,/<\/ol>/ {
    /<ol>/,/<\/ol>/ {
        /<ol>/!{/<\/ol>/!d}
    }
    /<ol>/r temp_public
}' index.html
# Replace contents between <ol> and </ol> below "Private:"
sed -i '/Private:/,/<\/ol>/ {
    /<ol>/,/<\/ol>/ {
        /<ol>/!{/<\/ol>/!d}
    }
    /<ol>/r temp_private
}' index.html
npx prettier --write index.html
rm temp_public temp_private

# ResearchNote.html
echo "Generate ResearchNote.html"
for Entry in $DIR/*; do
    FileName=$(basename "${Entry}")
    if [ "${FileName}" != "Thoughts" ]; then
        cp Assets/ResearchNotes.html "${Entry}/${FileName}.html"
        sed -i "s/FileName/${FileName}/g" "${Entry}/${FileName}.html"
        npx prettier --write "${Entry}/${FileName}.html"
    fi
done
