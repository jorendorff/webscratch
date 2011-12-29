""" recode.py - Recode a file from 8-bit characters to UTF-8.

See Makefile.
"""

import codecs

def recode(source, dest):
    with codecs.open(source, 'rb', 'iso8859-1') as infile:
        junk = infile.read()
    with codecs.open(dest, 'w', 'utf-8') as outfile:
        outfile.write(junk)

if __name__ == '__main__':
    import sys
    if len(sys.argv) != 3:
        print "usage: python recode.py RAWFILE FILE.utf8"
    recode(sys.argv[1], sys.argv[2])
