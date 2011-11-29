#!/usr/bin/env python
""" Build webscratch. Usage: python build.py """

## The next thing to do here is to automate the process of extracting the
## Smalltalk source code from ScratchSourceCode1.4.image. Unfortunately (and
## astoundingly) there doesn't seem to be any obvious way to automate this.
##
## Here is how to do it by hand:
##
##   - Download Scratch from
##     <http://download.scratch.mit.edu/MacScratch1.4.dmg> and install it. You
##     are doing this to get a working Squeak VM that can run Scratch, not for
##     Scratch itself.
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
##         f _ FileStream newFileNamed: 'ScratchSources.txt'.
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
##         perl -p -i -e 's/\r/\n/g' ScratchSources.txt

import zipfile
import os

rootdir = os.path.abspath(os.path.dirname(__file__))
origdir = os.path.join(rootdir, "original-sources")
builddir = os.path.join(rootdir, "build")
sourcesdir = os.path.join(builddir, "sources")

def main():
    assert os.path.isdir(rootdir)
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

if __name__ == '__main__':
    main()
