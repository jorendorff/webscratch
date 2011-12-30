How to build webscratch
=======================

Building webscratch involves extracting the Smalltalk source code from
ScratchSourceCode1.4.image.  Unfortunately (and astoundingly) there
doesn't seem to be any obvious way to automate this.

Here is how to do it by hand on Mac; something very similar will work for
Linux and Windows.  This process creates two files,
build/sources/ScratchSource1.4/ScratchSources.st and objectdump.txt.

  - Download Scratch from <http://info.scratch.mit.edu/Scratch_1.4_Download>
    and install it.  You are doing this to get a working Squeak VM that can
    run Scratch, not for Scratch itself.

  - Run these commands:
        cd webscratch
        GO=1 make

  - Click on the yellow Workspace window. Delete all that text in it.

  - Paste this snippet of code into the workspace:

        Compiler evaluate: (FileStream readOnlyFileNamed:
            (FileDirectory default relativeToFullPath: '../../../st/dumpImage.st'))

  - Select the code, control+click on a part of the window below all the
    text, and select "do it (d)".

    When it asks you whether to "FileOut selected sharedPools", say no.

    It will take a really long time because it's dumping 28MB+ of data.
    When it's done, Squeak will exit.

