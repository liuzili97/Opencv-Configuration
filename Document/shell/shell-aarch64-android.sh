CC1='/opt/toolchains/android-toolchain-aarch64/bin/aarch64-linux-android-gcc'
LD='/opt/toolchains/android-toolchain-aarch64/bin/aarch64-linux-android-ld'
AR='/opt/toolchains/android-toolchain-aarch64/bin/aarch64-linux-android-ar'
RANLIB='/opt/toolchains/android-toolchain-aarch64/bin/aarch64-linux-android-ranlib'
STRIP='/opt/toolchains/android-toolchain-aarch64/bin/aarch64-linux-android-strip'
PREFIX='/home/liuzili/aarch64-android-build'
HOST='aarch64-linux-android'
TOOLCHAINS='/opt/toolchains/android-toolchain-aarch64'
SYSROOT=$TOOLCHAINS/sysroot
CROSS_PREFIX=$TOOLCHAINS/bin/aarch64-linux-android-
YOUR_BUILD_PATH='~/ad-aarch64'
EXTRA_CFLAGS="-march=armv8-a -D__ANDROID__ -D__ARM_ARCH_8__ -D__ARM_ARCH_8A__"
EXTRA_LDFLAGS="-nostdlib"
export LDFLAGS="-Wl,-rpath-link,$PREFIX/lib";
export CPPFLAGS="-I$PREFIX/include";

tar -zxvf zlib-1.2.7.tar.gz;
cd zlib-1.2.7/;
./configure --prefix=$PREFIX --shared;
sed -i "s|CC=gcc|CC=$CC1|g" Makefile;
sed -i "s|LDSHARED=gcc|LDSHARED=$CC1|g" Makefile;
sed -i "s|CPP=gcc|CPP=$CC1|g" Makefile;
sed -i "s|AR=ar|AR=$AR|g" Makefile;
sed -i "s|RANLIB=ranlib|RANLIB=$RANLIB|g" Makefile;
make -j;
make install;
cd ..;

tar -zxvf libpng-1.6.34.tar.gz;
cd libpng-1.6.34/;
./configure --host=$HOST --prefix=$PREFIX --enable-shared --enable-static CC=$CC1;
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
./configure --host=arm-linux-android --prefix=$PREFIX --enable-shared --enable-static CC=$CC1;
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
./configure --host=$HOST --prefix=$PREFIX --enable-shared --enable-static CC=$CC1;
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
./configure --prefix=$PREFIX \
 --host=aarch64-linux-android \
 --sysroot=$SYSROOT \
 --cross-prefix=$CROSS_PREFIX \
 --extra-cflags="$EXTRA_CFLAGS" \
 --extra-ldflags="$EXTRA_LDFLAGS" \
 --enable-pic \
 --enable-static \
 --enable-shared \
 --enable-strip \
 --disable-cli \
 --disable-win32thread \
 --disable-avs --disable-swscale --disable-lavf --disable-ffms --disable-gpac --disable-lsmash
make clean;
make STRIP= -j8 install;
cd ..;

tar -zxvf xvidcore_1.3.2.orig.tar.gz;
cd xvidcore-1.3.2/build/generic;
./configure --prefix=$PREFIX --host=arm-linux-android --disable-assembly CC=$CC1;
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
--cc=$CC1 \
--arch=arm64 \
--enable-shared \
--enable-static \
--enable-gpl \
--enable-nonfree \
--enable-ffmpeg \
--disable-ffplay \
--enable-ffserver \
--enable-swscale \
--disable-symver \
--enable-pthreads \
--disable-yasm \
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
cp  ./../platforms/android/android.toolchain.cmake ./;
sed -i '$a\set(CMAKE_C_COMPILER /opt/toolchains/android-toolchain-aarch64/bin/aarch64-linux-android-gcc)' android.toolchain.cmake
sed -i '$a\set(CMAKE_CXX_COMPILER /opt/toolchains/android-toolchain-aarch64/bin/aarch64-linux-android-g++)' android.toolchain.cmake
sed -i '$a\set(CMAKE_FIND_ROOT_PATH "$YOUR_BUILD_PATH/opencv-2.4.13/build")' android.toolchain.cmake
sed -i '$a\link_directories(${PREFIX}/lib)' android.toolchain.cmake
sed -i '$a\set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)' android.toolchain.cmake
sed -i '$a\set(CMAKE_FIND_ROOT_PATH_MODE_LIBRAY ONLY)' android.toolchain.cmake
sed -i '$a\set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)' android.toolchain.cmake

export ANDROID_STANDALONE_TOOLCHAIN="/opt/toolchains/android-toolchain-aarch64"
sed -i 's|OCV_OPTION(WITH_FFMPEG         "Include FFMPEG support"                      ON   IF (NOT ANDROID AND NOT IOS))|OCV_OPTION(WITH_FFMPEG         "Include FFMPEG support"                      ON   IF (ANDROID AND NOT IOS))|g' ../CMakeLists.txt;
mv ../cmake/OpenCVFindLibsVideo.cmake ../cmake/OpenCVFindLibsVideo_backup.cmake
cp ../../OpenCVFindLibsVideo.cmake ../cmake/OpenCVFindLibsVideo.cmake
sed -i "s|include_directories( |include_directories("${PREFIX}/include" |g" ../cmake/OpenCVFindLibsVideo.cmake
sed -i "s|REPLACEME|${PREFIX}|g" ../cmake/OpenCVFindLibsVideo.cmake

mv ../modules/highgui/src/cap_ffmpeg_impl.hpp ../modules/highgui/src/cap_ffmpeg_impl_backup.hpp
cp ../../cap_ffmpeg_impl.hpp ../modules/highgui/src/cap_ffmpeg_impl.hpp
sed -i "s|include_directories( |include_directories("${PREFIX}/include" |g" android.toolchain.cmake

cmake -DANDROID=1 -DCMAKE_TOOLCHAIN_FILE=android.toolchain.cmake -DBUILD_SHARED_LIBS=ON DBUILD_ZLIB=ON -DANDROID_ABI="arm64-v8a" -DCMAKE_BUILD_TYPE=Release ..
make -j;
make install;
cp -r ./install/sdk/native/libs/arm64-v8a ~/lib
