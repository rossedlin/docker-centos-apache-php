FROM centos:6.7

#
# Install System Updates
#
RUN yum -y update; yum clean all

#
# Install Libraries
#
RUN yum -y install yum-plugin-ovl \
    gcc \
    libaio \
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


#Install Composer
WORKDIR /tmp
RUN curl -sS https://getcomposer.org/installer | php; \
    mv composer.phar /usr/local/bin/composer;

#Install Oracle
#WORKDIR /tmp
COPY ./docker/oracle/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm /tmp/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
COPY ./docker/oracle/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm /tmp/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
RUN rpm -ivh oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm; \
    rpm -ivh oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm; \
    pecl install oci8-2.0.12;


#
# Install X-Debug
#
# We're building from SOURCE
#
#WORKDIR /tmp
#COPY docker/xdebug/xdebug-2.2.7.zip /tmp/xdebug-2.2.7.zip
#RUN unzip xdebug-2.2.7.zip
#
#WORKDIR /tmp/xdebug-2.2.7
#RUN phpize; \
#    ./configure --enable-xdebug; \
#    make; \
#    make install;

#
# Config
#
COPY ./docker/httpd/httpd.conf /etc/httpd/conf/httpd.conf
#COPY ./docker/php/php-local.ini /etc/php.ini

#
# Cleanup
#
WORKDIR /
RUN rm -Rf tmp; \
    mkdir tmp; \
    rm /etc/httpd/conf.d/welcome.conf;
#    rm -R /var/www;

#COPY logs /var/www/logs
COPY public /var/www/public


WORKDIR /var/www

EXPOSE 80
CMD apachectl -D FOREGROUND