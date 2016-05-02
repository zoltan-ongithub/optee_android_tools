#! /bin/bash

die() {
   echo "Error: $@"
   exit 1
}

if [ -z "$ANDROID_BUILD_TOP" ]; then
   echo "Error: Before running this script, setup for Android build"
   echo ""
   echo "  $ source build/envsetup.sh"
   echo "  $ lunch <target>"
fi

dest="${ANDROID_PRODUCT_OUT}/kernel_obj"

cross=optee/gcc-linaro-4.9-2015.05-x86_64_aarch64-linux-gnu/bin
if [ ! -d "$cross" ]; then
   echo "Please run ./optee/get_toolchain.sh first"
   exit 1
fi

cross=$(realpath "$cross")
cross="$cross/aarch64-linux-gnu-"

kerndir=device/linaro/hikey-kernel

CPU_CORES=$(nproc)

flags="CROSS_COMPILE=${cross} ARCH=arm64 -j${CPU_CORES} O=${dest}"

make -C $kerndir ${flags} hikey_defconfig || die "Unable to configure kernel"
make -C $kerndir ${flags} || die "Unable to build kernel"
