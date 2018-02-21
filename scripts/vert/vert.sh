#!/bin/bash

echo "Before transforming your LaTeX we need to check for delimiters"
echo "which do not have \left or \right defined. This includes | and"
echo "\| for instance. This is not a job that a computer can do, it"
echo "requires a mathematically trained human with enough time to "
echo "look at every case in every file in your project. "
echo "If you are a suitable human with time to do this now press y"
echo "otherwise press n, press enter after your choice."

read decision

if [ $decision != "y" ]; then
    exit 1
fi

echo "We will try to isolate the problem as far as we can but you "
echo "need to pay attention! For each possible instance you will "
echo "need to press y to make the plausible change and n not to. "
echo "Be careful, for instance | is often used in tabular notation "
echo "or in a set definition and for these the answer would be n"
echo "but if it is part of a pair of delimiters you need to replace "
echo "the first with \left| and the second with \right| BUT we will "
echo "have to do all the \left first and then all the \right"

echo "Are you still happy to continue? [y/n then enter]"

read decision

if [ $decision != "y" ]; then
    exit 1
fi

echo "First we do \|"
echo "============="

files=`find . -maxdepth 1 -name '*.tex' | xargs grep -Ple '(?<!left|right)\\\|'`

if [[ -z "$files" ]]; then
    echo "No matching .tex"
    exit 1
fi  

echo "The following files need attention:" 
echo $files
echo "They will open one after another, first we do ALL the \left"
echo "replacements and then ALL the \right. Ready? [y/n then enter]"

read decision

if [ $decision != "y" ]; then
    exit 1
fi

for i in $files; do
    vim -c "set hidden | bufdo %s/\\\|/\\\left\\\|/gce" $i -c :wq
done

for i in $files; do
    vim -c "set hidden | bufdo %s/\\\|/\\\right\\\|/gce" $i -c :wq
done

# vim -c "set hidden | bufdo %s/\\\|/\\\left\\\|/gce" $files -c :wq
# vim -c "set hidden | bufdo %s/\\\|/\\\right\\\|/gce" $files -c :wq

echo "Now we do |"
echo "============="

files=`find . -maxdepth 1 -name '*.tex' | xargs grep -Ple '(?<!\\\|left|right)\|'`

if [[ -z "$files" ]]; then
    echo "No matching .tex"
    exit 1
fi  

echo "The following files need attention:" 
echo $files
echo "They will open one after another, first we do ALL the \left"
echo "replacements and then ALL the \right. Ready? [y/n then enter]"

read decision

if [ $decision != "y" ]; then
    exit 1
fi

for i in $files; do
    vim -c "set hidden | bufdo %s/|/\\\left|/gce" $i -c :wq
done

for i in $files; do
    vim -c "set hidden | bufdo %s/|/\\\right|/gce" $i -c :wq
done

# vim -c "set hidden | bufdo %s/|/\\\left|/gce" $files -c :wq
# vim -c "set hidden | bufdo %s/|/\\\right|/gce" $files -c :wq

echo "Finally we do \vert"
echo "==================="

files=`find . -maxdepth 1 -name '*.tex' | xargs grep -Ple '(?<!left|right)\\\vert'`

if [[ -z "$files" ]]; then
    echo "No matching .tex"
    exit 1
fi  

echo "The following files need attention:" 
echo $files
echo "They will open one after another, first we do ALL the \left"
echo "replacements and then ALL the \right. Ready? [y/n then enter]"

read decision

if [ $decision != "y" ]; then
    exit 1
fi

for i in $files; do
    vim -c "set hidden | bufdo %s/\\\vert/\\\left\\\vert/gce" $i -c :wq
done

for i in $files; do
    vim -c "set hidden | bufdo %s/\\\vert/\\\right\\\vert/gce" $i -c :wq
done

# vim -c "set hidden | bufdo %s/\\\vert/\\\left\\\vert/gce" $files -c :wq
# vim -c "set hidden | bufdo %s/\\\vert|/\\\right\\\vert/gce" $files -c :wq
