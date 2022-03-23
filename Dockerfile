FROM centos:7 
RUN yum install -y gcc gcc-c++ make gd-devel libxml2-devel libcurl-devel sqlite-devel pcre pcre-devel openssl openssl-devel
RUN useradd -M -s /sbin/nologin nginx
ADD nginx-1.17.6.tar.gz /tmp/
RUN cd /tmp/nginx-1.17.6 && \ 
    ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module  --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module && \
    make && make install
ADD nginx.conf /tmp/
ADD phpinfo.php /tmp/
RUN cp /tmp/nginx.conf /usr/local/nginx/conf/nginx.conf
RUN cp /tmp/phpinfo.php /usr/local/nginx/html/
RUN echo '<h1 align="center">Hello World 2022 Docker!!!</h1>' > /usr/local/nginx/html/index.html
ENV PATH /usr/local/nginx/sbin:$PATH
EXPOSE 80
ADD php-7.4.9.tar.gz /tmp/
ADD ./php-fpm.conf /tmp/
ADD ./www.conf /tmp/
ADD ./php.ini /tmp/
RUN cd /tmp/php-7.4.9 && \
    ./configure --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --enable-fpm && \
    make -j 4 && \
    make install && \
    cp /tmp/php-fpm.conf /usr/local/php/etc/php-fpm.conf && cp /tmp/www.conf /usr/local/php/etc/php-fpm.d/www.conf && sed -i "s/127.0.0.1/0.0.0.0/" /usr/local/php/etc/php-fpm.conf &&     sed -i "21a \daemonize = no" /usr/local/php/etc/php-fpm.conf && cp /tmp/php.ini /usr/local/php/etc/php.ini
RUN rm -rf /tmp/php-7.4.9*
WORKDIR /usr/local/php
EXPOSE 9000
ADD start.sh /usr/local/nginx/sbin/start.sh
CMD ["/bin/sh", "/usr/local/nginx/sbin/start.sh"]
