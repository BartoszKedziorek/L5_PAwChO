FROM scratch
ADD alpine-minirootfs-3.19.1-x86_64.tar.gz /

WORKDIR /home/root/
RUN apk add --update npm && \
    npm init -y && \
    npm install -y express && \
    apk add nginx
COPY server.js server.js


FROM nginx
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y npm && \
    apt install -y ufw
WORKDIR /etc/nginx/


COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80/tcp
COPY --from=0 /home/root/ /var/www/nodeapp/

RUN apt install -y supervisor


COPY start_script.conf /etc/supervisor/conf.d/start_script.conf
COPY start.sh /var/www/nodeapp/start.sh

RUN chmod +x /var/www/nodeapp/start.sh


COPY default.conf /etc/nginx/sites-available/default
CMD supervisord -c /etc/supervisor/supervisord.conf && /usr/sbin/nginx -g "daemon off;" 

ARG VERSION
ENV APP_VERSION=${VERSION}
HEALTHCHECK CMD curl 127.0.0.1:80 || exit 1






