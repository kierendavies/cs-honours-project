include ../Makefile

default: poster.pdf poster.tiff

poster.tiff: poster.pdf
	convert -density 300 -compress lzw poster.pdf poster.tiff

clean::
	-rm *.{nav,png,snm,tiff}
