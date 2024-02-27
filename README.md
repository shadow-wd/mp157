# mp157
用于正点原子mp157
# 编译方法
在根目录下有编译脚本build.sh  
编译uboot    ./build.sh uboot  

编译tf-a        ./build.sh tfa  

编译linux       ./build.sh linux  


将需要烧录的文件打包：  

./build.sh image  
会将烧录需要的三个文件存放在根目录的flash_iamge文件中。  

