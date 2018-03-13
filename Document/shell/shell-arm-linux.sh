CC1='/usr/bin/arm-linux-gnueabihf-gcc'
LD='/usr/bin/arm-linux-gnueabihf-ld'
AR='/usr/bin/arm-linux-gnueabihf-ar'
RANLIB='/usr/bin/arm-linux-gnueabihf-ranlib'
STRIP='/usr/bin/arm-linux-gnueabihf-strip'
PREFIX='/home/liuzili/arm-linux-build'
HOST='arm-linux'
export LDFLAGS="-L$PREFIX/lib"
export CPPFLAGS="-I$PREFIX/include"

tar -zxvf zlib-1.2.7.tar.gz;
cd zlib-1.2.7/;
./configure --prefix=$PREFIX --shared;
sed -i "s|CC=gcc|CC=$CC1|g" Makefile;
sed -i "s|LDSHARED=gcc|LDSHARED=$CC1|g" Makefile;
sed -i "s|CPP=gcc|CPP=$CC1|g" Makefile;
sed -i "s|AR=ar|AR=$AR|g" Makefile;
sed -i "s|RANLIB=ranlib|RANLIB=$RANLIB|g" Makefile;
make;
make install;
cd ..;

tar -zxvf libpng-1.6.34.tar.gz;
cd libpng-1.6.34/;
./configure --host=$HOST --prefix=$PREFIX --enable-shared --enable-static CC=arm-linux-gnueabihf-gcc;
sed -i "s|CC = gcc|CC = $CC1|g" Makefile;
sed -i "s|LD = /usr/bin/ld|LD = $LD|g" Makefile;
sed -i "s|STRIP = strip|STRIP = $STRIP|g" Makefile;
sed -i "s|CPP = gcc|CPP = $CC1|g" Makefile;
sed -i "s|AR = ar|AR = $AR|g" Makefile;
sed -i "s|RANLIB = ranlib|RANLIB = $RANLIB|g" Makefile;
make -j;
make install;
cd ..;

tar -zxvf jpegsrc.v8d.tar.gz;
cd jpeg-8d/;
./configure --host=$HOST --prefix=$PREFIX --enable-shared --enable-static CC=arm-linux-gnueabihf-gcc;
sed -i "s|CC = gcc -std=gnu99|CC = $CC1|g" Makefile;
sed -i "s|STRIP = strip|STRIP = $STRIP|g" Makefile;
sed -i "s|LD = /usr/bin/ld|LD = $LD|g" Makefile;
sed -i "s|CPP = gcc|CPP = $CC1|g" Makefile;
sed -i "s|AR = ar|AR = $AR|g" Makefile;
sed -i "s|RANLIB = ranlib|RANLIB = $RANLIB|g" Makefile;
make -j;
make install;
cd ..;

tar -zxvf yasm-1.3.0.tar.gz;
cd yasm-1.3.0/;
CC=arm-linux-gnueabihf-gcc;
./configure --host=$HOST --prefix=$PREFIX --enable-shared --enable-static;
sed -i "s|CC = gcc -std=gnu99|CC = $CC1|g" Makefile;
sed -i "s|CPP = gcc|CPP = $CC1|g" Makefile;
sed -i "s|STRIP = strip|STRIP = $STRIP|g" Makefile;
sed -i "s|AR = ar|AR = $AR|g" Makefile;
sed -i "s|RANLIB = ranlib|RANLIB = $RANLIB|g" Makefile;
make -j;
make install;
cd ..;

tar -xjf last_x264.tar.bz2;
cd x264-snapshot-20171201-2245/;
./configure --enable-shared --host=$HOST --disable-asm --prefix=$PREFIX CC=arm-linux-gnueabihf-gcc;
sed -i "s|CC=gcc|CC=$CC1|g" config.mak;
sed -i "s|AR=gcc-ar|AR=$AR|g" config.mak;
sed -i "s|RANLIB=gcc-ranlib|RANLIB=$RANLIB|g" config.mak;
sed -i "s|LD=gcc -o|LD=$CC1 -o|g" config.mak;
sed -i "s|STRIP=strip|STRIP=$STRIP|g" config.mak;
make -j;
make install;
cd ..;

cp libv41.tar.bz2 $PREFIX/lib;
cd $PREFIX/lib;
tar -xjf libv41.tar.bz2;
rm -f libv41.tar.bz2;
cd -;

tar -zxvf xvidcore_1.3.2.orig.tar.gz;
cd xvidcore-1.3.2/build/generic;
./configure --prefix=$PREFIX --host=$HOST --disable-assembly CC=arm-linux-gnueabihf-gcc;
sed -i "s|CC=gcc|CC=$CC1|g" platform.inc;
sed -i "s|AR=ar|AR=$AR|g" platform.inc;
sed -i "s|RANLIB=ranlib|RANLIB=$RANLIB|g" platform.inc;
make -j;
make install;
cd ../../..;

tar -xjf ffmpeg-1.2.12.tar.bz2;
cd ffmpeg-1.2.12/
./configure \
--enable-cross-compile \
--target-os=linux \
--cc=arm-linux-gnueabihf-gcc \
--arch=arm \
--enable-shared \
--disable-static \
--enable-gpl \
--enable-nonfree \
--enable-ffmpeg \
--disable-ffplay \
--enable-ffserver \
--enable-swscale \
--enable-pthreads \
--enable-yasm \
--disable-stripping \
--enable-libx264 \
--enable-libxvid \
--extra-cflags=-I$PREFIX/include \
--extra-ldflags=-L$PREFIX/lib \
--prefix=$PREFIX;
make -j;
make install;
cd ..;

tar -zxvf opencv-2.4.13.tar.gz;
cd opencv-2.4.13/;
export LD_LIBRARY_PATH=$PREFIX/lib/;
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig;
export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR:$PREFIX/lib/;
mv CMakeLists.txt CMakeLists_backup.txt;
cp ./../CMakeLists.txt ./;
mkdir -p build;
cd build;
mkdir -p install;
mkdir -p lib;
cp -r $PREFIX/lib/* install/;
cp -r $PREFIX/lib/* lib/;
cp ./../../arm-gnueabi.toolchain.cmake ./;
cmake -DCMAKE_TOOLCHAIN_FILE=arm-gnueabi.toolchain.cmake -DCMAKE_BUILD_TYPE=Release ..;
#sed -i "s|WITH_LIBV4L:BOOL=OFF|WITH_LIBV4L:BOOL=ON|g" CMakeCache.txt;
make -j;
make install;
cp -r lib/ ~/lib
