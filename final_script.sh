#!/bin/bash

# 删除文章的 TOML 部分
# 并用删除后的结果替换原文件
deleteTOML(){
	post=$1
	lines=(`grep -n "+++" ${post}`) # +++ 所在的行数。有两行
	lines=(`grep -n "+++" ${post}`) # +++ 所在的行数。有两行
	echo "包含+++的行数: ${#lines[@]}"
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
	#		从文章的 description 中获取
	#		如果没有 description，则取文件名
	lineTitle=`grep "description" ${post}`
	# echo ${#lineTitle[@]}
	if [ "${lineTitle}" ]
	then
		# echo "存在description，文章名字等于description的值"
		IFS='=' read -r -a array <<< "${lineTitle}"
		# echo ${array[1]}
		title=${array[1]}
		title=${title//[\"]/}
	else
		#  echo "存在description，文章名字等于title的值"
		 title=$(echo ${post} | cut -f 1 -d '.')
	fi
	echo "该issue的标题: ${title}"
	# 获取文章的标签(tags)
	lineTags=`grep "tags" ${post}`
	IFS='=' read -r -a array <<< "${lineTags}"
	# echo ${#array[@]}
	# echo ${array[1]}
	tagsArr=${array[1]}
	# 去掉前面的 [ 和后面的 ]，以及引号
	tagsStrWithSpace=${tagsArr//[\[\]\"]/}
	# echo "tagsStrWithSpace: ${tagsStrWithSpace}"
	# 去掉逗号 , 后面的空格
	tagsStr=${tagsStrWithSpace//, /,}
	# echo "该issue的标签: ${tagsStr}"
	# 删除TOML
	deleteTOML ${post}
	# 获取文章的内容
	message=`cat ${post}`
	issue=(`gh is --new --title "${title}" --message "${message}" --label "${tagsStr}"`)
	key=`expr ${#issue[@]} - 1`
	link=${issue[key]}
	# echo "key: ${key}"
	echo "创建的新issue的链接: ${issue[key]}"
	# 在原博客中添加上issue的链接
	echo "---" >> "./../content/post/${post}"
	echo "Github Issue: [${link}](${link})" >> "./../content/post/${post}"
	md5Value=`md5 ../content/post/${post}`
	# 将md5值存入文件
	echo ${md5Value} > "../md5sum/${post}.md5"
	# 将issue链接和文章名称添加到 README.md
	echo "+ [${title}](${link})" >> "./../public/README.md"
	echo "添加 ${post} 到 ${issue[key]}" >> "../result.txt"
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
	# echo ${lines[@]}
	key=`expr ${#lines[@]} - 1`
	link=${lines[key]}
	# echo ${link} # 包含Github Issue 链接的字符串
	IFS=']' read -r -a array <<< "${link}"
	# echo ${#array[@]}
	# echo ${array[0]}
	IFS='/' read -r -a array <<< "${array[0]}"
	# echo ${#array[@]}
	# echo ${array[@]}
	key=`expr ${#array[@]} - 1`
	number=${array[key]}
	echo "Github Issue Number: ${number}"
	comment=`cat ${post}`
	res=`gh is ${number} --comment "${comment}"`
	echo "Github Issue Comment: ${res}"
	echo "评论 ${post}: ${res}" >> "../result.txt"
}


# 读取所有文章到数组
echo "开始部署博客到Github Issues..."
echo "复制 ./content/post 到 postToIssues 目录"
cp -r ./content/post postToIssues
cd postToIssues
posts=( *.md )
echo "文章总数目: ${#posts[@]}"

# 循环文章列表
for post in "${posts[@]}"
	do
		echo "-----------------------"
		echo "处理文章: ${post}"
		# 判断是否已经存在存储该文件.md5值的文件
		# cd ../md5sum/
		if [ ! -f "../md5sum/${post}.md5" ]
		then
			# 如果不存在，则新建一个md5文件
			# 然后将文章发布到issue
			# 再然后将issue的链接添加到文章末尾
			echo "不存在md5文件: ../md5sum/${post}.md5"
			# 发布文章到 issue
			# 	删除文章的 TOML 部分后
			# 	发布文章
			#		将链接加入到原文章中
			#		创建文件的md5值并存储
			echo "开始发布文章到issue: ${post}"
			newIssue ${post}

		else
			echo "存在 ../md5sum/${post}.md5"
			# 计算原文章的md5值
			md5Value=`md5 ../content/post/${post}`
			echo "原文章的md5值: ${md5Value}"
			# 对比新计算出的 md5 值，与md5sum中的 md5 进行比较，判断文件是否有更新
			md5ValueOld=`cat "../md5sum/${post}.md5"`
			echo "md5ValueOld: ${md5ValueOld}"
			if [ "${md5ValueOld}" == "${md5Value}" ]
			then
				# 没有更新，则什么都不做
				echo "文章没有更新, 处理结束 ${post}"
			else
				# 有更新，则将文章通过comment的方式对issue进行评论
				# 	从文章的末尾找到issue的链接
				# 	删除 TOML 部分后再commnet(在newComment中已经实现)
				#		然后更新md5的值
				echo "开始更新文章到评论 ${post}"
				newComment ${post}
				echo "更新 md5sum 中的 md5 值: ${md5Value}"
				echo ${md5Value} > "../md5sum/${post}.md5"
			fi
		fi
	done


# 对每个文件创建一个.md文件，里面的值就是该文件的md5值


# 返回上层目录
cd ../
# 删除 postToIssues 目录
echo "删除 postToIssues 目录"
rm -r postToIssues
echo "完成部署博客到Github Issues!"

if [ -f "result.txt" ]
then
	echo "===================================="
	echo "===================================="
	cat result.txt
	rm result.txt
	echo "===================================="
	echo "===================================="
else
	echo "====================================="
	echo "没有更新=============================="
	echo "====================================="
fi
