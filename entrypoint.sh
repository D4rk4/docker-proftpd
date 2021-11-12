#!/bin/bash

if [ -n "$FTP_USERNAME" -a -n "$FTP_PASSWORD" ]; then
	CRYPTED_PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' $FTP_PASSWORD)
    if id "$FTP_USERNAME" > /dev/null 2>&1; then
        usermod --password $CRYPTED_PASSWORD $FTP_USERNAME
    else
	    useradd -m -s /bin/sh -d /home/$FTP_USERNAME --password $CRYPTED_PASSWORD $FTP_USERNAME
	    chown -R $FTP_USERNAME:$FTP_USERNAME /home/$FTP_USERNAME
    fi
fi

sed -i \
    -e "s:{{ ALLOW_OVERWRITE }}:$ALLOW_OVERWRITE:" \
    -e "s:{{ ANONYMOUS_DISABLE }}:$ANONYMOUS_DISABLE:" \
    -e "s:{{ ANON_UPLOAD_ENABLE }}:$ANON_UPLOAD_ENABLE:" \
    -e "s:{{ LOCAL_UMASK }}:$LOCAL_UMASK:" \
    -e "s:{{ LOCAL_ROOT }}:$LOCAL_ROOT:" \
    -e "s:{{ MAX_CLIENTS }}:$MAX_CLIENTS:" \
    -e "s:{{ MAX_INSTANCES }}:$MAX_INSTANCES:" \
    -e "s:{{ PASV_ADDRESS }}:$PASV_ADDRESS:" \
    -e "s+{{ SERVER_NAME }}+$SERVER_NAME+" \
    -e "s:{{ TIMES_GMT }}:$TIMES_GMT:" \
    -e "s:{{ WRITE_ENABLE }}:$WRITE_ENABLE:" \
    /etc/proftpd/proftpd.conf

exec "$@"
