This is the source code for [my personal
site](https://www.danielittlewood.xyz), it is intended first and foremost to be
*simple*. So, at least at the time of writing, it is intended only for serving
static content - no frameworks, no javascript.

A major advantage of keeping the site simple is *accessibility*, which I think
is a core concept of web design. I will add more detail about what steps I've
taken to make the site accessible later.

Most commits are tagged as either `[Content]` or `[Development]`, indicating
whether they purely change the static content, or the build process.

## Build

The site is built using `make` from the following kinds of files:

* HTML pages, which are copied verbatim from source.
* Plain CSS stylesheets, also copied.
* Notes written in Markdown, which are converted to HTML fragments using
  [app-text/pandoc](https://pandoc.org/).

The site will be built into the `public` directory, which is intended to be
uploaded verbatim. Run `make all` to update any files (or to create them for
the first time), and `make clean` to clear the `public` directory.

To avoid caching issues, be sure to do a hard refresh of the page (Ctrl-F5 in
chromium). This is required even if opening a new tab.

To run the site locally, 

```
python -m http.server 8000 --directory=public
```

will serve it on `localhost:8000`. But you can change the language if
python isn't your favourite.
