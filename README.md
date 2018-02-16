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

If you would like to know more about how these formats can be
used please email ma-largeprintnotes@bath.ac.uk

# Instructions

## Setup

This method has many dependencies and currently only works on the
command line, in Linux and with the correct setup. We do not have
the resources to help staff set up their own machines to run
the method. 

Computing Services has agreed to ensure that 
> linux.bath.ac.uk 

has the requisite setup. Hence, all staff should be able to use
this. For help using linux.bath.ac.uk see http://www.bath.ac.uk/guides/connecting-to-linux-bath/

## Getting the tool 

To get a copy of the tool which can also be updated:
1. Use a web browser to visit https://github.bath.ac.uk/MathsAccessibleNotes/MathAltNotes so you exist on the system. You can see this readme there and also the files but the right way to get a copy of the files is to use git on the command line. This way you can update the tool as we make changes. 
2. Log in to linux.bath.ac.uk and 'clone' the tool. This will make a directory called MathAltNotes where the tool can be found: 

> git clone https://github.bath.ac.uk/MathsAccessibleNotes/MathAltNotes.git

and use your Computing Services login details. 

3. Change director to MathAltNotes:

> cd MathAltNotes

You can now use the instructions below. 

Each time you come back to use MathAltNotes you should update it in case
we have made changes. You can do this using:
> git pull

and use your Computing Services login details. 

## Collect a copy of your files

This method of creating alternative formats rewrites the LaTeX.
It works on a copy of your files to protect your original. Even so
we still recommend that you have your originals backed up elsewhere.
To collect your files run the script ./getMyLaTeX 
on the main LaTeX file in your project. 

E.g. if to make your output from this directory you would run
> pdflatex ../notes/filename.tex

then run
> ./getMyLaTeX ../notes/filename.tex

### Outcome

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

When working on linux.bath.ac.uk you can view outputs by locating
the folder on your H drive. 

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
 
If you have problems email ma-largeprintnotes@bath.ac.uk and 
attach a zip of your time-stamped directory if possible. 

Every problem reported will help make the system more stable.
We will delete time-stamped directories after we have used
them to understand and fix the issue. 

# Providing files to students

We recommend providing the alternative formats to all students.
Whether you provide these prior to class depends on the 
resource and your teaching practice. 

## Putting the files on Moodle

Most of the formats can be uploaded to Moodle in the usual way.
The only resource which needs special attention is the web format.
You will see that this is provided as a folder and a zipped 
archive in the built directory. To upload this to Moodle you need
to upload the zipped archive as a file and then set it up:
* Select Add a resource -> File. Give the resource a name (e.g. MA10230 web notes).
* Add the zip file. Right click on the zip file, a window appears, click on unzip and wait until complete. 
* Right click on the zip again and click on delete. You will have a folder remaining. 
* Left click on the folder to open it. 
* Find the main file e.g. MA10230-web.html and right click on this, 
a window appears, click on Set main file. 
* Change any other settings you wish in the resource and then save. 

### Providing files to only some students

You will likely have some disabled students with a 
Disability Access Plan (DAP) in your class. DAPs can be viewed 
on SAMIS. If a student's DAP recommends that learning resources 
are provided prior to class and you don't wish to provide them
to all students then you may need to set up Moodle so that only 
these students can see certain resources. 

The easiest way to do this if you are in the Department of Mathematical
Sciences is to ask us to set it up for you on one of the alternative 
notes Moodle pages. We will give you access and tell you what to do. 

If you want to do this on your own Moodle page then you will need to 
create a separate topic which can only be seen by certain students. 

Please be very careful if you do this yourself, it is easy to accidentally
break a student's confidentuality. 

To do this:
* Make an empty topic
* Click on Edit -> Edit topic
* Unclick Use default section name and give the topic an appropriate title
* At the base of the page click on the arrow next to Restrict access
* Click on Add restriction...
* A window appears, select Restriction set but leave it as it is for now
* Click on Add restriction... at the very base of the page again and 
again select Restriction set. 
* At the top of the section change "Student must (drop down) match all (drop down)" 
to "Student must (drop down) match any (drop down)". Then BEFORE YOU DO ANYTHING 
ELSE click on the eye next to this line so it is crossed through. This
is necessary to ensure you do not break confidentuality and will completely
hide the section from all other students.

Now you can add students in to the restriction sets. We suggest you add
yourself first so you can test it by viewing the page as a student:
* Inside one of the grey boxes click on the Add restriction... button and 
then select User profile
* Set it so a student "must" (first drop down) match the following 
** Under User profile field select "First name"
** Leave middle drop down as "is equal to" 
** Add your first name into the box
* Now click on the Add restriction... button within the grey box again and again
select User profile. This time add a restriction on your Surname.
* Now add the student to the second grey box in the same way. 
* Further students can be added by adding new restriction sets. 

You should end up with a series of restrictions in grouped pairs of first name 
and surname linked by "and" and the pairs linked by "or".  

Save the page and test it works. To test it change your view to student view 
(Administration -> Switch role to...) and check that you can see the topic. 
Now edit the restrictions and change your surname, for instance. Then, in
student view you should no longer be able to see the topic at all. If in student
view you can still see the topic but greyed out then you MUST change this
otherwise students can see who has access to the topic. 

Any problems, mail us: ma-largeprintnotes@bath.ac.uk 