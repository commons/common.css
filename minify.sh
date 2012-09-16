#!/bin/bash
##
# JS/CSS Minifier script for YUI Compressor
# Feel free to make it better :)
# 
# Based on [ymin](https://github.com/keriati/ymin) 
##

yuicompressor=./tools/yuicompressor-2.4.7.jar

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
