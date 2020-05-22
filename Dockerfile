FROM alpine:latest
WORKDIR /root
RUN apk add curl
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
RUN mkdir /root/backups
RUN echo "* * * * * /root/backup.sh > /root/backup.log" >> /var/spool/cron/crontabs/root
WORKDIR /root
CMD crond -l 8 -f