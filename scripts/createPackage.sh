#!/bin/bash

# Set variables
cubevizRoot="$PWD"
ontowikiRoot="$PWD/application"
cubevizPackage="cubeviz"
packageName="odp-cubeviz"

# Start the action ...
rm -rf $cubevizRoot/$packageName

mkdir $cubevizRoot/$packageName

cd $cubevizRoot/$packageName

echo ""
echo " Copy necessary files of OntoWiki, exclude obsolete ones"
echo ""

rsync -av --exclude='.git' \
          --exclude='.gitignore' \
          --exclude='*.git' \
          --exclude='config.ini' \
          --exclude='build' \
          --exclude='application/logo' \
          --exclude='application/tests' \
          --exclude='application/scripts' \
          --exclude='debian' \
          --exclude='cache/*' \
          --exclude='extensions/cubeviz' \
          --exclude='libraries/ARC2' \
          --exclude='libraries/Erfurt/.git' \
          --exclude='libraries/Erfurt/.gitignore' \
          --exclude='libraries/Erfurt/build.xml' \
          --exclude='libraries/Erfurt/Makefile' \
          --exclude='libraries/Erfurt/README.md' \
          --exclude='libraries/Erfurt/build' \
          --exclude='libraries/Erfurt/debian' \
          --exclude='libraries/Erfurt/tests' \
          --exclude='libraries/Erfurt/library/config.ini-dist-multistore' \
          --exclude='libraries/Erfurt/library/config.ini-dist-mysql' \
          --exclude='libraries/Erfurt/library/config.ini-dist-virtuoso' \
          --exclude='libraries/RDFauthor/.git' \
          --exclude='libraries/RDFauthor/.hgignore' \
          --exclude='libraries/RDFauthor/build.xml' \
          --exclude='libraries/RDFauthor/Readme.md' \
          --exclude='libraries/RDFauthor/debian' \
          --exclude='libraries/RDFauthor/tests' \
          --exclude='logs/*' \
          $ontowikiRoot/* .
          
chmod 0777 cache
          
echo ""
echo " Copy additional files and extensions "
echo ""

cp -R $ontowikiRoot/.htaccess .
cp -R $cubevizRoot/assets/config.ini .
# cp -R $cubevizRoot/deployment/additional-files/config.ini .
# cp -R $cubevizRoot/deployment/additional-files/extensions/page extensions
# cp -R $cubevizRoot/deployment/additional-files/extensions/staticlinks extensions

# cp -R $cubevizRoot/deployment/additional-files/extensions/examplemodel extensions
# cp -R $cubevizRoot/assets/exampleCube.ttl extensions/examplemodel/static/data

# Dirty hack for stupid error message
# cp $cubevizRoot/deployment/additional-files/libraries/Erfurt/Parser.php \
# $ontowikiRoot/libraries/Erfurt/library/libraries/Erfurt/Sparql/Parser.php

echo ""
echo " Delete unneccessary files "
echo ""

rm build.xml
rm config.ini.dist
rm Makefile
rm README.md
rm web.config

rm -rf logs/*

echo ""
echo "Generate lightweight CubeViz version (make tar)"
echo ""

cd $ontowikiRoot/extensions/cubeviz
make cubeviz # generates a lightweight cubeviz tar.gz
cd $ontowikiRoot/extensions/cubeviz/deployment/generated-packages 
tar -pxvzf $cubevizPackage.tar.gz
mv $ontowikiRoot/extensions/cubeviz/deployment/generated-packages/$cubevizPackage $cubevizRoot/$packageName/extensions
cp $ontowikiRoot/extensions/cubeviz/doap.n3 $cubevizRoot/$packageName/extensions/cubeviz

echo ""
echo "Tar folder $packageName to $packageName.tar.gz"
echo ""

cd $cubevizRoot
rm -f $cubevizRoot/$packageName.tar.gz
tar -pcvzf $packageName.tar.gz $packageName
rm -rf $packageName
