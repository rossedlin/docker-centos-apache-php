FROM centos:6.7

#Install System Updates
RUN yum -y update; yum clean all

#Install plugins for Docker to function correctly
RUN yum -y install yum-plugin-ovl

#Install VIM
RUN yum -y install vim-X11 vim-common vim-enhanced vim-minimal; yum clean all

#Install Libs
RUN yum -y install gcc libaio; yum clean all

#Install Apache
RUN yum -y install httpd; yum clean all
RUN rm /etc/httpd/conf.d/welcome.conf

#Install PHP
RUN yum -y install php php-xml php-ldap php-mbstring php-mysql php-pear php-devel; yum clean all

#Install Composer
WORKDIR /tmp
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

#Install Oracle
#WORKDIR /tmp
ADD ./docker/oracle/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm /tmp/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
ADD ./docker/oracle/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm /tmp/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
RUN rpm -ivh oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
RUN rpm -ivh oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
RUN pecl install oci8-2.0.12

#Config
ADD ./docker/httpd/local.conf /etc/httpd/conf.d/local.conf
ADD ./docker/php/php-local.ini /etc/php.ini

#Add Init Files
ADD logs /var/www/exeter/logs
ADD public /var/www/exeter/public

WORKDIR /var/www/exeter

EXPOSE 80
CMD apachectl -D FOREGROUND
#/usr/sbin/apachectl start