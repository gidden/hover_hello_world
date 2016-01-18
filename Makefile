# basic vars
ORIGD = $(PWD)
NAME = $(shell basename $(PWD))

PRESFILE = pres.rst

# doc publishing variables
DOCREPOURL      = git@github.com:gidden/gidden.github.io
DOCREPODIR      = ~/personal/site

DOCUPDATENAME   = $(NAME)
DOCHTMLDIR      = $(DOCREPODIR)/pres/$(NAME)
TMPDOCDIR       = $(DOCREPODIR)/.$(DOCUPDATENAME)tmpdocs

BLDHTMLDIR      = site

all: build

build:
	@echo 
	@echo "Building $(NAME) in ./$(BLDHTMLDIR)"
	hovercraft $(PRESFILE) $(BLDHTMLDIR)

publish:
	@echo
	@echo "Updating $(DOCHTMLDIR) with current documentation."
	test -d $(DOCREPODIR) || git clone $(DOCREPOURL) $(DOCREPODIR) && \
	test ! -d $(TMPDOCDIR) || rm -r $(TMPDOCDIR) && \
	mkdir -p $(TMPDOCDIR) && \
	cp -r $(BLDHTMLDIR)/* $(TMPDOCDIR) && \
	cd $(DOCREPODIR) && git pull origin master && \
	test ! -d $(DOCHTMLDIR) || rm -r $(DOCHTMLDIR) && \
	mkdir -p $(DOCHTMLDIR) && mv $(TMPDOCDIR)/* $(DOCHTMLDIR) && \
	rm -r $(TMPDOCDIR)/ && \
	cd $(DOCREPODIR) && git add $(DOCHTMLDIR) && \
	if [ -n "$$(git status $(DOCHTMLDIR) --porcelain)" ]; \
	then git commit -m "updated $(DOCUPDATENAME) html" && git push origin master; \
	fi
	@echo
	@echo "$(DOCHTMLDIR) updated and pushed to $(DOCREPOURL)."
.PHONY: publish
