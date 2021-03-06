# Makefile for generating R packages.
# 2017 Rob J Hyndman
#
# Assumes Makefile is in top folder of package

PKG_NAME=$(shell grep -i ^package DESCRIPTION | cut -d : -d \  -f 2)


all: install

check:
	Rscript -e "devtools::check(document=TRUE)"

check_cran:
	Rscript -e 'source("cran_check.R")'

build:
	R CMD build --compact-vignettes="gs+qpdf" .
	mv -f *.tar.gz ..

install:
	rmake

winbuild:
	Rscript -e "rt::rwinbuild(devel=TRUE)"

clean:
	-rm -f ../$(PKG_NAME)_*.tar.gz
	-rm -r -f man/*.Rd
	-rm -r -f NAMESPACE

docs:
	Rscript -e "rt::rdoc()"

pkgdown:
	mv vignettes /tmp/; Rscript -e "rt::rpkgdown()"; mv /tmp/vignettes .

revdep:
	Rscript -e "revdepcheck::revdep_check(num_workers=4)"
