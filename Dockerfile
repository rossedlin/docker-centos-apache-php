FROM centos:6.7

#Install System Updates
RUN yum -y update; yum clean all

#Install plugins for Docker to function correctly
RUN yum -y install yum-plugin-ovl

#Install VIM
RUN yum -y install vim-X11 vim-common vim-enhanced vim-minimal; yum clean all

#Install Apache
RUN yum -y install httpd; yum clean all
RUN rm /etc/httpd/conf.d/welcome.conf
ADD ./docker/httpd/local.conf /etc/httpd/conf.d/local.conf

#Install PHP
RUN yum -y install php php-ldap php-mbstring php-mysql; yum clean all
ADD ./docker/php/php-local.ini /etc/php.ini

#Install Composer
WORKDIR /tmp
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

WORKDIR /var/www/vacancies

#/usr/sbin/apachectl start