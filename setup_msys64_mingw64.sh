#!/bin/bash

# original up-stream repo
#GITREPO="https://github.com/nanovna-v2/NanoVNA-QT.git"

# forked git repo
GITREPO="https://github.com/GrahamY1970/NanoVNA-QT.git"

OPTIONS="--noconfirm --needed"


pacman -Syuu ${OPTIONS}

pacman -S mingw-w64-x86_64-gcc ${OPTIONS}
pacman -S mingw-w64-x86_64-toolchain ${OPTIONS}
#pacman -S mingw-w64-x86_64-geany ${OPTIONS}
pacman -S zip ${OPTIONS}
pacman -S git ${OPTIONS}

pacman -S autotools ${OPTIONS}
pacman -S automake ${OPTIONS}
pacman -S libtool ${OPTIONS}

pacman -S mingw-w64-x86_64-eigen3 ${OPTIONS}
pacman -S mingw-w64-x86_64-fftw ${OPTIONS}
pacman -S mingw-w64-x86_64-angleproject ${OPTIONS}
pacman -S mingw-w64-x86_64-qt5 ${OPTIONS}
pacman -S mingw-w64-x86_64-qt-creator ${OPTIONS}

#git clone $GITREPO

#cd NanoVNA-QT/
./deploy_windows_msys64.sh
