#!/bin/bash

# Convert TikZ PDF to PNG
# pdf2png PDF PAGE PNG [DPI]
pdf2png() {
    local PDF=$1
    local PAGE=$2
    local PNG=$3
    local DPI=${4:-300}
    echo "Convert $PDF page $PAGE to $PNG"
    magick -density "$DPI" -units pixelsperinch \
        "$PDF[$PAGE]" \
        -alpha remove -background white -flatten \
        -trim +repage \
        -quality 100 \
        "$PNG"
}

mkdir -p "images"

for DIR in mathematics cs literature software; do
    (
        cd "$DIR" || exit
        for SUBDIR in */; do
            TEX=$(basename "$SUBDIR")
            TIKZ="$TEX-tikz"
            (
                cd "$TEX" || exit
                if [[ ! -f "blog.cls" ]]; then
                    ln -s ../../template/blog.cls blog.cls
                    ln -s ../../template/tikz.cls tikz.cls
                fi
                if [[ -f "$TIKZ.tex" ]] && ! git diff --exit-code --quiet "$TIKZ.tex"; then
                    echo compile "$TIKZ.tex"
                    latexmk -pdf "$TIKZ.tex" &>"$TIKZ.log"
                    mapfile -t PNG < <(awk -F'[{}]' '/^% @fig\{/ { print $2 }' "$TIKZ.tex")
                    for PAGE in "${!PNG[@]}"; do
                        pdf2png "$TIKZ.pdf" "$PAGE" "../../images/${PNG[$i]}"
                    done
                fi
                if ! git diff --exit-code --quiet "$TEX.tex"; then
                    echo compile "$TEX.tex"
                    if [[ $(sed -n '1p;1q' "$TEX.tex") == '% !TEX program = xelatex' ]]; then
                        TOOL='-xelatex'
                    else
                        TOOL='-pdf'
                    fi
                    latexmk "$TOOL" "$TEX.tex" &>"$TEX.log"
                fi
            )
        done
    )
done

today=$(date +"%Y%m%d")
sed -i -E "s/(date=)[0-9]*/\1${today}/g" index.html
