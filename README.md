# m2ldr - the *m2\_* script loader

This BASH script `m2_`{.verbatim} provides a means of making putting
lots of small BASH scripts available as commands within a single BASH
script.

The markdown file m2\_.md is transcription of the manual page.

The script is designed to be installed using the GNU stow utility.

The GIT repository can be cloned to /usr/local/stow and then installed
with `stow m2ldr`{.verbatim}

It is also made available as a Debian package which will produce a
package that will install to /usr/local.

# How it works

The script *m2\_* provides an implementation and this is used to provide
the scripts that will load libraries.

To use the implementation as another script, simply link *m2\_* to
another name. There is a demonstration script in share/doc/m2ldr/demo.

To use it, in m2ldr/demo directory, make this link `ln -s $(which m2_)
script0`{.verbatim}

And you should be able to work through the m2\_.md file.
