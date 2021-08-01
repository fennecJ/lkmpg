all: lkmpg.tex
	rm -rf _minted-main
	pdflatex -shell-escap lkmpg.tex
	bibtex main >/dev/null || echo
	pdflatex -shell-escape $< 2>/dev/null >/dev/null

html: lkmpg.tex
	make4ht --shell-escape --utf8 --format html5 --config html.cfg --output-dir html lkmpg.tex
	ln -sf html/lkmpg.html html/index.html
	rm -f  lkmpg.xref lkmpg.tmp lkmpg.html lkmpg.css lkmpg.4ct lkmpg.4tc lkmpg.dvi lkmpg.lg lkmpg.idv lkmpg.log lkmpg.aux lkmpg*.svg

clean:
	rm -f *.dvi *.aux *.log *.ps *.pdf *.out lkmpg.bbl lkmpg.blg lkmpg.lof lkmpg.toc
	rm -rf _minted-lkmpg
	rm -f  lkmpg.xref lkmpg.tmp lkmpg.html lkmpg.css lkmpg.4ct lkmpg.4tc lkmpg.dvi lkmpg.lg lkmpg.idv lkmpg*.svg
	rm -rf  html

.PHONY: html
