# -*- MakeFile -*-
PAGES_SRC = $(wildcard src/*.html)
STYLE_SRC = $(wildcard src/*.css)
FAVICON   = src/d.png
COPY_SRC  = $(PAGES_SRC) $(STYLE_SRC) $(FAVICON)
COPY_TAR  = $(COPY_SRC:src/%=public/%)

NOTES_SRC = $(wildcard src/notes/*.md)
NOTES_TAR = $(NOTES_SRC:src/notes/%.md=public/notes/%.html)

.PHONY: all clean

all: $(NOTES_TAR) $(COPY_TAR)

public/%.html: src/%.md
	mkdir -p public/notes
	pandoc -V lang=en -M author="Daniel Littlewood" -V css="/main.css" -so $@ $<

public/%: src/%
	cp $< $@

clean:
	rm -rf public/*
