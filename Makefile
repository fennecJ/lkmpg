all: lkmpg.tex
	rm -rf _minted-main
	pdflatex -shell-escap lkmpg.tex
	bibtex main >/dev/null || echo
	pdflatex -shell-escape $< 2>/dev/null >/dev/null

html: lkmpg.tex
	make4ht -suf html5 -c config.cfg -d html lkmpg.tex

clean:
	rm -f *.dvi *.aux *.log *.ps *.pdf *.out lkmpg.bbl lkmpg.blg lkmpg.lof lkmpg.toc 
	rm -rf _minted-lkmpg
	rm -f *.xref *.svg *.tmp *.html *.css *.4ct *.4tc *.dvi *.lg *.idv
	rm -rf  html