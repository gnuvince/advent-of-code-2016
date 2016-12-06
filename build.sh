BIN_DIR="bin"
DOC_DIR="doc"
TMP_DIR="tmp"

mkdir -p $BIN_DIR
mkdir -p $DOC_DIR
mkdir -p $TMP_DIR

build() {
    # Doc
    noweave -index -delay $1/main.nw > $TMP_DIR/main_$1.tex
    cd $TMP_DIR
    pdflatex main_$1.tex
    pdflatex main_$1.tex
    cd ..
    mv $TMP_DIR/main_$1.pdf $DOC_DIR

    # Code
    if [ "$2" = "cargo" ]; then
        mkdir -p $1/src
        notangle $1/main.nw > $1/src/main.rs
        cargo build --release --manifest-path $1/Cargo.toml
    else
        notangle $1/main.nw > $TMP_DIR/main_$1.rs
        rustc -O $TMP_DIR/main_$1.rs -o $BIN_DIR/main_$1
        rustc --test -O $TMP_DIR/main_$1.rs -o $BIN_DIR/main_$1_test
    fi
}

case "$1" in
    clean)
        rm -rf $BIN_DIR $DOC_DIR $TMP_DIR ;;
    *)
        build "$1" "$2" ;;
esac
