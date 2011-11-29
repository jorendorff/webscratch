#!/usr/bin/env python
""" Build webscratch. Usage: python build.py """

## The next thing to do here is to automate the process of extracting the
## Smalltalk source code from ScratchSourceCode1.4.image.  Unfortunately (and
## astoundingly) there doesn't seem to be any obvious way to automate this.
##
## Here is how to do it by hand on Mac; something very similar will work for
## Linux and Windows.  This process creates a single file,
## build/sources/ScratchSource1.4/ScratchSources.st.
##
##   - Download Scratch from <http://info.scratch.mit.edu/Scratch_1.4_Download>
##     and install it.  You are doing this to get a working Squeak VM that can
##     run Scratch, not for Scratch itself.
##
##   - Run these commands:
##         cd webscratch
##         python build.py       # (run this script to unzip the original-sources)
##         cd build/sources/ScratchSource1.4
##         /Applications/Scratch\ 1.4/Scratch.app/Contents/MacOS/Scratch "$PWD"/ScratchSourceCode1.4.image
##
##     Apparently for Squeak to work, you really do have to give it an absolute
##     path to the .image file, so $PWD is required as opposed to just ".".
##
##   - Open a Workspace by clicking on some empty space, selecting "open...",
##     and selecting "workspace".
##
##   - Paste this snippet of code into the workspace:
##         |f|
##         f _ FileStream newFileNamed: 'ScratchSources.st'.
##         SystemOrganization categories do:
##             [:c | SystemOrganization fileOutCategory: c on: f].
##         f close.
##
##   - Select the code, control+click on a part of the window below all the
##     text, and select "do it (d)".
##
##     If it asks you whether to overwrite the file, say yes.
##
##     When it asks you whether to "FileOut selected sharedPools" or
##     "FileOut sharedPool TextConstants", say yes.
##
##   - Close Squeak. Don't bother saving changes.
##
##   - Run this command to fix up the old-school Mac newlines in the file:
##         perl -p -i -e 's/\r/\n/g' ScratchSources.st

import os, zipfile, codecs, subprocess

rootdir = os.path.abspath(os.path.dirname(__file__))
origdir = os.path.join(rootdir, "original-sources")
builddir = os.path.join(rootdir, "build")
sourcesdir = os.path.join(builddir, "sources")

def main():
    assert os.path.isdir(rootdir)

    # unzip original-sources to build/sources
    if not os.path.isdir(sourcesdir):
        print "mkdir", sourcesdir
        os.makedirs(sourcesdir)
    files = ['ScratchPluginSrc1.4.zip',
             'ScratchSource1.4.zip',
             'ScratchSkin1.4.zip']
    for f in files:
        print "unzip", f
        zf = zipfile.ZipFile(os.path.join(origdir, f), 'r')
        try:
            zf.extractall(sourcesdir)
        finally:
            zf.close()

    # Check for ScratchSources.st.
    sources_latin1 = os.path.join(sourcesdir, 'ScratchSource1.4', 'ScratchSources.st')
    if not os.path.isfile(sources_latin1):
        print "build/sources/ScratchSource1.4/ScratchSources.st must be built manually."
        print "Follow the instructions in build.py, then re-run this script."
        return

    # Mozilla's JS engine can only read UTF-8 files, not binary. But Squeak
    # Smalltalk source files are really 8-bit; they may contain strings with
    # non-ASCII bytes which should be retained.
    #
    # Solution: a horrible horrible hack. Treat the 8-bit binary data as if it
    # were Latin-1 data. Then UTF-8-encode it.
    #
    # Queasymaking. Just ignore it. It works.
    #
    sources_utf8 = os.path.join(sourcesdir, 'ScratchSource1.4', 'ScratchSources.st.utf8')
    with codecs.open(sources_latin1, 'rU', 'iso8859-1') as infile:
        st = infile.read()
    with codecs.open(sources_utf8, 'w', 'utf-8') as outfile:
        outfile.write(st)
    print

    # Check for a JS engine.
    if 'JS' not in os.environ:
        print "JS environment variable not set."
        print "The build script requires Mozilla's JS shell to be installed."
        print "export JS='full/path/to/js -m -n' and try again!"
        return

    # Run a test.
    cmd = os.environ['JS'] + ' handmade-test.js'
    tests_dir = os.path.join(rootdir, 'js', 'tests')
    print 'cd %s && %s' % (tests_dir, cmd)
    subprocess.check_call(cmd, shell=True, cwd=tests_dir)
    print

    # Compile ScratchSources.st to JS.
    sources_js = os.path.join(builddir, 'ScratchSources.js')
    cmd = os.environ['JS'] + ' main.js "' + sources_utf8 + '"'
    print cmd, " > " + sources_js
    with open(sources_js, 'wb') as outfile:
        subprocess.check_call(cmd, shell=True, cwd=os.path.join(rootdir, 'js'), stdout=outfile)

if __name__ == '__main__':
    main()
