export DATE=`date +"%d-%m-%Y_%H-%M-%S"`
export GZIP=-9
tar -cvzf /root/backups/backup-$NAME-$DATE.tar.gz /home
rclone copy /root/backups/* $REMOTE:$BUCKET/$DIRECTORY
rm -rf /root/backups/*
echo "Backup Completed"