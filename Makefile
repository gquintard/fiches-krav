MDS=$(wildcard jaune/*.md orange/*.md verte/*.md)
PDFS=$(MDS:%.md=pdfs/%.pdf)
TEXS=$(MDS:%.md=texs/%.tex)
HTMLS=$(MDS:%.md=htmls/%.html)
.PRECIOUS: $(TEXS)
#all: $(PDFS) 
#all: pdfs/big.pdf
all: htmls/big.html
.PHONY: clean
clean:
	rm -rf texs pdfs htmls

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

htmls/%.html : %.md Makefile
	mkdir -p ${@D}
	echo "<div id='id$(notdir $*)' onclick=\"toggle('id$(notdir $*)');\" class='hide'>" > $@
	pandoc -f markdown \
		-t html \
		$< >> $@
	echo '</div>' >> $@

$(foreach d, jaune orange verte, \
	$(eval htmls/$(d).html: $(filter htmls/$(d)/%, $(HTMLS))))
htmls/jaune.html htmls/orange.html htmls/verte.html: htmls/%.html :
	echo "<div id='entry-$*'>" > $@;
	for i in $^; do \
		cat $$i >> $@; \
	done
	echo "</div>" >> $@;
	

htmls/big.html : templates/pre.html htmls/jaune.html htmls/orange.html htmls/verte.html templates/post.html
	cat $^ > $@
