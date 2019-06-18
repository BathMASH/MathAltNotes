home=$(dirname $(readlink -f $0))
cd $1

for i in `find . -maxdepth 1 -name "*.pre-vert" -type f`; do
    echo "Processing: $i"
    mv $i $(basename "$i" .pre-vert).tex
done
echo "-----------------------------------------------------------------"

