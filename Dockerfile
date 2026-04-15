FROM azuracast/azuracast:stable

ENV DISABLE_MARIADB=true \
    DISABLE_REDIS=true \
    AZURACAST_DB_TYPE=pgsql

EXPOSE 80

ENTRYPOINT ["/var/azuracast/www/docker/web.sh"]
