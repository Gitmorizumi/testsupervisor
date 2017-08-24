FROM centos:centos7
MAINTAINER morizumi_san

# Supervisord の設定ファイルを Docker イメージ内に転送する
ADD supervisord.conf /etc/supervisord.conf

# Apache httpd でトップページに表示する Web ページを Docker イメージ内に転送する
ADD index.html /var/www/html/

# 必要なパッケージをインストールする
RUN yum -y install httpd mariadb-server python-pip openssh-server

# SSHのパスワード設定
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN /usr/bin/ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ""
RUN /usr/bin/ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ""

#監視スクリプトを転送
ADD prochk.sh prochk.sh
RUN chmod +x prochk.sh

# PIP で Supervisord をインストールする
RUN yum -y install python-setuptools
RUN easy_install pip
RUN pip install supervisor

# SSH およびApache httpd  MariaDB が使うポートを外部に公開する
EXPOSE 22 80 3306

# Supervisord を起動する
CMD ["/usr/bin/supervisord","-c", "/etc/supervisord.conf"]
