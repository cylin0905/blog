#!/bin/bash 
#authored by cylin 2020.09.16
#############################
echo -e "\033[032m 1.安装nginx1.16.0 \033[0m"
echo
echo -e "\033[031m 2.删除nginx \033[0m"
echo
read -p "请选择:" choice
if [[ $choice == 1 ]];then
echo
echo -e "\033[032m 已选择$choice,安装nginx,请稍等...\033[0m"
sleep 2
echo 
echo -e "\033[031m 安装环境检测中，请稍等...\033[0m"
sleep 2
#检查80端口是否占用
yum install -y lsof >/dev/null 2>&1
pID80=`lsof -i:80 | grep -v "PID" | awk '{print $2}'`
if [ "$pID80" != "" ];then
echo "80端口已被占用，请检查运行环境,程序已退出!"
sleep 2
else
echo
NGX_SOFT="nginx-1.16.0.tar.gz"
NGX_DIR="/usr/local/nginx"
NGX_URL="http://nginx.org/download"
NGX_SRC="nginx-1.16.0"
NGX_ARGS="--user=www --group=www --with-http_stub_status_module"
echo -e "\033[31m 安装依赖环境中...\033[0m"
yum install -y wget tar make gcc net-tools pcre pcre-devel zlib-devel >/dev/null 2>&1
echo
sleep 2
echo -e "\033[31m 安装nginx中...\033[0m"
wget -c $NGX_URL/$NGX_SOFT -P /usr/src/ >/dev/null 2>&1
cd /usr/src
#ls -l $NGX_SOFT
#echo "解压nginx中..."
tar -zxvf $NGX_SOFT >/dev/null 2>&1
cd $NGX_SRC/
useradd -s /sbin/nologin www -M
./configure --prefix=$NGX_DIR/ $NGX_ARGS >/dev/null 2>&1
make -s  && make -s  install >/dev/null 2>&1
#ls -l $NGX_DIR/
echo
sleep 2
echo -e "\033[31m 启动nginx中...\033[0m"
$NGX_DIR/sbin/nginx >/dev/null 2>&1
#CentOS7.x防火墙开启80端口
firewall-cmd --add-port=80/tcp --permanent >/dev/null 2>&1
firewall-cmd --reload 
setenforce 0
#ps -ef | grep -aiwE nginx
#netstat -tunlp |grep -aiwE 80
echo
sleep 2
echo -e "\033[32m 恭喜! nginx部署完成!\033[0m"
#CentOS6.x防火墙开启80端口
#iptables -t filter -A INPUT -m tcp -p --dport 80 -j ACCEPT
#service iptables save
sleep 2
fi
fi
if [[ $choice == 2 ]];then
echo
echo -e "\033[032m 已选择$choice,请稍等...\033[0m"
echo
sleep 2
echo -e "\033[031m 正在卸载nginx中...\033[0m"
echo
sleep 2
echo -e  "\033[031m 检查运行路径中...\033[0m"
runpath=`ps -ef | grep nginx | awk '{print $11}' | head -1`
echo 
if [ "$runpath" == "" ];then
echo -e "\033[031m nginx没有运行,检查是否安装...\033[0m"
echo
sleep 2
installpath=`find / -name nginx`
if [ "$installpath" != "" ];then
echo -e "\033[031m 卸载安装文件中...\033\0m"
echo
find / -name nginx |xargs rm -rf >/dev/null 2>&1
userdel -rf www >/dev/null 2>&1
sleep 2
echo -e "\033[033m 清理完成\033[0m"
echo
else
echo -e "\033[031m nginx没有安装,无需卸载\033[0m"
fi
else
echo -e "\033[033m 已检查nginx运行路径为:$runpath\033[0m"
echo 
echo -e "\033[031m 停止nginx中...\033[0m"
echo
$runpath -s stop
sleep 2
echo -e "\033[031m 卸载安装文件中...\033[0m"
echo
find / -name nginx |xargs rm -rf >/dev/null 2>&1
userdel -rf www >/dev/null 2>&1
sleep 2
echo -e "\033[033m 清理完成\033[0m"
fi
fi
