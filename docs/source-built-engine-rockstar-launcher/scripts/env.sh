# Build-Umgebung fuer Wine (CrossOver 26.3 FOSS) auf macOS ohne Xcode
export M4=/opt/brew/opt/m4/bin/m4   # flex nutzt sonst das kaputte /usr/bin/m4 (xcrun-Shim)
export PATH=$HOME/cx-build/toolbin:/opt/brew/opt/m4/bin:/opt/brew/opt/flex/bin:/opt/brew/opt/bison/bin:/opt/brew/opt/llvm/bin:/opt/brew/bin:/usr/bin:/bin
export SDK=$HOME/SDKs/MacOSX14.5.sdk D=$HOME/cx-build/deps
export CC="/opt/brew/opt/llvm/bin/clang -arch x86_64 -isysroot $SDK -mmacosx-version-min=11.0"
export CXX="/opt/brew/opt/llvm/bin/clang++ -arch x86_64 -isysroot $SDK -mmacosx-version-min=11.0"
export LDFLAGS="-fuse-ld=/opt/brew/opt/lld/bin/ld64.lld -L$D/lib"   # NICHT in CC: Wine macht aus unused-argument einen Fehler
export FREETYPE_CFLAGS="-I$D/include/freetype2" FREETYPE_LIBS="-L$D/lib -lfreetype" PKG_CONFIG=/bin/false
export DYLD_FALLBACK_LIBRARY_PATH=$D/lib:/usr/lib
