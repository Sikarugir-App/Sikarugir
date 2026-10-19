#!/bin/zsh
# Die Wine-Loader muessen mit Apples ld64 gelinkt werden (segaddr/segalign), nie mit lld.
cd ~/cx-build/wine-build; source ~/cx-build/env.sh; L=$HOME/cx-build/host/bin/ld64-apple
rm -f loader/wine loader/wine-preloader
make CC="$CC -fuse-ld=$L" LDFLAGS="-fuse-ld=$L -L$D/lib" loader/wine loader/wine-preloader > relink-loaders.log 2>&1 || { echo FEHLER; tail -3 relink-loaders.log; exit 1; }
S=~/Applications/Sikarugir/Untitled.app/Contents/SharedSupport
make install STRIP=true CC="$CC -fuse-ld=$L" LDFLAGS="-fuse-ld=$L -L$D/lib" > install-loaders.log 2>&1
for f in wine wine-preloader; do cp $HOME/cx-build/out/bin/$f $S/wine/bin/$f; done
echo "Loader neu gelinkt und verteilt"
