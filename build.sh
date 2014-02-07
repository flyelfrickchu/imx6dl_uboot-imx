#!/bin/sh

EXPECTED_ARGS=1

# Toolchain setup
ROOT_PATH=`pwd`
TOOLCHAIN_PATH=../../../prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin

export ARCH=arm
export CROSS_COMPILE=$ROOT_PATH/$TOOLCHAIN_PATH/arm-eabi-
export PATH=$PATH:$ROOT_PATH/$TOOLCHAIN_PATH

# function
print_usage() {
    echo "Usage: build.sh [normal|clean|distclean]"
}
clean_build_obj() {
    make distclean
}
gen_no_padding() {
    if [ -f u-boot-no-padding.bin ] ; then
        rm -f u-boot-no-padding.bin
    fi
    if [ -f u-boot.bin ] ; then
        sudo dd if=u-boot.bin of=u-boot-no-padding.bin bs=1024 skip=1; sync
    fi
}

# verify input parameters
ARGS_VALUE=$#
if [ $ARGS_VALUE -lt $EXPECTED_ARGS ] ; then
    INPUT=normal
    print_usage
else
    INPUT=$1
fi

# main function
case "$INPUT" in
    normal)
    echo "normal build"
    make mx6dl_sabresd_android_config
    make -j6
    gen_no_padding
    ;;
    clean)
    echo "clean build"
    make distclean
    make mx6dl_sabresd_android_config
    make -j6
    gen_no_padding
    ;;
    distclean)
    echo "make distclean"
    clean_build_obj
    ;;
    *)
    print_usage
    ;;
esac

