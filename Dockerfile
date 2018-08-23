FROM centos:7.5.1804

WORKDIR /tmp

#
# Install System Updates
#
RUN yum -y update; \
    yum clean all; \
    rm -rf /var/cache/yum;

#
# Install Libraries
#
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
    yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm; \
    yum install -y yum-utils; \
    yum install -y wget; \
    yum clean all; \
    rm -rf /var/cache/yum;

#RUN yum -y install yum-plugin-ovl \
#    gcc \
#    libaio \
#    unzip; yum clean all

#
# Install Httpd v2.4.34
#
RUN cd /etc/yum.repos.d && wget https://repo.codeit.guru/codeit.el`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`.repo; \
    yum install -y httpd; \
    yum clean all; \
    rm -rf /var/cache/yum;

#
# Install PHP v7.0.31
#
RUN yum-config-manager --enable remi-php70; \
    yum install -y php \
#    php-mcrypt \
#    php-cli \
#    php-gd \
#    php-curl \
#    php-mysql \
#    php-ldap \
#    php-zip \
#    php-fileinfo; \
    yum clean all; \
    rm -rf /var/cache/yum;

#
# Install Composer
#
RUN curl -sS https://getcomposer.org/installer | php; \
    mv composer.phar /usr/local/bin/composer;


#
# Setup Httpd & PHP
#
RUN rm -R /var/www; \
    rm /etc/httpd/conf.d/welcome.conf;

COPY ./httpd/httpd.conf /etc/httpd/conf/httpd.conf
COPY ./php/php-development.ini /etc/php.ini
COPY public /var/www/public

#
# Cleanup
#
RUN rm -Rf tmp; \
    mkdir tmp;

#
# Finish
#
WORKDIR /var/www
EXPOSE 80
CMD apachectl -D FOREGROUND