FROM rossedlin/centos-apache-php:7.1

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
    rm sonar-scanner-cli-3.0.3.778.zip; \
    rm -rf /var/cache/yum;
#COPY etc/environment /etc/environment


#
# Install Ruby v2.0.0 (Yum)
#
#RUN yum update; \
#    yum install -y ruby; \
#    yum clean all; \
#    rm -rf /var/cache/yum;
#RUN gem update --system

#
# Install Ruby v2.7.0 (RVM)
#
RUN yum update; \
    yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison sqlite-devel; \
    yum clean all; \
    rm -rf /var/cache/yum;

RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -; \
    curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -; \
    curl -L get.rvm.io | bash -s stable;

RUN /bin/bash -l -c "rvm reload"
RUN /bin/bash -l -c "rvm requirements run"
RUN /bin/bash -l -c "rvm install 2.7"

RUN /bin/bash -l -c "gem update"
RUN /bin/bash -l -c "gem update --system"

#
# Install SCSS
#
RUN /bin/bash -l -c "gem install sass"

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