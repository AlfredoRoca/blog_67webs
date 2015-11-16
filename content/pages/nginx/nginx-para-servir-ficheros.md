Description: Configurar nginx para servir ficheros rails y evitar el error X-Accel-Mapping header missing
Date: 15/11/2015
Categories: nginx, rails
Summary: Servir los assets y los uploads de rails mediante nginx
Keywords: nginx, x-accel-mapping, rails

#Configurar nginx para servir ficheros rails y evitar el error X-Accel-Mapping header missing

Lo que he hecho yo es lo siguiente:

production.rb

    config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx


nginx.conf
    
    http {
      ...
        gzip  on;
      ...
    }

    server {
        client_max_body_size 20M;
        client_body_temp_path /var/www/uploads_temp;
        listen  80;
        server_name  my-domain;
        root         /var/www/my-app;

        location / {
                proxy_pass_header Server;
                proxy_temp_path /tmp/nginx 1 2;
                proxy_set_header  X-Real-IP  $remote_addr;
                proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_set_header X-Sendfile-Type X-Accel-Redirect;
                proxy_redirect off;
                proxy_pass http://localhost:3000;
                break;
        }

        location ~ ^/(assets)/  {
                root /var/www/my-app/shared/public/;
                gzip_static on;
                expires max;
                add_header Cache-Control public;
        }

        location ~ ^/(uploads)/  {
                root /var/www/my-app/shared/public/;
                gzip_static on;
                expires max;
                add_header Cache-Control public;
        }

    }


En <http://www.whatsmyip.org/http-compression-test/> puedes comprobar si el servidor está sirviendo archivos comprimidos.

