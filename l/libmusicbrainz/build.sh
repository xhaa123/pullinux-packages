patch -Np1 -i ../libmusicbrainz-5.1.0-cmake_fixes-1.patch
mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release .. &&
make
make DESTDIR=$P install
