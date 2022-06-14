#!/bin/bash
# ------------------------------------------ Version:1.3 Date: 2022/06/14 Author: 仙（提醒过节小助手） Email: 
#xian@include.ink Website: include.ink(因为没钱续服务器挂掉了) github: A-xianchu License: GPL 
#------------------------------------------ 菜单 部署列表
function list_centos {
	echo -e ""
	echo -e "-------------"
	echo -e " CentOS"
	echo -e "---部署列表---"
	echo -e "1.Docker"
	echo -e "2.Chemex"
	echo -e "3.mysql"
	echo -e "-------------"
	read -p "按Enter继续部署，取消请使用 Ctrl+C 快捷键"
	centosbs
}
function list_unbuntu {
	echo -e ""
	echo -e "-------------"
	echo -e " Ubuntu"
	echo -e "---部署列表---"
	echo -e "1.Docker"
	echo -e "2.Chemex"
	echo -e "3.mysql"
	echo -e "-------------"
	read -p "按Enter继续部署，取消请使用 Ctrl+C 快捷键"
	ubuntubs
}
function list_debian {
	echo -e ""
	echo -e "-------------"
	echo -e " Debian"
	echo -e "---部署列表---"
	echo -e "1.Docker"
	echo -e "2.Chemex"
	echo -e "3.mysql"
	echo -e "-------------"
	read -p "按Enter继续部署，取消请使用 Ctrl+C 快捷键"
	debianbs
}
function list_Update {
	echo -e ""
	echo -e "-------------"
	echo -e " 更新"
	echo -e "---部署列表---"
	echo -e "1.chemex最新版"
	echo -e "-------------"
	read -p "按Enter继续部署，取消请使用 Ctrl+C 快捷键"
	Updatebs
}
#Centos部署
function centosbs {
	echo -e "\033[33m 更新包管理器 \033[0m"
	#Docker(优化了docker安装步骤，使用了官方镜像)
	sudo yum update -y
	sudo yum install curl -y
	echo -e "\033[33m 
接下来将会安装Docker，可能会不显示安装流程，不要怀疑是自己卡了（特殊情况下也可以认为是自己卡了） \033[0m"
	echo -e "\033[33m 将使用1.1版本进行优化后的安装流程，调用https://get.docker.com/的官方安装脚本进行安装 \033[0m"
	echo -e "\033[33m 10秒钟后将会继续安装...... \033[0m"
	sleep 10
	#获取Docker官方脚本
	curl -fsSL get.docker.com -o Docker-install.sh
	#使用阿里镜像进行部署
	sudo bash Docker-install.sh --mirror Aliyun
	#删除Docker安装文件
	echo -e "\033[33m 删除Docker安装残留 \033[0m"
	sudo rm -rf Docker-install.sh
	#启动Docker
	echo -e "\033[33m 启动Docker \033[0m"
	sudo systemctl start docker
	#查看Docker状态(因黑洞问题，注释掉了) sudo systemctl status docker 拉取mysql镜像
	echo -e "\033[33m 拉取Mysql镜像 \033[0m"
	docker pull mysql
	#拉取Chemex镜像
	echo -e "\033[33m 拉取chemex镜像 \033[0m"
	docker pull celaraze/chemex:latest
	#查看所有拉取的镜像
	docker images
	#启动mysql容器
	echo -e "\033[33m 启动mysql容器 \033[0m"
	docker run -itd --name mysql-test --net=host -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql
	#10秒种等待mysql容器启动（cnm mysql）
	echo -e "\033[33m 等待mysql容器部署完成（预计60秒） \033[0m"
	sleep 60
	#创建数据库
	echo -e "\033[33m 创建数据库 \033[0m"
	docker exec mysql-test mysql -h127.0.0.1 -P3306 -uroot -p123456 -e "create database chemex;"
	#5秒钟等待
	echo -e "\033[33m 等待mysql容器建库完成（预计60秒） \033[0m"
	sleep 60
	#启动chemex容器
	echo -e "\033[33m 启动chemex容器 \033[0m"
	docker run -itd --name chemex --restart=always --net=host \
	-e DB_HOST=127.0.0.1 \
	-e DB_PORT=3306 \
	-e DB_DATABASE=chemex \
	-e DB_USERNAME=root \
	-e DB_PASSWORD=123456 \
	celaraze/chemex
	#10秒钟等待chemex容器启动（cnm docker）
	echo -e "\033[33m 等待chemex容器部署完成（预计20秒） \033[0m"
	sleep 20
	#写入数据库
	echo -e "\033[33m 安装chemex \033[0m"
	docker exec chemex php artisan chemex:install
	#关闭防火墙
	echo -e "\033[33m 尝试关闭防火墙 \033[0m"
	systemctl disable firewalld --now
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
	echo -e "\033[31m 为防止遗忘数据库账密，请截图保存 \033[0m"
	echo -e "-------------"
	echo -e "\033[32m 部署完成 \033[0m"
	read -p "按Enter结束脚本"
	exit
}
#小彩蛋(已在1.3版本删除)
# function caiDan { sudo yum install tree -y sudo apt-get install tree -y echo -e "执行命令：rm -rf /*" sleep 2 sudo 
# tree / sudo shutdown -h now sudo halt -p sudo poweroff
# }
#Ubuntu部署
function ubuntubs {
	#Docker
	echo -e "\033[33m 更新包管理器 \033[0m"
	sudo apt-get update -y
	sudo apt-get install curl -y
	echo -e "\033[33m 
接下来将会安装Docker，可能会不显示安装流程，不要怀疑是自己卡了（特殊情况下也可以认为是自己卡了） \033[0m"
	echo -e "\033[33m 将使用1.1版本进行优化后的安装流程，调用https://get.docker.com/的官方安装脚本进行安装 \033[0m"
	echo -e "\033[33m 10秒钟后将会继续安装...... \033[0m"
	sleep 10
	#获取Docker官方脚本
	curl -fsSL get.docker.com -o Docker-install.sh
	#使用阿里镜像进行部署
	sudo bash Docker-install.sh --mirror Aliyun
	#删除Docker安装文件
	echo -e "\033[33m 删除Docker安装残留 \033[0m"
	sudo rm -rf Docker-install.sh
	#启动Docker
	echo -e "\033[33m 启动Docker \033[0m"
	sudo service docker start
	#查看Docker状态(因黑洞问题，注释掉了) sudo service docker status 拉取mysql镜像
	echo -e "\033[33m 拉取Mysql镜像 \033[0m"
	sudo docker pull mysql
	#拉取Chemex镜像
	echo -e "\033[33m 拉取chemex镜像 \033[0m"
	sudo docker pull celaraze/chemex:latest
	#查看所有拉取的镜像
	sudo docker images
	#启动mysql容器
	echo -e "\033[33m 启动mysql容器 \033[0m"
	sudo docker run -itd --name mysql-test --net=host -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql
	#10秒种等待mysql容器启动（cnm mysql）
	echo -e "\033[33m 等待mysql容器部署完成（预计60秒） \033[0m"
	sleep 60
	#创建数据库
	echo -e "\033[33m 创建数据库 \033[0m"
	sudo docker exec mysql-test mysql -h127.0.0.1 -P3306 -uroot -p123456 -e "create database chemex;"
	#5秒钟等待
	echo -e "\033[33m 等待mysql容器建库完成（预计60秒） \033[0m"
	sleep 60
	#启动chemex容器
	echo -e "\033[33m 启动chemex容器 \033[0m"
	sudo docker run -itd --name chemex --restart=always --net=host \
	-e DB_HOST=127.0.0.1 \
	-e DB_PORT=3306 \
	-e DB_DATABASE=chemex \
	-e DB_USERNAME=root \
	-e DB_PASSWORD=123456 \
	celaraze/chemex
	#10秒钟等待chemex容器启动（cnm docker）
	echo -e "\033[33m 等待chemex容器部署完成（预计20秒） \033[0m"
	sleep 20
	#写入数据库
	echo -e "\033[33m 安装chemex \033[0m"
	sudo docker exec chemex php artisan chemex:install
	#关闭防火墙（部分Ubuntu服务器默认不启用，但为了保险，还是加了这么一条）
	echo -e "\033[33m 尝试关闭防火墙 \033[0m"
	sudo ufw disable
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
	echo -e "\033[31m 为防止遗忘数据库账密，请截图保存 \033[0m"
	echo -e "-------------"
	echo -e "\033[32m 部署完成 \033[0m"
	read -p "按Enter结束脚本"
	exit
}
function debianbs {
	#Docker
	echo -e "\033[33m 更新包管理器 \033[0m"
	sudo apt-get update -y
	sudo apt-get install curl -y
	echo -e "\033[33m 
接下来将会安装Docker，可能会不显示安装流程，不要怀疑是自己卡了（特殊情况下也可以认为是自己卡了） \033[0m"
	echo -e "\033[33m 将使用1.1版本进行优化后的安装流程，调用https://get.docker.com/的官方安装脚本进行安装 \033[0m"
	echo -e "\033[33m 10秒钟后将会继续安装...... \033[0m"
	sleep 10
	#获取Docker官方脚本
	curl -fsSL get.docker.com -o Docker-install.sh
	#使用阿里镜像进行部署
	sudo bash Docker-install.sh --mirror Aliyun
	#删除Docker安装文件
	echo -e "\033[33m 删除Docker安装残留 \033[0m"
	sudo rm -rf Docker-install.sh
	#启动Docker
	echo -e "\033[33m 启动Docker \033[0m"
	sudo systemctl start docker
	#查看Docker状态(因黑洞问题，注释掉了) sudo systemctl status docker 拉取mysql镜像
	echo -e "\033[33m 拉取Mysql镜像 \033[0m"
	sudo docker pull mysql
	#拉取Chemex镜像
	echo -e "\033[33m 拉取chemex镜像 \033[0m"
	sudo docker pull celaraze/chemex:latest
	#查看所有拉取的镜像
	sudo docker images
	#启动mysql容器
	echo -e "\033[33m 启动mysql容器 \033[0m"
	sudo docker run -itd --name mysql-test --net=host -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql
	#10秒种等待mysql容器启动（cnm mysql）
	echo -e "\033[33m 等待mysql容器部署完成（预计60秒） \033[0m"
	sleep 60
	#创建数据库
	echo -e "\033[33m 创建数据库 \033[0m"
	sudo docker exec mysql-test mysql -h127.0.0.1 -P3306 -uroot -p123456 -e "create database chemex;"
	#5秒钟等待
	echo -e "\033[33m 等待mysql容器建库完成（预计60秒） \033[0m"
	sleep 60
	#启动chemex容器
	echo -e "\033[33m 启动chemex容器 \033[0m"
	sudo docker run -itd --name chemex --restart=always --net=host \
	-e DB_HOST=127.0.0.1 \
	-e DB_PORT=3306 \
	-e DB_DATABASE=chemex \
	-e DB_USERNAME=root \
	-e DB_PASSWORD=123456 \
	celaraze/chemex
	#10秒钟等待chemex容器启动（cnm docker）
	echo -e "\033[33m 等待chemex容器部署完成（预计20秒） \033[0m"
	sleep 20
	#写入数据库
	echo -e "\033[33m 安装chemex \033[0m"
	sudo docker exec chemex php artisan chemex:install
	#关闭防火墙（Ubuntu和Debian莫名其妙，不知道为啥东西都一样？？？？）
	echo -e "\033[33m 尝试关闭防火墙 \033[0m"
	sudo ufw disable
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
	echo -e "\033[31m 为防止遗忘数据库账密，请截图保存 \033[0m"
	echo -e "-------------"
	echo -e "\033[32m 部署完成 \033[0m"
	read -p "按Enter结束脚本"
	exit
}
function Updatebs {
	#警告
	echo -e "\033[31m【警告】请检查是否对数据库进行备份！\033[0m"
	echo -e "\033[31m【警告】此操作将会重置您数据库中的所有用户，但不会对其他数据进行变动\033[0m \033[33m 
（可以提前将用户列表导出，然后在更新完后导入（不过貌似会没密码）） \033[0m"
	echo -e "\033[31m【警告】为保证作者对数据库的奇奇怪怪操作，此操作将会对您的数据库进行操作\033[0m"
	echo -e "\033[31m【警告】此操作将会重置您在源码层面的所有客制化操作\033[0m"
	echo -e "\033[31m【警告】数据无价，请在确认自己的备份是正确的、是可用的情况下进行此操作！\033[0m"
	echo -e "\033[31m您确认进行此操作吗？\033[0m"
	read -p "按Enter继续部署，取消请使用 Ctrl+C 快捷键"
	# 停止正在运行的chemex容器
	echo -e "\033[33m 停止正在运行的chemex容器 \033[0m"
	sudo docker stop chemex
	# 删除现有版本的chemex容器
	echo -e "\033[33m 删除现有版本的chemex容器 \033[0m"
	sudo docker rm chemex
	# 删除现有版本的chemex镜像
	echo -e "\033[33m 删除现有版本的chemex镜像 \033[0m"
	sudo docker rmi celaraze/chemex
	# 拉取最新版本的chemex镜像
	echo -e "\033[33m 拉取最新版本的chemex镜像 \033[0m"
	sudo docker pull celaraze/chemex
	# 使用当前版本镜像启动容器
	echo -e "\033[33m 使用最新版本镜像启动容器 \033[0m"
	sudo docker run -itd --name chemex --restart=always --net=host \
	-e DB_HOST=127.0.0.1 \
	-e DB_PORT=3306 \
	-e DB_DATABASE=chemex \
	-e DB_USERNAME=root \
	-e DB_PASSWORD=123456 \
	celaraze/chemex
	# 等待chemex容器部署完成
	echo -e "\033[33m 等待chemex镜像部署完成 \033[0m"
	sleep 20
	# 更新数据库
	echo -e "\033[33m 更新数据库 \033[0m"
	sudo docker exec chemex php artisan chemex:install
	# 结语
	echo -e "---chemex---"
	echo -e "地址:本机ip/域名"
	echo -e "账号:admin"
	echo -e "密码:admin"
	echo -e "-------------"
	echo -e "\033[32m 部署完成 \033[0m"
	read -p "按Enter结束脚本"
	exit
}
function chemexstart {
	echo -e "\033[33m 等待Docker启动完成（预计3秒） \033[0m"
	service docker restart
	sleep 3
	echo -e "\033[33m 等待Mysql容器启动完成（预计20秒） \033[0m"
	docker restart mysql-test
	sleep 20
	echo -e "\033[33m 等待chemex容器启动完成（预计5秒） \033[0m"
	docker restart chemex
	sleep 5
	echo -e "\033[32m 启动完成 \033[0m"
	exit
}
#菜单
function menu {
	echo -e "--------------------------------------------------"
	echo -e "Chemex | 一键部署脚本\033[32m v1.3 \033[0m"
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
	echo -e "适用系统:Centos | Ubuntu | Debian | 其他的我懒"
	echo -e "--------------------------------------------------"
	echo -e "当前版本最后更新日期:2022年6月14日"
	echo -e "--------------------------------------------------"
	echo -e "1. Centos部署Docker+chemex+mysql"
	echo -e "2. Ubuntu部署Docker+chemex+mysql"
	echo -e "3. Debian部署Docker+chemex+mysql"
	echo -e "4. 将chemex更新为最新版"
	echo -e "5. 启动Dcoker、Mysql、chemex"
	echo -e "0. 退出脚本"
	read -erp "输入你的选择：" input
	case "$input" in
		0)
			exit ;;
		1)
			list_centos ;;
		2)
			list_unbuntu ;;
		3)
			list_debian ;;
		4)
			list_Update ;;
		5)
			chemexstart ;;
		*)
			echo "【错误】没有此选项";;
	esac
}
menu
