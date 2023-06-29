import requests
import re
import os


'''
version：0.01
现有的问题：
1.下载效率低，1小时才下载26页，1分钟大概7张图片
需要怎么实现用多线程下载？

2.不确定有多少页
先通过get的文本经过处理获取到最后一页是多少来得知有多少页

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

for i in range(1,50):
    #获取网站链接中第i页的内容
    response = requests.get(url=url+'?page={}'.format(i),headers=headers)
    response.encoding = response.apparent_encoding
    
    #正则表达式处理，只保留图片链接
    rule = re.compile('src="(.*?)" alt=".*?"')
    img = re.findall(rule,response.text)

    print("开始下载第%d页!!" % i)
    #循环处理这一页中的所有图片
    for item in img:
        #去掉-thumb后才是无损的图片
        link = item.replace('-thumb','')
        name = re.sub('.*?/','',link)
        #创建文件保存图片
        with open(dir_path+'/'+name,'wb') as fd:
            res = requests.get(link)
            fd.write(res.content)
            fd.close()
            print(name+'下载成功!')
