#!/bin/bash
# ------------------------------------------ 
#Version:1.4
#Date: 2022年7月14日
#Author: 仙（提醒过节小助手） 
#Email: xian@include.ink
#Website: include.ink(因为没钱续服务器挂掉了) 
#github: A-xianchu 
#License: GPL 
#------------------------------------------ 
#部署列表
function list_centos {
	echo -e ""
	echo -e "-------------"
	echo -e " CentOS"
	echo -e "---部署列表---"
	echo -e "1.Docker"
	echo -e "2.Chemex"
	echo -e "3.mysql 5.7"
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
	echo -e "3.mysql 5.7"
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
	echo -e "3.mysql 5.7"
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
function list_Hdocker {
	echo -e ""
	echo -e "-------------"
	echo -e " Docker"
	echo -e "---部署列表---"
	echo -e "1.mysql 5.7"
	echo -e "2.Chemex"
	echo -e "-------------"
	read -p "按Enter继续部署，取消请使用 Ctrl+C 快捷键"
	dockerop
}
function rdm_backupsql {
	echo -e "\033[32m【提示】本操作将会对数据库容器进行备份操作\033[0m"
	echo -e "\033[31m【警告】本操作只会备份脚本建立的数据库容器（或者容器名为'mysql-test'）\033[0m"
	echo -e "\033[32m【提示】此操作会将镜像命名为'chemexsql'，Tag命名为备份时的时间戳\033[0m"
	echo -e "\033[31m【警告】此操作只会将备份的仓库存储为image镜像，只会存储在本机！！！\033[0m"
	echo -e "\033[31m您确认进行此操作吗？\033[0m"
	read -p "按Enter开始备份，取消请使用 Ctrl+C 快捷键"
	backupsql
}
#Centos部署
function centosbs {
	echo -e "\033[33m 更新包管理器 \033[0m"
	#Docker(优化了docker安装步骤，使用了官方镜像)
	sudo yum update -y
	echo -e "\033[33m 安装curl \033[0m"
	sudo yum install curl -y
	echo -e "\033[33m 尝试关闭防火墙 \033[0m"
	systemctl disable firewalld --now
	dockerIn
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
	echo -e "\033[33m 安装curl \033[0m"
	sudo apt-get install curl -y
	#关闭防火墙（部分Ubuntu服务器默认不启用，但为了保险，还是加了这么一条）
	echo -e "\033[33m 尝试关闭防火墙 \033[0m"
	sudo ufw disable
	dockerIn
}
function debianbs {
	#Docker
	echo -e "\033[33m 更新包管理器 \033[0m"
	sudo apt-get update -y
	echo -e "\033[33m 安装curl \033[0m"
	sudo apt-get install curl -y
	#关闭防火墙（Ubuntu和Debian莫名其妙，不知道为啥东西都一样？？？？）
	echo -e "\033[33m 尝试关闭防火墙 \033[0m"
	sudo ufw disable
	dockerIn
}

function dockerIn {
	echo -e "\033[33m 接下来将会安装Docker，可能会不显示安装流程，不要怀疑是自己卡了（特殊情况下也可以认为是自己卡了） \033[0m"
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
	dockerop
}

function dockerop {
	#启动mysql容器
	echo -e "\033[33m 拉取并启动启动mysql容器 \033[0m"
	sudo docker run -itd --name mysql-test --net=host -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7
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
	echo -e "\033[33m 拉取并启动chemex容器 \033[0m"
	sudo docker run -itd --name chemex --restart=always --net=host \
	-e DB_HOST=127.0.0.1 \
	-e DB_PORT=3306 \
	-e DB_DATABASE=chemex \
	-e DB_USERNAME=root \
	-e DB_PASSWORD=123456 \
	celaraze/chemex:latest
	#10秒钟等待chemex容器启动（cnm docker）
	echo -e "\033[33m 等待chemex容器部署完成（预计20秒） \033[0m"
	sleep 20
	#写入数据库
	echo -e "\033[33m 安装chemex \033[0m"
	sudo docker exec chemex php artisan chemex:install
	showtalk
}

function showtalk {
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
	read -p "按Enter继续，取消请使用 Ctrl+C 快捷键"
	echo -e "\033[31m【警告】为保证作者对数据库的奇奇怪怪操作，此操作将会对您的数据库进行操作\033[0m"
	read -p "按Enter继续，取消请使用 Ctrl+C 快捷键"
	echo -e "\033[31m【警告】此操作将会重置您在源码层面的所有客制化操作\033[0m"
	read -p "按Enter继续，取消请使用 Ctrl+C 快捷键"
	echo -e "\033[31m【警告】数据无价，请在确认自己的备份是正确的、是可用的情况下进行此操作！\033[0m"
	echo -e "\033[31m您确认进行此操作吗？\033[0m"
	read -p "按Enter开始部署，取消请使用 Ctrl+C 快捷键"
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
	sudo docker exec chemex php artisan chemex:update
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
	sudo service docker restart
	sleep 3
	echo -e "\033[33m 等待Mysql容器启动完成（预计20秒） \033[0m"
	sudo docker restart mysql-test
	sleep 20
	echo -e "\033[33m 等待chemex容器启动完成（预计5秒） \033[0m"
	sudo docker restart chemex
	sleep 5
	echo -e "\033[32m 启动完成 \033[0m"
	exit
}
function chemexstop {
	echo -e "\033[31m【警告】生产环境请一定！一定！确保数据库备份可用！(防止炸库)\033[0m"
	read -p "按Enter继续，取消请使用 Ctrl+C 快捷键"

	echo -e "\033[33m 等待Mysql容器停止运行\033[0m"
	sudo docker restart mysql-test
	echo -e "\033[33m 等待chemex容器停止运行 \033[0m"
	sudo docker restart chemex
	echo -e "\033[33m 等待Docker停止运行 \033[0m"
	sudo service docker stop
	echo -e "\033[32m 操作完成 \033[0m"
	exit
}
#备份
function backupsql {
	echo -e "\033[33m mysql容器备份准备（预计10秒） \033[0m"
	sleep 10
	echo -e "\033[33m 加载Tag时间戳\033[0m"
	backupsql_tag="$(date +%s)"
	echo -e "\033[33m 进行Mysql容器备份\033[0m"
	sudo docker commit -a "xianer" -m "create new img" mysql-test chemexsql:$backupsql_tag
	echo -e "\033[33m 显示所有镜像\033[0m"
	sudo docker images
	# 结语
	echo -e "--mysql备份--"
	echo -e "镜像名:chemexsql"
	echo -e "镜像Tag：$backupsql_tag"
	echo -e "备份日期及时间：$(date)"
	echo -e "-------------"
	echo -e "\033[32m 备份完成 \033[0m"
	read -p "按Enter结束脚本"
	exit
}
function DockerOPmenu {
	echo -e "--------------------------------------------------"
	echo -e "Chemex_Shell | Chemex | 一键部署脚本\033[32m v1.4 \033[0m"
	echo -e "--------------------------------------------------"
	echo -e "您当前位于\033[32m Docker常用命令执行 \033[0m菜单"
	echo -e "--------------------------------------------------"
	echo -e "1. 输出所有本地容器"
	echo -e "2. 输出所有本地镜像"
	echo -e "3. 停止Chmex容器"
	echo -e "4. 停止Mysql容器"
	echo -e "5. 停止docker"
	echo -e "6. 输出Chemex容器日志"
	echo -e "7. 输出Mysql容器日志"
	echo -e "0. 返回上一页"
	read -erp "输入你的选择：" input
	case "$input" in
		0)
			menu ;;
		1)
			clear && sudo docker ps -a && DockerOPmenu ;;
		2)
			clear && sudo docker images && DockerOPmenu ;;
		3)
			clear && sudo docker stop chemex && DockerOPmenu ;;
		4)
			clear && sudo docker stop mysql-test && DockerOPmenu ;;
		5)
			clear && sudo service docker stop && DockerOPmenu ;;
		6)
			clear && sudo docker logs chemex && DockerOPmenu ;;
		7)
			clear && sudo docker logs mysql-test && DockerOPmenu ;;
		*)
			echo "【错误】没有此选项";;
	esac	
}
function chemexOPmenu {
	clear	
	echo -e "--------------------------------------------------"
	echo -e "Chemex_Shell | Chemex | 一键部署脚本\033[32m v1.4 \033[0m"	
	echo -e "--------------------------------------------------"
	echo -e "Docker默认安装\033[32m最新版\033[0m"
	echo -e "Chemex默认拉取\033[32m最新版\033[0m"
	echo -e "Mysql默认拉取\033[32m5.7\033[0m版本"
	echo -e "--------------------------------------------------"
	echo -e "因为\033[31m没有错误停止机制\033[0m，所以不管是否报错都会一直运行下去"
	echo -e "--------------------------------------------------"
	echo -e "适用系统:\033[32m Centos \033[0m|\033[32m Ubuntu \033[0m|\033[32m Debian \033[0m|\033[31m Fedora \033[0m|\033[32m Docker \033[0m|"
	echo -e "--------------------------------------------------"
	echo -e "您当前位于\033[32m 部署 \033[0m菜单"
	echo -e "--------------------------------------------------"
	echo -e "1. Centos部署Docker+chemex+mysql"
	echo -e "2. Ubuntu部署Docker+chemex+mysql"
	echo -e "3. Debian部署Docker+chemex+mysql"
	echo -e "4. Docker部署chemex+mysql"
	echo -e "0. 返回上一页"
	read -erp "输入你的选择：" input
	case "$input" in
		0)
			menu ;;
		1)
			list_centos ;;
		2)
			list_unbuntu ;;
		3)
			list_debian ;;
		4)
			list_Hdocker ;;
		*)
			echo "【错误】没有此选项";;
	esac
}
function chemexst {
	clear
	echo -e "--------------------------------------------------"
	echo -e "Chemex_Shell | Chemex | 一键部署脚本\033[32m v1.4 \033[0m"
	echo -e "--------------------------------------------------"
	echo -e "您当前位于\033[32m 开关 \033[0m菜单"
	echo -e "--------------------------------------------------"
	echo -e "1. 启动Docker+Chemex+mysql"
	echo -e "2. 关闭Docker+Chemex+mysql"
	echo -e "0. 返回上一级"
	read -erp "输入你的选择：" input
	case "$input" in
		0)
			menu ;;
		1)
			chemexstart ;;
		2)
			chemexstop ;;
		*)
			echo "【错误】没有此选项";;
	esac
}
#菜单
function menu {
	clear	
	echo -e "--------------------------------------------------"
	echo -e "Chemex_Shell | Chemex | 一键部署脚本\033[32m v1.4 \033[0m"
	echo -e "--------------------------------------------------"
	echo -e "Docker默认安装\033[32m最新版\033[0m"
	echo -e "Chemex默认拉取\033[32m最新版\033[0m"
	echo -e "Mysql默认拉取\033[32m5.7\033[0m版本"
	echo -e "--------------------------------------------------"
	echo -e "因为\033[31m没有错误停止机制\033[0m，所以不管是否报错都会一直运行下去"
	echo -e "--------------------------------------------------"
	echo -e "作者：仙(提醒过节小助手) | Github:A-xianchu"
	echo -e "感谢官方群内：时顺利、鼏図 两位大佬提供的帮助"
	echo -e "感谢某不愿透露姓名的大佬帮我优化菜单交互功能"
	echo -e "--------------------------------------------------"
	echo -e "适用系统:\033[32m Centos \033[0m|\033[32m Ubuntu \033[0m|\033[32m Debian \033[0m|\033[31m Fedora \033[0m|\033[32m Docker \033[0m|"
	echo -e "--------------------------------------------------"
	echo -e "当前版本最后更新日期:\033[32m2022年7月14日\033[0m"
	echo -e "--------------------------------------------------"
	echo -e "1. 开关		2. 部署		3. 更新"
	echo -e "4. 备份		5. 命令		0. 退出"
	read -erp "输入你的选择：" input
	case "$input" in
		0)
			exit ;;
		1)
			chemexst ;;
		2)
			chemexOPmenu ;;
		3)
			list_Update ;;
		4)
			rdm_backupsql ;;
		5)
			clear && DockerOPmenu ;;
		*)
			echo "【错误】没有此选项";;
	esac
}

function readme {
	clear
	echo -e "--------------------------------------------------"
	echo -e "Chemex | 一键部署脚本\033[32m v1.4 \033[0m"
	echo -e "-----------------公-------告----------------------"
	echo -e "使用本脚本请确保自己使用的是纯净的系统（不保证奇怪的bug）"
	echo -e "本脚本使用docker部署的所有镜像全部使用Host网络模式"
	echo -e "本脚本会关闭系统防火墙(开放所有端口)"
	echo -e "--------------------------------------------------"
	echo -e "适用系统:\033[32m Centos \033[0m|\033[32m Ubuntu \033[0m|\033[32m Debian \033[0m|\033[31m Fedora \033[0m|\033[32m Docker \033[0m|"
	echo -e "--------------------------------------------------"
	read -p "按Enter键进入菜单"	
	menu
}
readme
