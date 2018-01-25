# Instructions

Put all your LaTeX files in this directory. 
Put your graphics files in the appropriate subdirectory of figures. You will need to change your graphics includes so that they do not give a path, just a complete filename, including the file extension. 

If your main file is called "file.tex" then run the following:
> make name=file
This will try to make all of the outputs. 

To make individual outputs you can use:
> make standard name=file
> make clear name=file
> make large name=file
> make web name=file
> make word name=file

Outputs will be placed in the built directory. 

To clean up any mess left behind you can type:
> make clean

This is a work in progress! If you have problems email ma-largeprintnotes@bath.ac.uk 
