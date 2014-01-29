MDS=$(wildcard jaune/*.md orange/*.md verte/*.md)
PDFS=$(MDS:%.md=pdfs/%.pdf)
TEXS=$(MDS:%.md=texs/%.tex)
.PRECIOUS: $(TEXS)
#all: $(PDFS) 
all: pdfs/big.pdf
.PHONY: clean
clean:
	rm -rf texs pdfs

texs/%.tex : %.md Makefile
	mkdir -p ${@D}
	echo '\\newpage\n\\cfoot{$(subst /,,$(dir $*))}' > $@
	sed '1 s/\(# .*\)/\1 {#$(notdir $*)}/' $< | \
	pandoc -f markdown \
		-t latex \
		>> $@

texs/big.tex : templates/pre.tex $(TEXS) templates/post.tex
	cat $^ > $@

pdfs/%.pdf : texs/%.tex
	mkdir -p ${@D}
	cd ${<D}; pdflatex ${<F}
	cd ${<D}; pdflatex ${<F}
	cd ${<D}; pdflatex ${<F}
	mv texs/$*.pdf $@
