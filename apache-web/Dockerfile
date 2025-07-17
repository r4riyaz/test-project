FROM ubuntu:24.04
RUN apt update && apt install -y apache2
COPY index.html /var/www/html/
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
