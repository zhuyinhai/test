# 删除文章的 TOML 部分
# 并用删除后的结果替换原文件
deleteTOML(){
	post=$1
	lines=(`grep -n "+++" ${post}`) # +++ 所在的行数。有两行
	lines=(`grep -n "+++" ${post}`) # +++ 所在的行数。有两行
	echo "lines: ${#lines[@]}"
	if [ ${#lines[@]} -gt 1 ]
	then
		# 只有lines长度大于1才进行删除
		lineStartStr=${lines[0]}
		lineEndStr=${lines[1]}
		lineStartArr=(${lineStartStr//:/ })
		lineEndArr=(${lineEndStr//:/ })
		lineStart=${lineStartArr[0]}
		lineEnd=${lineEndArr[0]}
		deletedPost=`sed -e "${lineStart},${lineEnd}d" ${post}`
		# 保存删除后的内容到文件
		echo "${deletedPost}" > "${post}"
	else
		# 没有 TOML 部分
		echo "${post}没有 TOML 部分"
	fi
}


# 创建一个新的issue
newIssue(){
	post=$1
	#获取文章标题
	lineTitle=`grep "description" ${post}`
	# echo ${#lineTitle[@]}
	if [ "${lineTitle}" ]
	then
		# echo "存在description，文章名字等于description的值"
		IFS='=' read -r -a array <<< "${lineTitle}"
		# echo ${array[1]}
		title=${array[1]}
	else
		#  echo "存在description，文章名字等于title的值"
		 title=$(echo ${post} | cut -f 1 -d '.')
	fi
	echo "该issue的标题: ${title}"
	# 获取文章的标签(tags)
	lineTags=`grep "tags" ${post}`
	IFS='=' read -r -a array <<< "${lineTags}"
	echo ${#array[@]}
	echo ${array[1]}
	tagsArr=${array[1]}
	# 去掉前面的 [ 和后面的 ]，以及引号
	tagsStrWithSpace=${tagsArr//[\[\]\"]/}
	echo "tagsStrWithSpace: ${tagsStrWithSpace}"
	# 去掉逗号 , 后面的空格
	tagsStr=${tagsStrWithSpace//, /,}
	echo "该issue的标签: ${tagsStr}"
	# 删除TOML
	deleteTOML ${post}
	# 获取文章的内容
	message=`cat ${post}`
	issue=(`gh is --new --title "${title}" --message "${message}" --label "${tagsStr}"`)
	key=`expr ${#issue[@]} - 1`
	link=${issue[key]}
	echo "key: ${key}"
	echo "创建的新issue的链接: ${issue[key]}"
	# 在原博客中添加上issue的链接
	echo `pwd`
	cd ./../content/post/
	echo "---" >> ${post}
	echo "Github Issue: [${link}](${link})" >> ${post}
	cd ../../postToIssues/
	echo `pwd`
}


# 创建一个评论
# 	找到最后一个 Github Issue
# 	从中取出对应的issue number
# 	然后进行评论
newComment(){
	post=$1
	# 删除TOML
	deleteTOML ${post}
	lines=(`grep "Github Issue" ${post}`) # Github Issue 所在的行数。可能有多行
	echo ${lines[@]}
	key=`expr ${#lines[@]} - 1`
	link=${lines[key]}
	echo ${link} # 包含Github Issue 链接的字符串
	IFS=']' read -r -a array <<< "${link}"
	echo ${#array[@]}
	echo ${array[0]}
	IFS='/' read -r -a array <<< "${array[0]}"
	echo ${#array[@]}
	echo ${array[@]}
	key=`expr ${#array[@]} - 1`
	number=${array[key]}
	echo "Github Issue Number: ${number}"
	comment=`cat ${post}`
	gh is ${number} --comment "${comment}"
}

# deleteTOML "1.md"
filename="1.md"
# name=$(echo $filename | cut -f 1 -d '.')
# echo "name: ${name}"

# newIssue ${filename}

# string="|abcdefg|"
# string2=${string#"|"}
# string2=${string2%"|"}
# echo $string2


# gh is 1 --comment 'Node GH rocks!'
# newComment ${filename}

# a="MD5 (../content/post/nginx-reverse-proxy-nodejs.md) = 15d4b66479599711ff483cb0ee2aac63"
# b="MD5 (../content/post/nginx-reverse-proxy-nodejs.md) = 15d4b66479599711ff483cb0ee2aac63"
# if [ "${a}" == "${b}" ]
# then
# 	echo 't'
# else
# 	echo 'f'
# fi
file="content/post/Start-React-with-Webpack.md"
file1="content/post/mysql-start-error.md"
lineTitle=`grep "description" ${file1}`
echo ${#lineTitle[@]}
if [ "${lineTitle}" ]
then
	echo "存在description，文章名字等于description的值"
	IFS='=' read -r -a array <<< "${lineTitle}"
	echo ${array[1]}
	title=${array[1]}
else
	 echo "存在description，文章名字等于title的值"
	 $(echo ${post} | cut -f 1 -d '.')
fi
echo "文章名字: ${title}"
