# ChemexShell - Chemex一键部署脚本

[Chemex Github 开源地址](https://github.com/celaraze/chemex)

## 开源协议

ChemexShell遵循 [GPL3.0](https://www.gnu.org/licenses/gpl-3.0.html) 开源协议。

## 部署列表（v1.2版本）

| Centos        | Ubuntu        | Debian        | Fedora | RHCL   | Arch   | openSUSE | Kali   |
| ------------- | ------------- | ------------- | ------ | ------ | ------ | -------- | ------ |
| Docker        | Docker        | Docker        | 不支持 | 不支持 | 不支持 | 不支持   | 不支持 |
| Docker-Mysql  | Docker-Mysql  | Docker-Mysql  | \      | \      | \      | \        | \      |
| Docker-Chemex | Docker-Chemex | Docker-Chemex | \      | \      | \      | \        | \      |

## 使用

使用wget一键下载脚本并启动

```shell
wget https://ghproxy.futils.com/https://github.com/A-xianchu/ChemexShell/blob/main/chemex.sh && chmod +x chemex.sh && bash chemex.sh
```

更新脚本

```shell
rm -rf chemex.sh && wget https://ghproxy.futils.com/https://github.com/A-xianchu/ChemexShell/blob/main/chemex.sh && chmod +x chemex.sh && bash chemex.sh
```

删除脚本

```shell
rm -rf chemex.sh
```
