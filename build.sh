#!/bin/bash

HOME_PATH=$PWD


function print_usage()
{
    echo ""
    echo "format: ./build.sh [tfa/uboot]"
    echo "example: ./build.sh tfa"
    echo ""
}


function compile_tfa(){
    # 设置变量
    TFA_DIR="tfa"
    TFA_SUBDIR="tf-a-stm32mp-2.2.r1"
    MAKEFILE="Makefile.sdk"

    # 进入tf-a目录
    if [ -d "$TFA_DIR" ]; then
        cd "$TFA_DIR" || exit 1
    else
        echo "Error: Directory $TFA_DIR not found"
        exit 1
    fi

    # 检查Makefile是否存在
    if [ ! -f "$MAKEFILE" ]; then
        echo "Error: Makefile $MAKEFILE not found"
        exit 1
    fi


    # 进入tf-a子目录
    if [ -d "$TFA_SUBDIR" ]; then
        cd "$TFA_SUBDIR" || exit 1
    else
        echo "Error: Directory $TFA_SUBDIR not found"
        exit 1
    fi


    # 编译tf-a
    echo "Compiling tf-a..."
    make -f "../$MAKEFILE" all
    
    cd ..
}


function compile_uboot(){
    UBOOT_DIR="uboot"
    # 指定uboot输出目录
    export KBUILD_OUTPUT="$HOME_PATH/uboot/out"
    # 进入uboot目录
    if [ -d "$UBOOT_DIR" ]; then
        cd "$UBOOT_DIR" || exit 1
    else
        echo "Error: Directory $UBOOT_DIR not found"
        exit 1
    fi
    echo "Compiling uboot..."
    make distclean
    # config uboot
    make stm32mp157d_atk_defconfig
    # compile uboot
    make V=1 DEVICE_TREE=stm32mp157d-atk all
    cd ..
}

function compile_linux(){
    LINUX_DIR="linux"
    # 进入linux目录
    if [ -d "$LINUX_DIR" ]; then
        cd "$LINUX_DIR" || exit 1
    else
        echo "Error: Directory $LINUX_DIR not found"
        exit 1
    fi
    echo "compiling linux..."
    make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabihf- distclean
    make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabihf- stm32mp1_atk_defconfig
    make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabihf- menuconfig
    make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabihf- uImage dtbs LOADADDR=0XC2000040 -j16
    cd ..
}

function image(){
    IMAGE_DIR="flash_image"
    mkdir -p "$IMAGE_DIR"
    cp -vf "$HOME_PATH/tfa/build/trusted/tf-a-stm32mp157d-atk-trusted.stm32" "$HOME_PATH/$IMAGE_DIR"
    cp -vf "$HOME_PATH/tfa/build/serialboot/tf-a-stm32mp157d-atk-serialboot.stm32" "$HOME_PATH/$IMAGE_DIR"
    cp -vf "$HOME_PATH/uboot/out/u-boot.stm32" "$HOME_PATH/$IMAGE_DIR"
}


if [ $# -ne 1 ]; then
    print_usage
    exit 1
fi

case "$1" in
    "uboot")
        compile_uboot
        ;;
    "tfa")
        compile_tfa
        ;;
    "image")
        image
        ;;
    "linux")
        compile_linux
        ;;
    *)
        print_usage
        ;;
esac

