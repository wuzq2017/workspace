export ARCH=arm
export EXTRADIR=${PWD}/extra
export CROSS_COMPILE=arm-linux-gnueabi-
make LDDD3_vexpress_defconfig
#make .config
make zImage -j8
make modules -j8
make dtbs
cp arch/arm/boot/zImage extra/
cp arch/arm/boot/dts/*ca9.dtb	extra/
cp .config extra/
sudo mount -o loop,offset=$((2048*512)) extra/vexpress.img extra/img
sudo make ARCH=arm modules_install INSTALL_MOD_PATH=extra/img
sudo umount extra/img
