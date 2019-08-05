FROM rossedlin/centos-apache-php:7.2

WORKDIR /tmp

#
# Install VIM
#
RUN yum update; \
    yum install -y vim; \
    yum clean all; \
    rm -rf /var/cache/yum;

#
# Install X-Debug
#
RUN yum update; \
    yum install -y php-xdebug \
    yum clean all; \
    rm -rf /var/cache/yum;

#
# Install Sonar Scanner
#
COPY sonar/sonar-scanner-cli-3.0.3.778.zip /tmp/sonar-scanner-cli-3.0.3.778.zip
RUN yum update; \
    yum install -y which; \
    yum install -y java-1.8.0-openjdk; \
    unzip sonar-scanner-cli-3.0.3.778.zip; \
    mv sonar-scanner-3.0.3.778/ /opt/sonar/; \
    rm sonar-scanner-cli-3.0.3.778.zip;
#COPY etc/environment /etc/environment

#
# Copy Development INI
#
COPY ./php/php-development.ini /etc/php.ini

#
# Perms
#
RUN chmod 777 -R /var/www

RUN yum --enablerepo=remi install -y php-intl

#
# Finish
#
WORKDIR /var/www