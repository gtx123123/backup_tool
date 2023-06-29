import requests
import re
import os
import threading
import time

'''
version：0.01
现有的问题：
1.下载效率低，1小时才下载26页，1分钟大概7张图片
需要怎么实现用多线程下载？

2.不确定有多少页
先通过get的文本经过处理获取到最后一页是多少来得知有多少页

version：0.02
实现多线程去下载图片,效率得到巨大提升
'''

#爬取目标网站
url = "https://www.wallpapermaiden.com/category/anime"
headers = {
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.51"
}

#判断文件夹路径，不存在就创建
dir_path = 'pic'
if not os.path.isdir(dir_path):
    os.mkdir(dir_path)

#下载标志位
download_flag = True

#保存图片的列表
img_list = []

#线程执行函数：下载图片并保存文件到指定目录
def download_thread():
    global img_list
    #获取线程对象并获取线程 ID
    thread_id = threading.current_thread().ident

    #处于下载状态，线程一直运行
    while download_flag:
        #如果img_list为空，线程等待1s
        if len(img_list) == 0:
            time.sleep(1)
            continue

        #取出img_list中的第一个后，从img_list中删除
        link = img_list[0].replace('-thumb','')
        name = re.sub('.*?/','',link)
        #加锁
        with threading.Lock():
            del img_list[0]

        #创建文件保存图片
        with open(dir_path+'/'+name,'wb') as fd:
            res = requests.get(link)
            fd.write(res.content)
            fd.close()
            print("线程%d:%s下载成功!" % (thread_id,name))

#创建线程并开启
tids = [threading.Thread(target = download_thread) for _ in range(30)]
for tid in tids:
    tid.start()

#循环将每页里的图片链接保存到img_list中
for i in range(101,121):
    #判断img_list中是否还有图片没下载，如果img_list为空，就继续获取
    while len(img_list) != 0:
        time.sleep(1)

    print('开始下载第%d页' % i)

    #获取网站链接中第i页的内容
    response = requests.get(url=url+'?page={}'.format(i),headers=headers)
    response.encoding = response.apparent_encoding
    
    #正则表达式处理，只保留图片链接
    with threading.Lock():
        img_list = re.findall(re.compile('src="(.*?)" alt=".*?"'),response.text)

#修改下载状态标志位，线程退出函数里的循环
download_flag = False

#接收线程
for tid in tids:
    tid.join()
