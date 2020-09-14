#2020.09.14
#auto install nginx
#authored by cylin
####################
NGX_SOFT="nginx-1.16.0.tar.gz"
NGX_DIR="/usr/local/nginx"
NGX_URL="http://nginx.org/download"
NGX_SRC="nginx-1.16.0"
NGX_ARGS="--user=www --group=www --with-http_stub_status_module"
echo "安装依赖环境中..."
yum install -y wget tar make gcc net-tools pcre pcre-devel zlib-devel >/dev/null 2>&1
echo "安装nginx中..."
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
echo "启动nginx中..."
$NGX_DIR/sbin/nginx
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload 
setenforce 0
#ps -ef | grep -aiwE nginx
netstat -tunlp |grep -aiwE 80
echo "恭喜! nginx部署完成!"
#CentOS6.x
#iptables -t filter -A INPUT -m tcp -p --dport 80 -j ACCEPT
#service iptables save
