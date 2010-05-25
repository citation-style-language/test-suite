#!/bin/bash

set -e

cd $(dirname $0)

cd ../manual

function increment() {
  echo Incrementing ...
  DATE=$(date +"%e %B %Y" | sed -e "s/^ //")
  echo $DATE
  VERSION=$(grep '##a*[0-9]\+##' citeproc-test.rst| sed -e "s/.*##a*\([0-9]\+\)##/\1/")
  VERSION=$((VERSION+1))
  echo $VERSION
  cat citeproc-test.rst \
     | sed -e "s/##a*\([0-9]\+##\)/##a$VERSION##/" \
     | sed -e "s/=D=\(.*\)=D=/=D=$DATE=D=/" > tmp-with-markup.txt
}

function noincrement() {
  DATE=$(grep '=D=.*=D=' citeproc-test.rst | sed -e "s/.*=D=\([^=]*\)=D=/\1/")
  echo $DATE
  VERSION=$(grep '##a*[0-9]\+##' citeproc-test.rst| sed -e "s/.*##a*\([0-9]\+\)##/\1/")
  echo $VERSION
  cp citeproc-test.rst tmp-with-markup.txt
}

if [ "$1" == "--increment" ]; then
  increment
else
  noincrement
fi

cat tmp-with-markup.txt \
     | sed -e "s/##a*\([0-9]\+\)##/\\\\ :subscript:\`a$VERSION\`/" \
     | sed -e "s/=D=\(.*\)=D=/$DATE/" > tmp-without-markup.txt

./rst2html4citeproc \
    --stylesheet="./screen-citeprocjs.css" \
    ./tmp-without-markup.txt > ./index.html

cd ..
if [ "$1" == "--increment" ]; then
  scp ./manual/index.html gsl-nagoya-u.net:/http/pub/citeproc-test.html
  mv ./manual/tmp-with-markup.txt ./manual/citeproc-test.rst
fi

tar --create \
    --gzip \
    --exclude="tmp-*" \
    --file ./citeproc-test.tar.gz \
    ./manual/

if [ "$1" == "--increment" ]; then
  scp ./citeproc-test.tar.gz gsl-nagoya-u.net:/http/pub/citeproc-test.tar.gz
fi

rm -f ./manual/tmp-with-markup.txt
rm ./manual/tmp-without-markup.txt
