Description: How to use pgBadger to extract information from PostrgeSQL logs
Date: 29/10/2017
Categories: postgresql
Summary: Extract useful information from PostgreSQL logs
Keywords: postgresql

#How to use pgBadger to extract information from PostrgeSQL logs

<https://github.com/dalibo/pgbadger>

1 Install library `pg_stat_statements`

    # postgresql.conf
    shared_preload_libraries = 'pg_stat_statements'

    pg_stat_statements.max = 10000
    pg_stat_statements.track = all


2 Add extension to database

    psql -U <user> -d <database>
    # create extension pg_stat_statements;

3 Install pgbadger as user with admin rights, in this example is `alfredo`

4 PostgreSQL configuration:

    log_min_duration_statement = 200   # ===> carefull, log fast statements causes overhead
    log_checkpoints = on
    log_connections = on
    log_disconnections = on
    log_duration = on
    log_error_verbosity = default           # terse, default, or verbose messages
    #log_hostname = off
    log_line_prefix = '%t [%p]: [%l-1] db=%d '

    log_lock_waits = on                     # log lock waits >= deadlock_timeout
    log_statement = none                    # none, ddl, mod, all
    log_temp_files = 0
         
    log_autovacuum_min_duration = 0

    lc_messages='C'

    track_activity_query_size = 2048        # (change requires restart)


5 Remove old log (or backup them)

     rm /var/lib/pgsql/data/pg_log/*

6 Restart service

    systemctl restart postgresql

7 To run the analysis

7.1 copy the log file to temp folder owned by working user (in this example is `alfredo`) and give him the property of the file

    sudo cp /var/lib/pgsql/data/pg_log/postgresql-2017-08.log /tmp/
    sudo chown alfredo:alfredo /tmp/postgresql-2017-08.log

7.2 Execute the command

    cd /tmp
    pgbadger postgresql-2017-08.log

8 copy the file to your local machine (from local)

    scp alfredo@server:/tmp/out.html <destination-folder>

9 Open the results file `out.html` with the browser

