CURR_DAY=
BIN_DIR="bin"
DOC_DIR="doc"
TMP_DIR="tmp"

mkdir -p $BIN_DIR
mkdir -p $DOC_DIR
mkdir -p $TMP_DIR

for d in $(seq 1 $CURR_DAY); do
    # Doc
    noweave -index -delay $d/main.nw > $TMP_DIR/main_$d.tex
    cd $TMP_DIR
    pdflatex main_$d.tex
    pdflatex main_$d.tex
    cd ..
    mv $TMP_DIR/main_$d.pdf $DOC_DIR

    # Code
    notangle $d/main.nw > $TMP_DIR/main_$d.rs
    rustc -O $TMP_DIR/main_$d.rs -o $BIN_DIR/main_$d
done
