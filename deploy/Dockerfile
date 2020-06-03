##############################################
# 基于centos7、ss5构建socker5代理
# 构建命令: 在Dockerfile文件目录下执行 docker build -t ss5 .
# 容器启动命令: docker run -dit --name ss5 --restart always --privileged=true ss5 ss5
# 进入容器：docker exec -it ss5 /bin/bash
##############################################
FROM centos:7.6.1810
MAINTAINER sgs # 指定作者信息
RUN set -ex \
    # 预安装所需组件
    && yum install -y wget tar vim gcc openldap-devel pam-devel openssl-devel make \
    && yum clean all && rm -rf /var/cache/yum/* && rm -rf /tmp/*
RUN cd /opt \
    && wget http://sourceforge.net/projects/ss5/files/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz \
    && tar -zxvf ss5-3.8.9-8.tar.gz \
    && cd ss5-3.8.9 \
    && ./configure \
    && make \
    && make install \
    && make clean \
    && rm -rf /opt/ss5-3.8.9*
CMD ["/bin/bash", "-c", "ss5 && tail -f /dev/null"]

