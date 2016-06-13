Description: Como realizar 3 backups diarios y copiar en otro servidor
Date: 13/6/2016
Categories: misc
Summary: Realizar backups diarios de las bases de datos de PostgreSQL y ficheros subidos a la aplicación y copiarlos en otro servidor es muy sencillo. En este post explico cómo yo lo he hecho usando pgdump, tar y rsync.
Keywords: backup, postgres, uploads, rsync, ssh

Realizar backups diarios de las bases de datos de PostgreSQL y ficheros subidos a la aplicación y copiarlos en otro servidor es muy sencillo. En este post explico cómo yo lo he hecho usando pgdump, tar y rsync.


#Como realizar 3 backups diarios de postgres y uploads y copiarlos a otro servidor


Para el backup de PostgreSQL utilizo los scripts disponibles en la wiki de Postgres: 

<https://wiki.postgresql.org/wiki/Automated_Backup_on_Linux>

`pg_backup.config` contiene la configuración y `pg_backup_rotated.sh` el procedimiento.

Es necesario copiar la clave rsa pública `/home/username/.ssh/id_rsa.pub` en el fichero `autorized_keys` del username en el servidor remoto.

El procedimiento para el proceso completo es el siguiente. Todo ello en la tabla `crontab` del root.

1. Ejecutar el script de backup de postgres. Esto genera los ficheros SQL.
2. Comprimir todos los ficheros subidos a la aplicación en un solo archivo. Esto genera un fichero .gz
3. Transferir al servidor remoto. Una buena solución es `rsync`

Como root, editar la tabla cron.

    [root@server-1 /]# crontab -e

    30 01 * * * /home/username/backups/pg_backup_rotated.sh -c /home/username/backups/pg_backup.config
    31 01 * * * tar -zcvf /home/username/backups/files.tar.gz /var/www/nomaspapeles/shared/public/uploads/*
    32 01 * * * rsync -avzhe 'ssh -i /home/username/.ssh/id_rsa -p PORT' /home/username/backups/* username@remote_server_IP:/home/username/backups/

Para hacerlo 3 veces al día sólo es necesaario repetir las 3 líneas a horas diferentes.

Si se desea conservar las 3 copias en el servidor remoto entonces transferir a directorios diferentes. Por ejemplo

    30 09 * * * /home/username/backups/pg_backup_rotated.sh -c /home/username/backups/pg_backup.config
    31 09 * * * tar -zcvf /home/username/backups/files.tar.gz /var/www/nomaspapeles/shared/public/uploads/*
    32 09 * * * rsync -avzhe 'ssh -i /home/username/.ssh/id_rsa -p PORT' /home/username/backups/* username@remote_server_IP:/home/username/backups/a_las_nueve_y_media
