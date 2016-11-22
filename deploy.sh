#!/bin/bash

# 先创建issue再发布到pagesi

# 读取所有文章到数组
posts=arr( *.md )
echo "博客总数目: ${#posts[@]}"




# 用md5值进行对比，如果更新，则添加评论
# update `date`
# gh is 1 --comment 'Node GH rocks!'

# 文章标题
# TODO 分割字符串，去掉后缀名
post=`cat A-simple-neural-network-with-Python-and-Keras.md`
# 文章内容
echo ${post} 
# 创建 issue
res=`gh is --new --title 'A-simple-neural-network-with-Python-and-Keras' --label javascript --message "${post}"`
# 创建结果
# TODO 分割字符串，取出issue链接
echo ${res} # Creating a new issue on nodejh/test https://github.com/nodejh/test/issues/16
