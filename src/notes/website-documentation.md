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


* [Server](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Server):
  This header reveals the type of server your website uses. It can reveal just
  the engine, or the exact version of the HTTP server. [Some
  people](https://techcommunity.microsoft.com/t5/iis-support-blog/remove-unwanted-http-response-headers/ba-p/369710)
  argue that these should be removed, because if an attacker knows your server
  version then they can exploit vulnerabilities targeted at that particular
  version. This sounds like security by obscurity, so I don't find it very
  convincing. Moreover, in my case it only reveals "Apache", and removing the
  header in Apache is disabled [by
  design](https://bz.apache.org/bugzilla/show_bug.cgi?id=40026).
  So I choose to leave this header as-is.

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

* [Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy):
  This whitelists external sources from which
  content may be loaded. Since I don't currently load any content from
  anywhere, I set every resource type to `self` (i.e. no external sources).
  [Scott Helme](https://scotthelme.co.uk/content-security-policy-an-introduction/) has
  a good explanation of the various values.

* [X-Frame-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options):
  This determines whether your site can be referenced in an iframe on an
  external site. If misused, these iframes can be used for clickjacking.  I'm
  not interested in being used as an iframe target, so `DENY`.

* [Permissions-Policy](https://github.com/w3c/webappsec-permissions-policy/blob/master/permissions-policy-explainer.md)
  (previously [Feature-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Feature-Policy)):
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
  `X-Forwarded-Proto` header. **Edit**: It turns out that this setting can be
  configured in my NFS control panel. This was answered in the FAQ (I didn't
  see it first time, because the signed out FAQ is smaller than the signed in
  one). Check with your server provider, if you have one.

* [Strict-Transport-Security](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security):
  Using an HTTPS redirect is good, but each time a user connects to you over
  HTTP, their first request is vulnerable to being intercepted by a man in the
  middle. This header informs the user's browser to *only* connect via HTTPS,
  and (after the first request) to never ever try HTTP again, until the header expires.
  This is problematic if your site is only accessible over HTTP. If a user who
  has received this header tries to access your site, they will be forbidden.

  You can pre-empt even this circumstance by telling browsers that you are
  HTTPS-only. You do this by first enabling the header, and then requesting to
  be added to [the HSTS preload list](https://hstspreload.org/).

* [Expect-CT](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Expect-CT):
  This is a header which declares whether your (presumed HTTPS) site's
  certificate is part of the public [Certificate Transparency
  log](https://www.certificate-transparency.org/). This appears to be a
  blockchain-type cryptographic tree which can be used to verify that
  Certificate Authorities are properly issuing certs. As far as I can tell, at
  the time of writing, all certificates should have this property by default.
  I *do* enforce this, with a lifetime of 24 hours. But I don't specify a URL
  to report violations to, because I don't know where to send them.
