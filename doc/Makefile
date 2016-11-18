rootdir = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: default
default:

%.pdf: FORCE
	TEXINPUTS="$(rootdir):" latexmk -pdf $(basename $@)

clean:
	latexmk -C -bibtex
	rm *-eps-converted-to.pdf

FORCE:
