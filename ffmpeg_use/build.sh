#!/bin/bash  
NDK=/home/ztman/opt/ndk14/android-ndk-r14b  
SYSROOT=${NDK}/platforms/android-23/arch-arm  
TOOLCHAIN=/opt/EmbedSky/gcc-linaro-5.3.1-2016.05-x86_64_arm-linux-gnueabihf  

function build_so  
{  
    ./configure \
    --enable-gpl \
	--enable-version3 \
	--enable-nonfree \
	--enable-shared \
	--disable-static \
	--disable-doc \
	--enable-ffmpeg \
	--disable-ffplay \
	--enable-ffprobe \
	--enable-libopencore-amrwb \
	--enable-libopencore-amrnb \
	--disable-encoder=aac \
	--enable-libfdk-aac \
	--enable-libmp3lame \
	# --enable-cross-compile \
    # 	--cross-prefix=${TOOLCHAIN}/bin/arm-linux-gnueabihf- \
    # 	--target-os=linux \
    # 	--arch=arm \
    # --extra-cflags="-fPIC -I/root/下载/opencore-amr-0.1.5/installdir/include/ " \
    # 	--extra-ldflags="-L/root/下载/opencore-amr-0.1.5/installdir/lib/" \
    $ADDITIONAL_CONFIGURE_FLAG

    #--disable-ffserver \
    #--disable-avdevice \
    #--disable-symver \
    #--prefix=$PREFIX \



    make clean
    make -j 4
    make install
}  

CPU=arm  
PREFIX=$PWD/installdir
#ADDI_CFLAGS="-marm"  
build_so  
# --------------------- 
# 作者：学术袁 
# 来源：CSDN 
# 原文：https://blog.csdn.net/junhuahouse/article/details/79236932 
# 版权声明：本文为博主原创文章，转载请附上博文链接！
