FROM centos:6.7

#
# Install System Updates
#
RUN yum -y update; yum clean all

#
# Install Libraries
#
RUN yum -y install yum-plugin-ovl \
    vim-X11 \
    vim-common \
    vim-enhanced \
    vim-minimal \
    gcc \
    libaio \
    zip \
    unzip; yum clean all

#
# Install Apache & PHP
#
RUN yum -y install httpd \
    php \
    php-xml \
    php-ldap \
    php-mbstring \
    php-mysql \
    php-pear \
    php-devel; yum clean all

#
# Cleanup
#
#RUN yum clean all


##Install Composer
#WORKDIR /tmp
#RUN curl -sS https://getcomposer.org/installer | php
#RUN mv composer.phar /usr/local/bin/composer

##Install Oracle
##WORKDIR /tmp
#ADD ./docker/oracle/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm /tmp/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
#ADD ./docker/oracle/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm /tmp/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
#RUN rpm -ivh oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
#RUN rpm -ivh oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
#RUN pecl install oci8-2.0.12


##
## Install X-Debug
##
## We're building from SOURCE
##
#WORKDIR /tmp
#ADD docker/xdebug/xdebug-2.2.7.zip /tmp/xdebug-2.2.7.zip
#RUN unzip xdebug-2.2.7.zip
#
#WORKDIR /tmp/xdebug-2.2.7
#RUN phpize
#RUN ./configure --enable-xdebug
#RUN make
#RUN make install

#
# Config
#
RUN rm /etc/httpd/conf.d/welcome.conf
ADD ./docker/httpd/local.conf /etc/httpd/conf.d/local.conf
ADD ./docker/php/php-local.ini /etc/php.ini
ADD logs /var/www/exeter/logs
ADD public /var/www/exeter/public


WORKDIR /var/www/exeter

EXPOSE 80
CMD apachectl -D FOREGROUND
##/usr/sbin/apachectl start