#!/bin/bash

# This is to detect whether we are running under the mingw64 or ucrt64 msys environment.
# It assumes that the PATH variable has the environment in the first path entry (either mingw64 or ucrt64)
ENVIRONMENT="$(echo $PATH | sed -E "s/^\/([^\/]*)\/.*/\1/")"

visible_echo() {
	echo
	echo
	echo
	echo "######################################################################################################"
	echo "# $1"
	echo "######################################################################################################"
	echo
}

clean() {
	echo "full clean build"
	visible_echo "clean the build"
	rm *.zip
	make clean
	pushd libxavna
	make clean
	pushd xavna_mock_ui
	make clean
	rm -rf ./release
	rm -rf ./debug
	rm -rf ./.qtc_clangd
	popd
	popd

	pushd vna_qt
	make clean
	rm object_script.vna_qt.*
	rm -rf ./release
	rm -rf ./debug
	rm -rf ./.qtc_clangd
	popd
}

if [ "$1" = "clean" ]
then
	clean
	exit 0
fi

if [ "$1" = "quick" ]
then
	echo "quick build"
else
	clean
	
	visible_echo "autoreconf --install"
	autoreconf --install

	visible_echo "./configure"
	./configure
fi

visible_echo "make the libxavna libraries"
make
make debug

visible_echo "libxavna/xavna_mock_ui/"
pushd libxavna/xavna_mock_ui/

visible_echo "qmake and make"
qmake
make
make debug

popd


visible_echo "do the vna_qt"
pushd vna_qt

visible_echo "qmake and make"
qmake
make
make debug

visible_echo "copy the xavna libraries"
cp ../libxavna/.libs/libxavna-0.dll release/
cp ../libxavna/xavna_mock_ui/release/xavna_mock_ui.dll release/

cp ../libxavna/.libs/libxavna-0.dll debug/
cp ../libxavna/xavna_mock_ui/debug/xavna_mock_ui.dll debug/

visible_echo "cleanup the release & debug folder"
rm release/*.cpp release/*.o release/*.h 
rm debug/*.cpp debug/*.o debug/*.h 
rm ../*.zip


pushd release


visible_echo "windeployqt"
windeployqt.exe vna_qt.exe

visible_echo "copy the required dll's"
for f in $(ldd vna_qt.exe | awk '/'"${ENVIRONMENT}"'/{print $3}'); do 
	cp "$f" ./
done

popd

pushd debug


visible_echo "windeployqt"
windeployqt.exe vna_qt.exe

visible_echo "copy the required dll's"
for f in $(ldd vna_qt.exe | awk '/'"${ENVIRONMENT}"'/{print $3}'); do 
	cp "$f" ./
done

popd

visible_echo "zip the released folder"
zip -r ../vna_qt_windows_release.zip release
zip -r ../vna_qt_windows_debug.zip debug



