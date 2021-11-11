FROM bitnami/minideb:bullseye

ARG FTP_UID=48
ARG FTP_GID=48

RUN set -x \
  && groupadd -g ${FTP_GID} ftp \
  && useradd --no-create-home --home-dir /run/proftpd -s /bin/false --uid ${FTP_UID} --gid ${FTP_GID} -c 'ftp daemon' ftp \
  ;

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends proftpd-mod-crypto proftpd-core openssl less nano\
	&& apt-get clean  \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/ \
#	&& sed -i "s/# DefaultRoot/DefaultRoot/" /etc/proftpd/proftpd.conf \
	;

ENV ALLOW_OVERWRITE=on \
    ANONYMOUS_DISABLE=on \
    ANON_UPLOAD_ENABLE=DenyAll \
    FTPUSER_PASSWORD_SECRET=ftp-user-password-secret \
    FTPUSER_NAME=ftpuser \
    LOCAL_ROOT=~ \
    LOCAL_UMASK=022 \
    MAX_CLIENTS=25 \
    MAX_INSTANCES=50 \
    SERVER_NAME=ProFTPD \
    TIMES_GMT=off \
    TZ=UTC \
    WRITE_ENABLE=AllowAll


EXPOSE 21 4559-4564

ADD proftpd.conf.j2 /etc/proftpd/proftpd.conf
ADD entrypoint.sh /usr/local/sbin/entrypoint.sh

VOLUME ["/etc/proftpd", "/srv"]

ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
CMD ["proftpd", "--nodaemon"]
