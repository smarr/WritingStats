# This Makefile relies on LaTeX-Mk
# See: http://latex-mk.sourceforge.net/

NAME=example-book
TEXSRCS=example-book.tex
USE_PDFLATEX=true

CLEAN_FILES+=$(wildcard *.synctex.gz)

# We are going to try a couple of standard locations to find LaTeX-Mk:
-include /opt/local/share/latex-mk/latex.gmk
-include /usr/local/share/latex-mk/latex.gmk
-include ~/.local/share/latex-mk/latex.gmk
