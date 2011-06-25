#!/usr/bin/env python
""" Build webscratch. Usage: python build.py """

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
