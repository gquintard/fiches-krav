MDS=$(wildcard *.md)
PDFS=$(MDS:%.md=pdfs/%.pdf)
.PRECIOUS: $(MDS:%.md=texs/%.tex)
all: $(PDFS) 

.PHONY: clean
clean:
	rm -rf texs pdfs

texs pdfs :
	mkdir $@

texs/%.tex : %.md templates/mylatex.latex | texs
	sed 's/^% \(Orange\|Jaune\)/\\cfoot{\1}\n/' $< | \
	pandoc -f markdown \
		-t latex \
		--data-dir=$(CURDIR) \
		--template=mylatex \
		> $@

pdfs/%.pdf : texs/%.tex | pdfs
	cd ${<D}; pdflatex ${<F}
	mv ${<D}/$*.pdf $@
