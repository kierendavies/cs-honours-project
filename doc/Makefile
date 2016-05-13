rootdir = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
latex = TEXINPUTS="$(rootdir):" lualatex --halt-on-error
references =

.PHONY: default
default:

%.aux: %.tex
	$(latex) $(basename $@)

%.bbl: $(references) %.tex | %.aux
	bibtex $(basename $@)

%.pdf: %.tex %.bbl
	output=$$($(latex) $(basename $@) | tee /dev/tty); \
	if (grep Rerun <<< $$output > /dev/null); then \
		$(latex) $(basename $@); \
	fi;

.PRECIOUS: %.aux %.bbl
