# m2ldr - the m2\_ script loader

This BASH script m2\_ provides a means of making lots of small BASH
scripts available as commands within a single BASH script.

The markdown file m2\_.md is transcription of the manual page.

The script is designed to be installed using the GNU stow utility.

The GIT repository can be cloned to /usr/local/stow and then installed
with `stow m2ldr`{.verbatim}

It is also made available as a Debian package which will produce a
package that will install to /usr/local - not allowed by default with
Debian.

# How it works

The script m2\_ provides an implementation and this is used to provide
the scripts that will load libraries.

To use the implementation as another script, simply link *m2\_* to
another name. There is a demonstration script in share/doc/m2ldr/demo.

To use it, in m2ldr/demo directory, make this link `ln -s $(which m2_)
script0`{.verbatim}

And you should be able to work through the m2\_.md file.

# What it gives you

The functions in a library script will share a common set of
command-line options: -f -O -l -n and many others.

The script provides a line error trapping mechanism that can catch
syntax errors.

Utilities include path-parsing for file paths and URLs. A stack
mechanism that is used to implement temporary file management.

The most useful feature is the syslog compliant logging system, that
uses a numbered file descriptor:
`echo $FUNCNAME: logging message >& 7`{.verbatim}

All of which makes it a very convenient and powerful way of running and
maintaining a large code-base of BASH scripts.
