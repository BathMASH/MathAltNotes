# Purpose

The purpose of this method is to attempt to automatically 
transform LaTeX learning materials into a variety of more accessible
formats for disabled students. You may find that other students
prefer or make use of some of the formats so please consider making
all formats available to all students. For instance, some formats
may be useful to students using devices with small screens. 

This is a work in progress and is likely to be unstable. It is not
intended for use with complex LaTeX documents such as books or 
articles for publication. Help and support is available from 
ma-largeprintnotes@bath.ac.uk but only if you are trying to 
create alternative formats for student use at the University of Bath.

## The alternative formats

The method will compile a standard format which should be basically
the same as your usual PDF output. In addition it will attempt to
create clear print PDF, large print PDF, an accessible web format 
and an accessible word format. The large print and word formats
are currently considered experimental and are more likely to fail
than the others. 

### Accessible web and word formats

These formats can be used by students who need to adapt resources 
or to use assistive technology to enable them to access resources. 
Depending on the requirements of the student and the assistive 
technology they have they may require one or the other. These formats
are not interchangeable. 

If you would like to know more about how these formats can be
used please email ma-largeprintnotes@bath.ac.uk

# Instructions

## Setup

This method has many dependencies and currently only works on the
command line, in Linux and with the correct setup. We do not have
the resources to help people set up their own machines to run
the method so we have produced a docker build in which the tool 
will definitely run. 

## Getting the tool 

To get a copy of the tool which can also be updated:

1. Be able to run docker builds. You should probably ask someone, or the internet for help with that if you have no idea what this means. If you are based at the University of Bath then please email ma-largeprintnotes@bath.ac.uk to ask for help. 

2. Change directory into the directory which contains the LaTeX you wish to process (and any files needed by that document) and run the build with the command:

> docker run -it -v $(pwd):/home/mathaltuser/$(whoami) bathmash/mathaltnotes

3. Change director to MathAltNotes:

> cd MathAltNotes

You can now use the instructions below. 

## Collect a copy of your files

This method of creating alternative formats rewrites the LaTeX.
It works on a copy of your files to protect your original. Even so
we still recommend that you have your originals backed up elsewhere.
To collect your files run the script ./getMyLaTeX 
on the main LaTeX file in your project. 

<<<<<<< HEAD
> ./getMyLaTeX ../yourusername/filename.tex
=======
> ./getMyLaTeX ../notes/filename.tex
>>>>>>> External readme

### Outcome

This will find all the files needed and put them in a timestamped
directory. That is, if I ran the above command at 11:51 on 29th 
January 2018 it could create the folder filename-180129-1151

### Conditional inclusions in your document

Please be aware that only files used by the current setup will be
collected. For instance, if you have a Beamer document which can
be used to produce slides or an article and you use a command like

> '\only<article>{\input{subfile}}'

then the subfile will only be collected by the script if the
document is currently set to compile the article format.

## Compiling the alternative formats

Once you have collected the files you can make all the formats with
for instance:
> ./quickMake filename-180129-1151

Or, if this is a Beamer presentation:
> ./quickBeamerMake filename-180129-1151

Once this has finished you will find the outputs in the folder
filename-180129-1151/built

You can view outputs by opening them on your computer in the usual way.
Please note that the Word documents
may only work in Word 365. In particular many images will only 
work in this format. 

### If this fails

If this fails it is because one or more of the formats failed. 

If only the web and word format failed you can try:
> ./quickSloppyMake filename-180129-1151

but please read the warnings. 

You can also compile formats individually. Move into your time-stamped
directory:
> cd filename-180129-1151

then try any of these:
> make standard name=filename

> make clear name=filename

> make large name=filename

> make web name=filename

> make word name=filename

For Beamer slides:
> make standard name=filename

> make clearbart name=filename

> make largebart name=filename

> make web name=filename

> make word name=filename

For sloppy web and word, as a last resort (and please contact us for 
help too) try:
> make websloppy name=filename

> make wordsloppy name=filename

## Reporting issues and getting help

This is a work in progress and is unstable!
 
If you have problems email ma-largeprintnotes@bath.ac.uk to report them.
We may eventually solve the problem but make no promises!

# Providing files to students

We recommend providing the alternative formats to all students.
Whether you provide these prior to class depends on the 
resource and your teaching practice. 

