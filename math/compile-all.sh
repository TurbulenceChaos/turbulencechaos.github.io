#!/bin/bash

pdf2png() {
    local PDF=$1
    local PAGE=$2
    local PNG=$3
    convert -density 300 -units pixelsperinch -quality 100 -alpha remove "$PDF[$PAGE]" -trim "$PNG"
    echo "Convert $PDF page $PAGE to $PNG"
}

# usage:
# pdf2png PDF PAGE PNG

IMG_DIR="../../images"
mkdir -p "$IMG_DIR"

for TEX in */; do
    if [[ "$TEX" == "template/" ]]; then
	continue
    fi

    TEX=$(basename "$TEX")
    TIKZ="$TEX-tikz"
    (
	cd "$TEX"
	if [ -f "$TIKZ.tex" ]; then
	    echo "compiling $TIKZ.tex"
	    latexmk -pdf "$TIKZ.tex" &> "$TIKZ.log"
	    echo "compile done"
	    mapfile -t PNG < <(grep -Po "^% @fig{\K.+(?=})" "$TIKZ.tex")
	    for i in "${!PNG[@]}"; do
		pdf2png "$TIKZ.pdf" "$i" "${IMG_DIR}/${PNG[$i]}"
	    done
	fi
	echo "compiling $TEX.tex"
	latexmk -pdf "$TEX.tex" &> "$TEX.log"
	echo "compile done"
    )
done

