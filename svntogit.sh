#!/bin/bash

# 操作的根目录
oper_path="/e/svntogit"

# git的命名空间地址
git_base_url="http://git.code.oa.com/svntogittest/"

mkdir -p $oper_path



#while [ "1" = "1" ]
#do
cd $oper_path


# svn仓库地址 此处手动输入一个项目测试
# 也可以设置svn_url_config 数组做循环
read -p "输入svn仓库url：" svn_url


# 获取项目名作为 git仓库名称，其实就是获取git的项目名svn_proj1
splice_svn_url=${svn_url%/*}
arr=(${splice_svn_url//\// })
for s in ${arr[@]}
do
    git_proj=$s
done

# 创建svn最外层文件夹
mkdir -p "svn_$git_proj"

# 创建git仓库地址
git_url="${git_base_url}${git_proj}.git"

# 清理git项目仓库 ，自动清理，防止重复迁移
# rm -rf "$oper_path/git_$git_proj"
# mkdir -p "$oper_path/git_$git_proj"
# cd "$oper_path/git_$git_proj"

# git init
# git remote add origin $git_url
# git pull origin master
# git rm -rf *
# git add .
# git commit -m "清理仓库" 
# git push -u origin master



echo "清理svn文件夹，防止脚本重复执行========================="
cd "$oper_path/svn_$git_proj"
rm -rf "$oper_path/svn_$git_proj/*"

echo "svn代码迁出开始========================="
svn checkout "$svn_url"

echo "svn代码checkout完成========================="

# 判断是否有子模块，我们的项目都有子模块，所以要考虑子模块迁移，迁移后使用子模块也要考虑submodul版本游离问题
is_use_submodule=1
if [ ! -f "$oper_path/svn_$git_proj/trunk/external.txt" ]; then
  echo '不存在external.txt 不需要添加submodule'
  is_use_submodule=0
fi    

echo "is_use_submodule:$is_use_submodule"
echo "${oper_path}/svn_${git_proj}/trunk/*"
sleep 3

# 清理文件夹
cd "$oper_path/svn_${git_proj}/trunk/"
if [ $is_use_submodule -eq 1 ]; then
    # 清理子模块相关文件夹和.svn目录，此处自行修改，不一定是下面的文件夹
    rm -rf .* core helper library unifiedapi external.txt
else
    # 注意此处有可能清理掉所有带.的文件，请注意
    rm -rf .*
fi

sleep 3


echo "git仓库代码添加========================="
git init 
git remote add origin $git_url
git add .
git commit -m 'svntogit'
git push -u origin master

if [ $is_use_submodule -eq 1 ]; then
    # 添加子模块，命令，此处举例
    git submodule add git@git.code.oa.com:svntogittest/xxxsubmodule.git xxx/xxx/xxx

    git add .
    git commit -m 'add submodule'
    git push -u origin master
    echo "git 子模块添加完成========================="
fi
version="v`date +%Y%m%d%H%m`"
git tag -a $version -m $version
git push origin --tags

cd $oper_path
echo "迁移完成 相关迁移变量如下：========================="
echo "is_use_submodule:$is_use_submodule"
echo "${oper_path}/svn_${git_proj}/trunk/*" "${oper_path}/${git_proj}/"
echo "svn项目名称：$git_proj"
echo "svn仓库地址：$svn_url"
sleep 3
#done