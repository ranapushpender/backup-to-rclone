FROM alpine:latest
WORKDIR /root
RUN apk add curl && \
    apk add mysql-client  && \
    apk add mongodb-tools
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    mv rclone-*-linux-amd64 rclone
WORKDIR /root/rclone
RUN cp rclone /usr/bin/ && \
    chown root:root /usr/bin/rclone && \
    chmod 755 /usr/bin/rclone && \
    mkdir -p /usr/share/man/man1 && \
    cp rclone.1 /usr/share/man/man1/
COPY . /root
RUN chmod a+x /root/backup.sh && \
    chmod a+x /root/entrypoint.sh && \
    chmod a+x /root/start.sh && \
    mkdir /root/backups  && \
    mkdir /root/backups-temp  && \
    mkdir /root/restore
VOLUME ["/home"]
WORKDIR /root
CMD /root/start.sh && crond -l 8 -f