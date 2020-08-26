This is the source code for [my personal site](https://www.danielittlewood.xyz), it is intended first and foremost to be *simple*. So, at least at the
time of writing, it is intended only for serving static content - no
frameworks, no javascript.

Of course, even for a static site there will be bits of content which are
pre-processed. I keep Markdown notes, and convert them to HTML using 
[app-text/discount](http://www.pell.portland.or.us/~orc/Code/discount/).

A major advantage of keeping the site simple is *accessibility*, which I think
is a core concept of web design. I will add more detail about what steps I've
taken to make the site accessible later.

To test the site locally, `python -m http.server 8000 --directory=public`
will serve it on `localhost:8000`. But you can change the language if
python isn't your favourite.

Most commits are tagged as either `[Content]` or `[Development]`, indicating
whether they purely change the static content, or the build process.
