MDS=$(wildcard jaune/*.md orange/*.md verte/*.md bleue/*.md)
PDFS=$(MDS:%.md=pdfs/%.pdf)
HTMLS=$(MDS:%.md=htmls/%.html)
#all: $(PDFS) 
#all: pdfs/big.pdf
all: fiches.html
.PHONY: clean
clean:
	rm -rf texs pdfs htmls

htmls/%.html : %.md Makefile
	mkdir -p ${@D}
	echo "<div id='move-head-$(notdir $*)' onclick=\"toggle('move-body-$(notdir $*)');\"></div>" > $@
	echo "<div id='move-body-$(notdir $*)' onclick=\"toggle('move-body-$(notdir $*)');\" class='hide'>" >> $@
	python -m markdown -n $< >> $@
	echo '</div>' >> $@

$(foreach d, jaune orange verte bleue, \
	$(eval htmls/$(d).html: $(filter htmls/$(d)/%, $(HTMLS))))
htmls/jaune.html htmls/orange.html htmls/verte.html htmls/bleue.html: htmls/%.html :
	echo "<div id='entry-$*'>" > $@;
	for i in $^; do \
		cat $$i >> $@; \
	done
	echo "</div>" >> $@;
	

fiches.html : templates/pre.html htmls/jaune.html htmls/orange.html htmls/verte.html htmls/bleue.html templates/post.html
	cat $^ > $@
