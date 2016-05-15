rootdir = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
latex = TEXINPUTS="$(rootdir):" lualatex --halt-on-error
pdfdeps = %.tex $(latexinputs)
ifdef references
pdfdeps := $(pdfdeps) %.bbl
endif

.PHONY: default
default:

%.aux: %.tex
	$(latex) $(basename $@)

%.bbl: $(references) %.tex | %.aux
	bibtex $(basename $@)

%.pdf: $(pdfdeps)
	output=$$($(latex) $(basename $@) | tee /dev/tty); \
	if (grep Rerun <<< $$output > /dev/null); then \
		$(latex) $(basename $@); \
	fi;

.PRECIOUS: %.aux %.bbl
