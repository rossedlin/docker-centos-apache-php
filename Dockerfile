FROM rossedlin/centos-apache-php:7.1

WORKDIR /tmp

#
# Install X-Debug
#
RUN yum install -y php-xdebug \
    yum clean all; \
    rm -rf /var/cache/yum;

#
# Install Sonar Scanner
#
COPY sonar/sonar-scanner-cli-3.0.3.778.zip /tmp/sonar-scanner-cli-3.0.3.778.zip
RUN yum install -y which; \
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

#
# Finish
#
WORKDIR /var/www