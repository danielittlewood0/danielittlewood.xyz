# -*- MakeFile -*-

DOMAIN  = https://www.danielittlewood.xyz

STYLES    = $(wildcard src/*.css)
FAVICON   = src/d.png
HTACCESS  = src/.htaccess
COPY_SRC  = $(STYLES) $(FAVICON) $(HTACCESS)
COPY_TAR  = $(COPY_SRC:src/%=public/%)
SITEMAP   = public/sitemap.xml
FILTER_SRC= $(wildcard filters/*.hs)
FILTERS   = $(FILTER_SRC:%.hs=%)
NOTES_SRC = $(wildcard src/*.md) $(wildcard src/**/*.md)
NOTES_TAR = $(NOTES_SRC:src/%.md=public/%.html)

.PHONY: all clean

all: $(NOTES_TAR) $(COPY_TAR) $(SITEMAP) $(FILTERS)

filters/%: filters/%.hs
	ghc --make $< -o $@

FILTER_OPTS = $(FILTERS:%=--filter=%)
public/%.html: src/%.md
	mkdir -p public/notes
	pandoc \
		--template="danielittlewood-template.html" \
		$(FILTER_OPTS) \
		-V lang=en \
		-M author="admin@danielittlewood.xyz" \
		-V css="/main.css" \
		-V favicon="/d.png" \
		--toc -so $@ $<

public/sitemap.xml: 
	DOMAIN=$(DOMAIN) ./sitemap_generator.sh >| public/sitemap.xml

public/%: src/%
	cp $< $@

clean:
	rm -rf public/*
