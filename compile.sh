#!/bin/bash

# Convert TikZ PDF to PNG
# pdf2png PDF PAGE PNG [DPI]
pdf2png() {
    local PDF=$1
    local PAGE=$2
    local PNG=$3
    local DPI=${4:-300}
    echo "Convert $PDF page $PAGE to $PNG"
    convert -density "$DPI" -units pixelsperinch -quality 100 -alpha remove "$PDF[$PAGE]" -trim "$PNG"
}

mkdir -p "images"

for DIR in mathematics programming literature software; do
    (
        cd "$DIR" || exit
        for SUBDIR in */; do
            TEX=$(basename "$SUBDIR")
            TIKZ="$TEX-tikz"
            (
                cd "$TEX" || exit
                if [[ -f "$TIKZ.tex" ]] && ! git diff --exit-code --quiet "$TIKZ.tex"; then
                    echo compile "$TIKZ.tex"
                    latexmk -pdf "$TIKZ.tex" &>"$TIKZ.log"
                    mapfile -t PNG < <(awk -F'[{}]' '/^% @fig\{/ { print $2 }' "$TIKZ.tex")
                    for PAGE in "${!PNG[@]}"; do
                        pdf2png "$TIKZ.pdf" "$PAGE" "../../images/${PNG[$i]}"
                    done
                fi
                echo compile "$TEX.tex"
                latexmk -pdf "$TEX.tex" &>"$TEX.log"
            )
        done
    )
done

today=$(date +"%Y%m%d")
sed -i -E "s/(date=)[0-9]*/\1${today}/g" index.html
