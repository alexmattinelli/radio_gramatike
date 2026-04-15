FROM azuracast/azuracast:stable

ENV DISABLE_MARIADB=true \
    DISABLE_REDIS=true \
    AZURACAST_DB_TYPE=pgsql

EXPOSE 80

CMD ["/var/azuracast/www/docker/web.sh"]
