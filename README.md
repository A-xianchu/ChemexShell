# ChemexShell
Chemex的一键部署脚本
***

## 使用

使用wget一键下载脚本并启动

```shell
wget http://include-cloud.test.upcdn.net/chemex.sh && chmod +x chemex.sh && bash chemex.sh
```

更新脚本

```shell
rm -rf chemex.sh && wget http://include-cloud.test.upcdn.net/chemex.sh && chmod +x chemex.sh && bash chemex.sh
```

删除脚本

```shell
rm -rf chemex.sh
```
***


# chemex | 一键部署脚本开发文档

***

作者：仙（提醒过节小助手）

GitHub：A-xianchu

***

## V1.1

首先**感谢官方群内：时顺利、鼏図 两位大佬提供的帮助**

这个版本是第一个版本，仅拥有一键部署的功能，且仅支持Centos

通过先部署docker然后在有docker的前提拉取mysql和chemex进行容器部署

将命令注入到mysql用的是两条命令的组合

一条是docker自带的exec命令，可以向容器内注入命令

```shell
docker exec [容器id] [命令]
```

一条是mysql的外部运行命令，可以在不进入mysql的情况下进行SQL操作

```shell
mysql -h[服务器地址] -P[端口] -u[用户名] -p[密码] -e "[命令]"
```

将两条命令结合形成如下命令：

```shell
docker exec [容器id] mysql -h[服务器地址] -P[端口] -u[用户名] -p[密码] -e "[命令]"
```

在脚本的实际应用中是如下命令：

```shell
#注意，在使用此命令时，mysql会报出在使用命令操作不安全的Wraing提示，不必理会即可

docker exec mysql-test mysql -h127.0.0.1 -P3306 -uroot -p123456 -e "create database chemex;"
```

将命令注入到Chemex进行数据库写入时也用到了同样的操作，实际应用如下：

```shell
docker exec chemex php artisan chemex:install
```

在脚本的第一次完整测试的时候，我发现，在运行脚本的时候，写入mysql库的时候会报错，然后mysql就会重启

经过我和**时顺利**的探讨，发现mysql的启动时间跟不上命令的写入时间，也就是启动的太慢

最后添加了

```shell
sleep 60
```

在创建完容器创建数据库之前等待六十秒

之后发现chemex在数据库没有问题的情况下写入不成功

最开始我们俩怀疑是连接问题，在排除了是连接问题、数据库本身的问题、网络问题、和chemex本身的问题后

我们俩惊奇的发现

TMD！docker的容器启动也需要时间。。。。。。。。。

最后就变成了在启动了chemex的镜像命令后加入了

```shell
sleep 20
```

你以为这就正常了？

mysql建库也需要tmd时间

最后就是变成了下面的情况

```shell
	#启动mysql容器
	docker run -itd --name mysql-test --net=host -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql
	#60秒种等待mysql容器启动（cnm mysql）
	echo "等待mysql容器部署完成（预计60秒）"
	sleep 60
	#创建数据库
	docker exec mysql-test mysql -h127.0.0.1 -P3306 -uroot -p123456 -e "create database chemex;"
	#60秒钟等待
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
```

.........

无语至极，就因为这三个`sleep`整整tm浪费了一个钟！

草！

**弊端**

```
1.数据库密码是我设好的（小声逼逼：有需求可以自己改嘛）
2.防火墙被强制关了（小声逼逼：有需求可以自己再打开嘛）
```

### 界面展示

#### 		**开始界面**

![开始](https://inews.gtimg.com/newsapp_ls/0/14973002557/0)

#### 		**结束界面**

![结束](https://inews.gtimg.com/newsapp_ls/0/14973002577/0)
