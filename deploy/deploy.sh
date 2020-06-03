#########################################################################
# File Name: deploy.sh
# Author: qiezi
# mail: qiezi@gmail.com
# Created Time: Wed 19 Feb 2020 12:29:13 PM CST
#########################################################################
#!/bin/bash

# ===================run the script with root user=================================
# ==========================开始配置==================================

# 1.docker-compose.yml依赖配置
SS5_VERSION=1.0
# 宿主机ss5服务端口
REAL_SS5_PORT=1080

# 2.squid服务配置
# squid的用户名
ss5_username=ss5
# squid的密码
ss5_password=online


# 是否指定pip的下载源
# pip_repository=https://pypi.tuna.tsinghua.edu.cn/simple
pip_repository=

# ==========================配置结束==================================

ss5_dir=..
mkdir -p $ss5_dir/logs


# 声明变量
install_docker_script=./install_docker.sh
ss5_conf=$ss5_dir/ss5.conf
ss5_users=$ss5_dir/ss5.passwd
ss5_logs=$ss5_dir/logs


# 检查/安装docker和docker-compose
if [ -n "$pip_repository" ]
then
    sed -i "s#pip install#pip install -i $pip_repository#g" $install_docker_script
fi
sh $install_docker_script
if [ -n "$pip_repository" ]
then
    git checkout $install_docker_script
fi

echo "$ss5_username $ss5_password" > $ss5_users

echo "SS5_VERSION=$SS5_VERSION
REAL_SS5_PORT=$REAL_SS5_PORT

SS5_CONF=$ss5_conf
SS5_USERS=$ss5_users
SS5_LOGS=$ss5_logs
" > .env

echo "auth 0.0.0.0/0 - u
permit u 0.0.0.0/0 - 0.0.0.0/0 - - - - -
" > $ss5_conf

# 启动服务
docker-compose up -d
firewall-cmd --permanent --add-port=$REAL_SS5_PORT/tcp
firewall-cmd --permanent --add-port=$REAL_SS5_PORT/udp

# 重新加载防火墙
firewall-cmd --reload

