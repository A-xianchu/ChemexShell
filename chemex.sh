#!/bin/bash
# ------------------------------------------
# Version:1.1
# Date: 2022/06/09
# Author: 仙（提醒过节小助手）
# Email: xian@include.ink
# Website: include.ink(因为没钱续服务器挂掉了)
# github: A-xianchu
# License: GPL
# ------------------------------------------
#菜单
#部署列表
function list_centos {
	echo -e ""
	echo -e "---部署列表---"
	echo -e "1.Docker"
	echo -e "2.Chemex"
	echo -e "3.mysql"
	echo -e "-------------"
	read -p "按任意键继续部署，取消请使用 Ctrl+C 快捷键"
	centosbs
}

function list_unbuntu {
	echo -e ""
	echo -e "---部署列表---"
	echo -e "1.Docker"
	echo -e "2.Chemex"
	echo -e "3.mysql"
	echo -e "-------------"
	read -p "按任意键继续部署，取消请使用 Ctrl+C 快捷键"
	ubuntubs
}

#Centos部署
function centosbs {
	#Docker(优化了docker安装步骤，使用了官方镜像)
	sudo yum remove docker \
	        docker-client \
	        docker-client-latest \
	        docker-common \
	        docker-latest \
	        docker-latest-logrotate \
	        docker-logrotate \
	        docker-engine -y
	sudo yum renmove docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
	sudo yum update -y
	sudo yum install curl -y
	echo -e "接下来将会安装Docker，可能会不显示安装流程，不要怀疑是自己卡了（特殊情况下也可以认为是自己卡了）"
	echo -e "将使用1.1版本进行优化后的安装流程，调用https://get.docker.com/的官方安装脚本进行安装"
	echo -e "10秒钟后将会继续安装......"
	sleep 10
	#获取Docker官方脚本
	curl -fsSL get.docker.com -o Docker-install.sh
	#使用阿里镜像进行部署
	sudo bash Docker-install.sh --mirror Aliyun
	#启动Docker
	sudo systemctl start docker
	#查看Docker状态(因黑洞问题，注释掉了)
	#sudo systemctl status docker
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

#Ubuntu部署
function ubuntubs {
	#Docker
	sudo apt-get update -y
	sudo apt-get install curl -y
	echo -e "接下来将会安装Docker，可能会不显示安装流程，不要怀疑是自己卡了（特殊情况下也可以认为是自己卡了）"
	echo -e "将使用1.1版本进行优化后的安装流程，调用https://get.docker.com/的官方安装脚本进行安装"
	echo -e "10秒钟后将会继续安装......"
	sleep 10
	#获取Docker官方脚本
	curl -fsSL get.docker.com -o Docker-install.sh
	#使用阿里镜像进行部署
	sudo bash Docker-install.sh --mirror Aliyun
	#启动Docker
	sudo service docker start
	#查看Docker状态(因黑洞问题，注释掉了)
	#sudo service docker status
	#拉取mysql镜像
	sudo docker pull mysql
	#拉取Chemex镜像
	sudo docker pull celaraze/chemex:latest
	#查看所有拉取的镜像
	sudo docker images
	#启动mysql容器
	sudo docker run -itd --name mysql-test --net=host -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql
	#10秒种等待mysql容器启动（cnm mysql）
	echo "等待mysql容器部署完成（预计60秒）"
	sleep 60
	#创建数据库
	sudo docker exec mysql-test mysql -h127.0.0.1 -P3306 -uroot -p123456 -e "create database chemex;"
	#5秒钟等待
	echo "等待mysql容器建库完成（预计60秒）"
	sleep 60
	#启动chemex容器
	sudo docker run -itd --name chemex --restart=always --net=host \
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
	sudo docker exec chemex php artisan chemex:install
	#关闭防火墙（部分Ubuntu服务器默认不启用，但为了保险，还是加了这么一条）
	ufw disable
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

#菜单
function menu {
	echo -e "--------------------------------------------------"
	echo -e "Chemex | 一键部署脚本v1.1"
	echo -e "--------------------------------------------------"
	echo -e "tmd看好了！这是一键部署好的！"
	echo -e "--------------------------------------------------"
	echo -e "Docker默认安装最新版"
	echo -e "所有镜像默认拉取最新版"
	echo -e "--------------------------------------------------"
	echo -e "作者：仙(提醒过节小助手) | Github:A-xianchu"
	echo -e "感谢官方群内：时顺利、鼏図 两位大佬提供的帮助"
	echo -e "感谢某不愿透露姓名的大佬帮我优化菜单交互功能"
	echo -e "--------------------------------------------------"
	echo -e "适用系统:Centos | Ubuntu | 其他的看我想不想写吧"
	echo -e "--------------------------------------------------"
	echo -e "当前版本最后更新日期:2022年6月9日"
	echo -e "--------------------------------------------------"
	echo -e "1. Centos部署Docker+chemex+mysql"
	echo -e "2. Ubuntu部署Docker+chemex+mysql"
	echo -e "0. 退出脚本"
	read -erp "输入你的选择：" input
	case "$input" in
		0)
			exit ;;
		1)
			list_centos ;;
		2)
			list_unbuntu ;;
		*)
			echo "【错误】没有此选项";;
	esac
}

menu
