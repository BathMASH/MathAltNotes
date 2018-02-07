# Purpose

The purpose of this method is to attempt to automatically 
transform LaTeX learning materials into a variety of more accessible
formats for disabled students. You may find that other students
prefer or make use of some of the formats so please consider making
all formats available to all students.

This is a work in progress and is likely to be unstable. It is not
intended for use with complex LaTeX documents such as books or 
articles for publication. Help and support is available from 
ma-largeprintnotes@bath.ac.uk but only if you are trying to 
create alternative formats for student use. 

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

# Instructions

## Collect a copy of your files

This method of creating alternative formats rewrites the LaTeX.
It works on a copy of your files to protect your original. 
To collect your files run the script ./getMyLaTeX 
on the main LaTeX file in your project. 

E.g. if to make your output from this directory you would run
> pdflatex ../notes/filename.tex
then run
> ./getMyLaTeX ../notes/filename.tex

### Output

This will find all the files needed and put them in a timestamped
directory. That is, if I ran the above command at 11:51 on 29th 
January 2018 it could create the folder filename-180129-1151

### Conditional inclusions in your document

Please be aware that only files used by the current setup will be
collected. For instance, if you have a Beamer document which can
be used to produce slides or an article and you use a command like

> \only&lt;article&gt;{\input{subfile}}

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

### If this fails

If this fails it is because one or more of the formats failed.
You can compile formats individually. Move into your time-stamped
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

## Reporting issues and getting help

This is a work in progress and is likely to be unstable. 
If you have problems email ma-largeprintnotes@bath.ac.uk 
every problem reported will help make the system more stable.
