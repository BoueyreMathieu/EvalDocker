# J'avais commencé par prendre une image nextcloud, ce qui me donnait déjà toutes les dépendances qu'il fallait, 
# mais j'imagine que le coeur de l'exercice n'était pas là
FROM debian:latest 

ARG ARCHIVE_URL=https://download.nextcloud.com/server/releases/nextcloud-29.0.3.tar.bz2
# Passé la 1ere première fois, le téléchargement prenait à chaque fois presque 10 minutes, pas fou pour les dernires tests

RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-php \
    php \
    php-gd \
    php-mysql \
    php-curl \
    php-xml \
    php-mbstring \
    php-zip \
    php-intl \
    php-bcmath \
    php-gmp \
    wget \
    tar \
    bzip2 \
    && apt-get clean

RUN wget -O /tmp/nextcloud.tar $ARCHIVE_URL && \
    tar -xvf /tmp/nextcloud.tar -C /var/www/html 
    # && \
    # rm /tmp/nextcloud.tar

COPY /var/www/html /var/www/html

RUN chown -R www-data:www-data /var/www/html

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite
RUN service apache2 restart

CMD ["apache2ctl", "-D", "FOREGROUND"]
