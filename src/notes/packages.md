# How should packages be managed under a customisable system?

I have a problem, and have had this problem for a while. The programs I
frequently work with come in three forms: 

* Unmodified, externally maintained packages.
* Patched packages which are externally maintained.
* Fully custom packages which are not externally maintained.

The primary reason I moved to gentoo is because a source-based package manager
gives a satisfying solution to this problem. Namely:

* Unmodified packages are installed from a repository.
* Modified packages are *patched* before compilation.
* Unmaintained packages are *maintained as ebuilds* (or as simple scripts) by me.

The case of maintained packages is no different from any other system. 

For self-hosted packages, the situation is not very different from the
situation with the default approach (i.e. nothing). Nobody else is able to
maintain the software because only you know exactly what it means to maintain
the package. In other words: *You are the maintainer*.

However, there is an important difference between being a maintainer in a
language like Gentoo, which is that the artificial barrier between maintaining
software for only *your* use and maintaining software for *everyone's* use is
much thinner. If you have an ebuild that works for your applications, then you
can distribute it. 
