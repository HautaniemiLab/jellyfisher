#!/bin/sh

LIBDIR=../inst/htmlwidgets/lib/jellyfish

if ! command -v npm &> /dev/null
then
    echo "npm could not be found, please install it to proceed."
    exit 1
fi

echo "Updating and building jellyfish..."

git submodule update --init --recursive

cd jellyfish

npm install
npm run build:lib

cd ..

cp jellyfish/dist/lib/jellyfish.umd.js $LIBDIR/
cp jellyfish/dist/lib/lib.css $LIBDIR/

echo "Done."