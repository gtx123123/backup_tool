#!/bin/bash

#解压
Jieya()
{
    echo '显示当前路径下的所有文件：'
    echo `ls`
    read -p "输入解压文件(包括文件类型):(./xxx/xxx.tar.xz)" File
    if [ $File == *.tar.gz ]; then
        tar zxvf $File
    elif [ $File == *.tar.bz2 ]; then
        tar jxvf $File
    elif [ $File == *.zip ]; then
        unzip $File
    else
        echo '不支持该文件类型的解压！'
    fi
}

#压缩
Yasuo()
{
    echo '显示当前路径下的所有文件：'
    echo `ls`
    read -p "输入压缩文件名：" File_Name
    if [ -e ./$File_Name ]
    then
        echo '选择压缩方式(默认保存到当前路径下)'
        echo '1.tar.bz2'
        echo '2.tar.gz'
        echo '3.zip'
        read -p "" Operation
        case $Operation in
            "1")tar jcvf $File_Name.tar.bz2 $File_Name;;
            "2")tar zcvf $File_Name.tar.gz $File_Name;;
            "3")zip -p -r $File_Name.zip $File_Name;;
            *)echo '输入无效，重新输入';;
        esac
    else
        echo '输入的文件名不存在'
    fi
}

Menu()
{
    while true;
    do   
        echo "1.压缩文件"
        echo "2.解压文件"
        echo "0.退出"
        read -r operation
        case $operation in
            "1")Yasuo;;
            "2")Jieya;;
            "0")break;;
            *)echo '输入无效，重新输入';;
        esac
    done
}

#调用函数
Menu
