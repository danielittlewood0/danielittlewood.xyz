---
title: "How I Built This"
---

This document attempts to capture the various bits of configuration I went
through to get this site into the state it's currently in.

## Server Space

My server is maintained by
(https://www.nearlyfreespeech.net/)[NearlyFreeSpeech]. They do "pay as you go"
hosting, meaning that each served request, email sent, or DB query, costs you a
certain amount. This works well for me, since I'm sure that for a long time I'm
going to have very minimal traffic. An advantage of NFS for me is that they're
[very well documented](https://www.nearlyfreespeech.net/about/faq), and while
you could in principle just use the FAQ and then go to any provider you like, I
think it's only fair to reward them for this service.

## Source Code

The full source for this site, including the Markdown source for any of the
articles compiled into the site, is freely available [on
GitHub](https://github.com/danielittlewood0/danielittlewood.xyz). I use GitHub
currently out of intertia, and at some point will probably switch to a
self-hosted Git server. For further details, [check out the
README](https://github.com/danielittlewood0/danielittlewood.xyz/blob/master/README.md).

## DNS

I bought this domain through [GoDaddy](https://www.godaddy.com/), and my DNS is
managed by NearlyFreeSpeech. I think I was required to use NFS, but I can't
remember why.

## HTTPS

For inforamtion about getting a certificate for HTTPS, visit [Let's
Encrypt](https://l.facebook.com/l.php?u=https%3A%2F%2Fletsencrypt.org%2F%3Ffbclid%3DIwAR03R7VdoXXgOs4xrm4-r41PE8Vmygy70bA6npx_TbStcV9dFu9_ub_Dsqw&h=AT22PVvjXqF3LrKpB_6iDHj6xrX8CNGpKM0a2I23MYS5eZwJqPeHKVV0uzndy4Y11j1fXFCjimrOWLIoZIW-L7yb-8YOxDHu5K2ot8_bL-Frv3oqgvnCnQE-q9fAKg).
The usual situation is that they will give you a "challenge" file which you
must put onto your server to prove you own it.

## Meta Tags and Templating

For the pages I build with pandoc, certain meta tags which are similar over the
whole site are built into pages automatically. This is done using pandoc's
[templating feature](https://pandoc.org/MANUAL.html#templates).
There are several "ways in" to using pandoc templates to set metadata
variables. To see their default HTML template, run `pandoc -D html`, and find
examples in this site's source code in the Makefile, as well as in the notes
directory.

For pages that are just copied over, pandoc doesn't work because going to HTML
and back is not a perfect conversion. I don't have a good solution for
templating on these pages, but it's currently only the homepage, so I'm not that
worried.

## Security Headers

Check out 
[Security Headers](https://securityheaders.com/?q=danielittlewood.xyz&followRedirects=on)
to see if your site has appropriate headers set. There are a variety of ways to
set them, and I think it's a property of your HTTP server. I don't think I have
access to mine, so I use the `.htaccess` file. Check out [the
source](https://github.com/danielittlewood0/danielittlewood.xyz) to see how
mine is set up.

* [Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy):
  This whitelists external sources from which
  content may be loaded. Since I don't currently load any content from
  anywhere, I set every resource type to `self` (i.e. no external sources).
  [Scott Helme](https://scotthelme.co.uk/content-security-policy-an-introduction/) has
  a good explanation of the various values.
* [X-Frame-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options):
  Not interested in being used as an iframe target, so `DENY`.
* [X-Content-Type-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options):
  It seems that everyone in the world expects this
  header to be set to `nosniff`. MIME type sniffing appears to be a feature,
  but because it exposes some users to malware I guess this feature should be
  permanently overridden using this header.
* [Referrer-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy):
  When hyperlinks on your page link somewhere else, they
  might send the destination server a [Referer
  header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referer)
  which explains that the link was clicked from your domain. You have a choice
  of how much to reveal, and I don't see a good reason to reveal anything.
  Since this is potentially a privacy concern for users, I set this to
  `no-referrer`.
* [Feature-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Feature-Policy):
  Controls a bunch of extra features, and I don't want any of them. So deny all.
* **Forced HTTPS redirect**: This was harder than I expected. My current
  understanding is that not only does this redirection depend on your HTTP
  server, but also on some implementation details, like whether you use a load
  balancer, to ensure that appropriate headers are set. I could not find
  anything in the NFS FAQ regarding this, and the standard answers on the web
  forced me into a redirect loop. Luckily, trying to debug this took me to [a
  StackOverflow
  thread](https://stackoverflow.com/questions/18328601/redirect-loop-while-redirecting-all-http-requests-to-https-using-htaccess)
  which contained a solution that worked for me, namely checking the
  `X-Forwarded-Proto` header. 
