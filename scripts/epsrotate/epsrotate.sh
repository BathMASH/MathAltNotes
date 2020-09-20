#!/bin/bash
usage="USAGE: ${0##*/} <options> file1 [file2 ..]
options are:
  -a <n>    : set angle (default=90)
  -o <file> : set output filename (default=out)
  -x        : overwrite input file (default=false)
  -c        : crop file (default=true)"

##### default settings #####
angle=90
out="out"
overwrite=false
crop=true
while getopts "a:o:xch" opt; do
  case $opt in
    a ) angle=$OPTARG;;
    o ) out=$OPTARG;;
    x ) overwrite=true;;
    c ) crop=false;;
    h ) echo -e "$usage"; exit;;
  esac
done
shift $(($OPTIND - 1))
if [ $# -eq 0 ]; then echo "specify a filename."; echo -e "$usage"; exit; fi
##### end of options #####

i=1
for file in $*; do 
  if [ ! -f "$file" ]; then echo "no such file: $file"; exit 3; fi
  if [ $# -gt 1 ]; then outfile="$out"_"$i.eps"; ((i++)); else outfile="$out.eps"; fi
  if $overwrite; then outfile=$file; fi
  # overwrite checks
  if [ -f "$outfile" ]; then echo "$outfile exists, overwriting."; fi
  if [ -f "tmp_$file" ]; then echo "tmp.$file exists, overwriting."; fi
  
  # NOTE:
  # postscript's rotate rotates counterclockwise around 
  # the lower left corner of the figure's bounding box 
  
  awk -v angle=$angle \
    '{
      if($1=="%%BoundingBox:") {
        xmin=$2; ymin=$3; xmax=$4; ymax=$5; 
        pi=4*atan2(1,1)
        rad=angle*pi/180.
        c=cos(rad)
        s=sin(rad)
  
        # rotate corner points of the bounding box
        # (xmin,ymin)
        x[1]=xmin*c+ymin*s
        y[1]=ymin*c-xmin*s
        # (xmin,ymax)
        x[2]=xmin*c+ymax*s
        y[2]=ymax*c-xmin*s
        # (xmax,ymin)
        x[3]=xmax*c+ymin*s
        y[3]=ymin*c-xmax*s
        # (xmax,ymax)
        x[4]=xmax*c+ymax*s
        y[4]=ymax*c-xmax*s
  
        # determine the max and min for x and y
        for(i in x) { if (xminn=="" || x[i]<xminn) xminn=x[i] }
        for(i in x) { if (xmaxn=="" || x[i]>xmaxn) xmaxn=x[i] }
        for(i in y) { if (yminn=="" || y[i]<yminn) yminn=y[i] }
        for(i in y) { if (ymaxn=="" || y[i]>ymaxn) ymaxn=y[i] }
  
        # make all coordinates positive (this is convenient for cropping)
        dx=xmaxn-xminn
        dy=ymaxn-yminn
        print "%%BoundingBox: ",0,0,dx,dy
  
        # alternatively (remove also the translate)
        #print "%%BoundingBox: ",xminn,yminn,xmaxn,ymaxn
      }
      else {
        if($1!="%%HiResBoundingBox:") {
          print $0
          if($1=="%%BeginProlog" && !stop) {
            print -xminn,-yminn," translate"
            print -angle," rotate"
          }
        }
      }
     }' "$file" > "tmp.$file"

  if $crop; then 
    if [ -f "tmp.$file.box" ]; then echo "tmp.$file.box exists, overwriting."; fi
    gs -sDEVICE=bbox -dNOPAUSE "tmp.$file" -c quit 1>/dev/null 2> "tmp.$file.box"
    bbox=`head -1 "tmp.$file.box"`
    sed -i "2 s/.*/$bbox/g" "tmp.$file"
    rm "tmp.$file.box"
  fi
  mv "tmp.$file" "$outfile"
  echo "$outfile"

done
