MDS=$(wildcard jaune/*.md orange/*.md)
PDFS=$(MDS:%.md=pdfs/%.pdf)
TEXS=$(MDS:%.md=texs/%.tex)
.PRECIOUS: $(TEXS)
#all: $(PDFS) 
all: pdfs/big.pdf
.PHONY: clean
clean:
	rm -rf texs pdfs

texs/%.tex : %.md templates/mylatex.latex
	mkdir -p ${@D}
	pandoc -f markdown \
		-t latex \
		$< -o $@

texs/big.tex : templates/pre.tex $(TEXS) templates/post.tex
	cat $^ > $@

pdfs/%.pdf : texs/%.tex
	mkdir -p ${@D}
	cd ${<D}; pdflatex ${<F}
	mv texs/$*.pdf $@
