FROM ubuntu:20.04

RUN apt update && apt install -y apache2
COPY index.html /var/www/html/
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
CMD ["/start.sh"]
