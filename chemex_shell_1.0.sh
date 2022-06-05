#!/bin/bash
# ------------------------------------------
# Filename: chemex.sh
# Version:1.0
# Date: 2022/06/04
# Author: 仙（提醒过节小助手）
# Email: xian@include.ink
# Website: include.ink(因为没钱续服务器挂掉了)
# github: A-xianchu
# License: GPL
# ------------------------------------------
#菜单
function menu {
	echo -e "--------------------------------------------------"
	echo -e "Chemex | 一键部署脚本"
	echo -e "--------------------------------------------------"
	echo -e "tmd看好了！这是一键部署好的！"
	echo -e "--------------------------------------------------"
	echo -e "Docker默认安装最新版"
	echo -e "所有镜像默认拉取最新版"
	echo -e "--------------------------------------------------"
	echo -e "作者：仙(提醒过节小助手) | Github:A-xianchu"
	echo -e "感谢官方群内：时顺利、鼏図 两位大佬提供的帮助"
	echo -e "--------------------------------------------------"
	echo -e "适用系统:Centos(其他的我懒得写)"
	echo -e "--------------------------------------------------"
	echo -e "当前版本最后更新日期:2022年6月4日"
	echo -e "--------------------------------------------------"
	echo -e "1. 部署Docker+chemex+mysql"
	echo -e "0. 退出脚本"
	echo -e "输入你的选择: "
	read -n 1 option
}

#部署列表

function list {
	echo -e ""
	echo -e "---部署列表---"
	echo -e "1.Docker"
	echo -e "2.Chemex"
	echo -e "3.mysql"
	echo -e "-------------"
	read -p "按任意键继续部署，取消请使用 Ctrl+C 快捷键"
	bs
}
#部署

function bs {
	#Docker
	sudo yum remove docker \
	        docker-client \
	        docker-client-latest \
	        docker-common \
	        docker-latest \
	        docker-latest-logrotate \
	        docker-logrotate \
	        docker-engine
	sudo yum install -y yum-utils
	sudo yum-config-manager \
	    --add-repo \
	    https://download.docker.com/linux/centos/docker-ce.repo
	sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
	#启动Docker
	sudo systemctl start docker
	#查看Docker状态
	sudo systemctl status docker
	#拉取mysql镜像
	docker pull mysql
	#拉取Chemex镜像
	docker pull celaraze/chemex:latest
	#查看所有拉取的镜像
	docker images
	#启动mysql容器
	docker run -itd --name mysql-test --net=host -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql
	#10秒种等待mysql容器启动（cnm mysql）
	echo "等待mysql容器部署完成（预计60秒）"
	sleep 60
	#创建数据库
	docker exec mysql-test mysql -h127.0.0.1 -P3306 -uroot -p123456 -e "create database chemex;"
	#5秒钟等待
	echo "等待mysql容器建库完成（预计60秒）"
	sleep 60
	#启动chemex容器
	docker run -itd --name chemex --restart=always --net=host \
	-e DB_HOST=127.0.0.1 \
	-e DB_PORT=3306 \
	-e DB_DATABASE=chemex \
	-e DB_USERNAME=root \
	-e DB_PASSWORD=123456 \
	celaraze/chemex
	#10秒钟等待chemex容器启动（cnm docker）
	echo "等待chemex容器部署完成（预计20秒）"
	sleep 20
	#写入数据库
	docker exec chemex php artisan chemex:install
	#关闭防火墙
	systemctl disable firewalld  --now
	#最后留言
	echo -e ""
	echo -e "---数据库---"
	echo -e "账户:root"
	echo -e "密码:123456"
	echo -e "库名:chemex"
	echo -e "端口:3306"
	echo -e "使用net的host模式"
	echo -e "---chemex---"
	echo -e "地址:本机ip/域名"
	echo -e "账号:admin"
	echo -e "密码:admin"
	echo -e "-------------"
	echo -e "为防止遗忘数据库账密，请截图保存"
	echo -e "-------------"
	read -p "部署完成，按任意键结束脚本"
	break
}

#菜单选择1
while [ 1 ]
do
menu
case $option in
0)
break ;;
1)
list ;;
*)
echo "【错误】没有此选项";;
esac
read -n 1 line
done