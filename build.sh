#!/bin/bash
##
# JS/CSS Minifier script for YUI Compressor
# Feel free to make it better :)
# 
# Based on [ymin](https://github.com/keriati/ymin) 
##

yuicompressor=./tools/yuicompressor-2.4.7.jar


# Concatinates files
concat()
{

## Files
FILES="./css/reset.css
./css/normalize.css
./css/classes.css
./css/attributes.css"

	# Remove old file
	rm build/$1
	# Create new blank
	touch build/$1
	# Append content
	#for f in $FILES; do $f >> "build/$1"; done
	cat $FILES > "build/$1"
}

minjs()
{
    echo "Compressing all javascript files:"
    for filein in `find . -name "*.js" | grep -v \.min\.js`
    do
        compress $filein
    done
    echo "Finished!"
}

mincss()
{
    echo "Compressing all css files:"
    for filein in `find . -name "*.css" | grep -v \.min\.css`
    do
        compress $filein
    done
    echo "Finished!"
}

compress()
{
    filein=$1
	fileout=${filein/\.css/\.min\.css}
    fileout=${fileout/\.js/\.min\.js}
    echo "  $filein => $fileout"
    java -jar $yuicompressor $filein > $fileout
}

yhelp()
{
    echo ""
    echo "JS/CSS Minifier script for YUI Compressor"
    echo ""
    echo "Options"
    echo ""
    echo " -a     Compress all files in directory"
    echo " <file> Compress one file in directory"
    echo ""
}

if [ -z $1 ]; then
    yhelp
else
	concat $1
	compress "build/$1"
fi

exit 0

## OLD Build
if [ -z $1 ]; then
    yhelp
else
    case $1 in
        "-a")
            minjs
            mincss
        ;;
        *)
             if [ -f $1 ]; then
                compress $1
             else
                echo ""
                echo "Error: $1 not found!"
                yhelp
            fi
        ;;   
    esac
fi
exit 0
