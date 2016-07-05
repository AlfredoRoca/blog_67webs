Description: Certificado emitido por Let's Encrypt con nuevo cliente Certbot
Date: 5/7/2016
Categories: nginx, letsencrypt
Summary: Cómo conseguir y renovar automáticamente certificado SSL emitido por Let's Encrypt. Requiere un poco de configuración Nginx
Keywords: nginx, letsencrypt, ssl, webroot

#Certificado emitido por Let's Encrypt con nuevo cliente Certbot

<https://letsencrypt.readthedocs.io/en/latest/#>

##Instalar el cliente Certbot

Visitar <https://certbot.eff.org/> para ver si hay algún paquete para el SO destino.

En Fedora 21 lo he instalado así:

En `/usr/local/bin`
    
    root# wget https://dl.eff.org/certbot-auto
    root# chmod a+x certbot-auto

###Opciones de la línea de comandos:

    certbot --help all

<https://certbot.eff.org/docs/using.html#command-line-options>


El plugin `webroot` permite crear y renovar el certificado sin parar Nginx. 

##Crear el certificado SSL la primera vez 

    certbot-auto certonly --webroot -w /var/www/nomaspapeles/shared/public -d nomaspapeles.com -d www.nomaspapeles.com --email admin@example.com --agree-tos

##Configuración de Nginx

server {
....

        ssl on;

#       certificate managed by letsencrypt
#       See: https://letsencrypt.readthedocs.org/en/latest/using.html#renewal
        ssl_certificate_key /etc/letsencrypt/live/nomaspapeles.com/privkey.pem;
        ssl_trusted_certificate /etc/letsencrypt/live/nomaspapeles.com/chain.pem;
        ssl_certificate /etc/letsencrypt/live/nomaspapeles.com/fullchain.pem;


        root         /var/www/nomaspapeles/shared/public;

        location ~ /.well-known/  {
                allow all;
        }


##Renovación

Añadir la siguiente línea a crontab

    00 01 01 * * certbot-auto renew

El certificado sólo dura 90 días. Sin embargo, sólo se procede a la renovación si faltan menos de 30 días para su caducidad.