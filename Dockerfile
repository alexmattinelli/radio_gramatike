FROM azuracast/azuracast:stable

ENV DISABLE_MARIADB=true
ENV DISABLE_REDIS=true
ENV AZURACAST_DB_TYPE=pgsql

EXPOSE 80

CMD ["/var/azuracast/www/docker/web.sh"]

