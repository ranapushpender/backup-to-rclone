FROM alpine:latest
WORKDIR /root
RUN apk add curl
RUN apk add mysql-client
RUN apk add mongodb-tools
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
RUN unzip rclone-current-linux-amd64.zip
RUN mv rclone-*-linux-amd64 rclone
WORKDIR /root/rclone
RUN cp rclone /usr/bin/
RUN chown root:root /usr/bin/rclone
RUN chmod 755 /usr/bin/rclone
RUN mkdir -p /usr/share/man/man1
RUN cp rclone.1 /usr/share/man/man1/
COPY . /root
RUN chmod a+x /root/backup.sh
RUN chmod a+x /root/entrypoint.sh
RUN mkdir /root/backups
RUN mkdir /root/backups-temp
RUN mkdir /root/restore
RUN echo "0 23 * * * /root/backup.sh > /root/backup.log" >> /var/spool/cron/crontabs/root
VOLUME ["/home"]
WORKDIR /root
CMD /root/backup.sh && crond -l 8 -f