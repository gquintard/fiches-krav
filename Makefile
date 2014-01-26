MDS=$(wildcard jaune/*.md orange/*.md)
PDFS=$(MDS:%.md=pdfs/%.pdf)
.PRECIOUS: $(MDS:%.md=texs/%.tex)
all: $(PDFS) 

.PHONY: clean
clean:
	rm -rf texs pdfs

texs/%.tex : %.md templates/mylatex.latex
	mkdir -p ${@D}
	pandoc -f markdown \
		-t latex \
		--data-dir=$(CURDIR) \
		--template=mylatex \
		$< -o $@

pdfs/%.pdf : texs/%.tex
	mkdir -p ${@D}
	cd ${<D}; pdflatex ${<F}
	mv texs/$*.pdf $@
