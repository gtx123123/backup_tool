#!/bin/bash

# 定义颜色常量
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

pressAnyKey(){
  echo -n "请按回车键继续..."
  read -r
}

stepSeparator(){
  echo "---------------------------------------------------------"
}

# 处理压缩文件夹操作
compressFolder(){
  # 获取要压缩的文件夹路径
  while true; do
    echo "请输入要压缩的文件夹路径（相对或绝对路径）："
    read -r folderPath
    if [[ ! -d "$folderPath" ]]; then
      echo -e "${RED}无效的文件夹路径，请重新输入${NC}"
    else
      break
    fi
  done

  # 提取文件夹名
  folderName=$(basename "$folderPath")

  # 让用户指定保存压缩文件的路径
  while true; do
    echo "请输入要保存压缩文件的路径（相对或绝对路径）："
    read -r targetPath
    if [[ ! -d "$targetPath" ]]; then
      echo -e "${RED}无效的路径，请重新输入${NC}"
    else
      break
    fi
  done

  # 在输出信息中显示要压缩的文件夹的完整路径
  echo "正在压缩 $folderPath ..."

  # 将指定的文件夹压缩为 tar.gz 格式的文件
  targetFile="$targetPath/$folderName.tar.gz"
  tar -czvf "$targetFile" -C "$(dirname "$folderPath")" "$folderName"

  echo -e "${GREEN}文件夹已被压缩，并保存到 $targetFile。${NC}"
}

# 处理解压文件夹操作
extractFolder(){
  # 让用户选择要解压缩的文件
  while true; do
    echo "请选择要解压缩的文件（相对或绝对路径）："
    read -r targetFile
    if [[ ! -f "$targetFile" ]]; then
      echo -e "${RED}无效的文件，请重新选择${NC}"
    else
      break
    fi
  done

  # 让用户指定保存解压缩文件夹的路径
  while true; do
    echo "请输入要保存解压缩后的文件夹的路径（相对或绝对路径）："
    read -r targetPath
    if [[ ! -d "$targetPath" ]]; then
      echo -e "${RED}无效的目标路径，请重新输入${NC}"
    else
      break
    fi
  done

  # 解压缩文件夹
  echo "正在解压 $targetFile ..."
  tar -xzvf "$targetFile" -C "$targetPath"

  echo -e "${GREEN}文件夹已被解压缩，并保存到 $targetPath。${NC}"
}

# 持续循环，直到用户选择退出
while true; do
  # 显示操作选项
  echo "请选择要执行的操作："
  echo "1：压缩文件夹"
  echo "2：解压缩文件夹"
  echo "3：退出"

  # 获取用户选择的操作
  read -r choice

  # 根据选择的操作调用相应的函数
  case $choice in
    1) compressFolder; pressAnyKey ;;
    2) extractFolder; pressAnyKey ;;
    3) break ;;
    *)
      echo -e "${RED}无效的选项，请重新选择${NC}"
      pressAnyKey
      ;;
  esac

  # 显示分隔符，用于分隔每次操作
  stepSeparator
done