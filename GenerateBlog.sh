#!/bin/bash

DIR="ResearchNotes"

# index.html
echo "Generate index.html"
for Entry in "${DIR}"/*; do
    FileName=$(basename "${Entry}")
    if [ -d "${Entry}/.git" ]; then
        echo "${FileName}: Private"
        echo "<li><a href=\"ResearchNotes/${FileName}/${FileName}-local.html\" target=\"_blank\">${FileName}</a></li>" >>temp_private
    else
        echo "${FileName}: Public"
        echo "<li><a href=\"ResearchNotes/${FileName}/${FileName}.html\" target=\"_blank\">${FileName}</a></li>" >>temp
        echo "<li><a href=\"ResearchNotes/${FileName}/${FileName}-local.html\" target=\"_blank\">${FileName}</a></li>" >>temp_public
    fi
done

cp Assets/index.html index.html
# Replace contents between <ol> and </ol>
sed -i "/<ol>/,/<\/ol>/ { /<\/\?ol>/!d }" index.html
sed -i "/<ol>/r temp" index.html
npx prettier --write index.html
rm temp

cp Assets/index-local.html index-local.html
# Replace contents between <ol> and </ol> below "Public:"
sed -i '/Public:/,/<\/ol>/ {
    /<ol>/,/<\/ol>/ {
        /<ol>/!{/<\/ol>/!d}
    }
    /<ol>/r temp_public
}' index-local.html
# Replace contents between <ol> and </ol> below "Private:"
sed -i '/Private:/,/<\/ol>/ {
    /<ol>/,/<\/ol>/ {
        /<ol>/!{/<\/ol>/!d}
    }
    /<ol>/r temp_private
}' index-local.html
npx prettier --write index-local.html
rm temp_public temp_private

# ResearchNote.html
echo "Generate ResearchNote.html"
for Entry in $DIR/*; do
    FileName=$(basename "${Entry}")
    cp Assets/ResearchNotes.html "${Entry}/${FileName}.html"
    sed -i "s/FileName/${FileName}/g" "${Entry}/${FileName}.html"
    npx prettier --write "${Entry}/${FileName}.html"
    # ResearchNote-local.html
    cp Assets/ResearchNotes-local.html "${Entry}/${FileName}-local.html"
    sed -i "s/FileName/${FileName}/g" "${Entry}/${FileName}-local.html"
    npx prettier --write "${Entry}/${FileName}-local.html"
done
