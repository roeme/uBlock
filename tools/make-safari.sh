#!/bin/bash
#

# determine system we're operating under
sys=$(uname -s)

# try to have a python3
pythoncmd=python
pyver=$( $pythoncmd --version 2>&1 | cut -d ' ' -f 2  )
if [[ $pyver != 3.* ]]; then
  pythoncmd=python3
  type -p $pythoncmd >/dev/null || {
    echo "Need Python 3, please adjust 'python' in your path or make 'python3' available."
    exit 1
  }
fi

# make sure xar is around as well
type -p xar >/dev/null || {
  echo "Shell couldn't find xar, please make it available."
  exit 1
}

case $sys in
  Darwin )
    echo "*** uBlock.safariextension: Copying files"
    DES=dist/build/uBlock.safariextension
    [ -d $DES ] && rm -r $DES
    mkdir -p $DES
    cp -R assets $DES/
    rm $DES/assets/*.sh
    cp -R src/css $DES/
    cp -R src/img $DES/
    cp -R src/js $DES/
    cp -R src/lib $DES/
    cp -R src/_locales $DES/
    cp src/*.html $DES/
    cp src/img/icon_128.png $DES/Icon.png
    cp platform/safari/*.js $DES/js/
    cp platform/safari/Info.plist $DES/
    cp platform/safari/Settings.plist $DES/

    echo "*** uBlock_xpi: Generating locales"
    $pythoncmd tools/make-safari-meta.py $DES/

    echo "*** uBlock.safariextension: Package done."
    ;;
  Linux )
    # unmodified code from upstream
    echo "*** uBlock.safariextension: Copying files"
    DES=dist/build/uBlock.safariextension
    rm -r $DES
    mkdir -p $DES
    cp -R assets $DES/
    rm $DES/assets/*.sh
    cp -R src/css $DES/
    cp -R src/img $DES/
    cp -R src/js $DES/
    cp -R src/lib $DES/
    cp -R src/_locales $DES/
    cp src/*.html $DES/
    cp src/img/icon_128.png $DES/Icon.png
    cp platform/safari/*.js $DES/js/
    cp platform/safari/Info.plist $DES/
    cp platform/safari/Settings.plist $DES/

    echo "*** uBlock_xpi: Generating locales"
    python tools/make-safari-meta.py $DES/

    echo "*** uBlock.safariextension: Package done."
    ;;
  * )
    echo "Unknown system: $sys"
    ;;
esac