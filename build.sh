#!/bin/bash

HOME_PATH=$PWD


function print_usage()
{
    echo ""
    echo "format: ./build.sh [tfa/uboot]"
    echo "example: ./build.sh tfa"
    echo ""
}


function comple_tfa(){
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

    # 检查编译是否成功
    if [ $? -eq 0 ]; then
        echo "tf-a compilation successful."
    else
        echo "Error: tf-a compilation failed."
    fi

}


function comple_uboot(){
    UBOOT_DIR="uboot"
    # 进入uboot目录
    if [ -d "$UBOOT_DIR" ]; then
        cd "$UBOOT_DIR" || exit 1
    else
        echo "Error: Directory $UBOOT_DIR not found"
        exit 1
    fi
    echo "Compiling uboot..."
    make distclean
    make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabihf- stm32mp157d_atk_defconfig
    make V=1 ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabihf- DEVICE_TREE=stm32mp157d-atk all
}

function image(){
    IMAGE_DIR="flash_image"
    mkdir -p "$IMAGE_DIR"
    cp -vf "$HOME_PATH/tfa/build/trusted/tf-a-stm32mp157d-atk-trusted.stm32" "$HOME_PATH/$IMAGE_DIR"
    cp -vf "$HOME_PATH/tfa/build/serialboot/tf-a-stm32mp157d-atk-serialboot.stm32" "$HOME_PATH/$IMAGE_DIR"
    cp -vf "$HOME_PATH/uboot/u-boot.stm32" "$HOME_PATH/$IMAGE_DIR"
}


if [ $# -ne 1 ]; then
    print_usage
    exit 1
fi

case "$1" in
    "uboot")
        comple_uboot
        ;;
    "tfa")
        comple_tfa
        ;;
    "image")
        image
        ;;
    *)
        print_usage
        ;;
esac

