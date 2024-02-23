#!/bin/bash

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
