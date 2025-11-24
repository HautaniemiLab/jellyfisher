#!/bin/sh

SUBMODULE_DIR="jellyfish"
LIBDIR="../inst/htmlwidgets/lib/jellyfish"

if ! command -v npm &> /dev/null
then
    echo "npm could not be found, please install it to proceed."
    exit 1
fi

SUBMODULE_STATUS=$(git status "$SUBMODULE_DIR" --porcelain)
if echo "$SUBMODULE_STATUS" | grep -q "^ M"; then
    echo "The submodule '$SUBMODULE_DIR/' has uncommitted changes. Please commit or stash them before proceeding."
    exit 1
fi

if [ ! -d "$SUBMODULE_DIR/.git" ]; then
    echo "Initializing submodule '$SUBMODULE_DIR'..."
    git submodule update --init --recursive
else
    echo "Updating submodule '$SUBMODULE_DIR'..."
    git submodule update --recursive
fi

echo "Updating and building jellyfish..."

echo "Building Jellyfish..."

cd "$SUBMODULE_DIR" || exit

npm ci
npm run build:lib
npm run build:schema

cd ..

echo "Copying built files to '$LIBDIR'..."
mkdir -p "$LIBDIR"
cp "$SUBMODULE_DIR/dist/lib/jellyfish.umd.js" "$LIBDIR/"
cp "$SUBMODULE_DIR/dist/lib/lib.css" "$LIBDIR/"

echo "Done."
