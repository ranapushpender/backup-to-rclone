export DATE=`date +"%d-%m-%Y_%H-%M-%S"`
export GZIP=-9

if ! [[ -z "$MYSQL_HOST" ]]; then
    echo "Backing up mysql"
    mysqldump --single-transaction --host $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD --all-databases > /root/backups-temp/mysql-$NAME-$DATE.sql
    echo "Mysql backup complete"
fi

if ! [[ -z "$MONGO_HOST" ]]; then
    echo "Backing up mongo"
    mongodump --host=$MONGO_HOST --port=$MONGO_PORT --username=$MONGO_USER --password=$MONGO_PASSWORD --out=/root/backups-temp/mongodump-$NAME-$DATE
    echo "Mongo Backup Complete"
fi
echo "Making archive"
tar -cvzf /root/backups/backup-$NAME-$DATE.tar.gz /home /root/backups-temp
echo "Archive Made"

echo "Copying to remote"
rclone copy --progress /root/backups/* $REMOTE:$BUCKET/$DIRECTORY
echo "Copied to remote"

echo "Deleting temporary files"
#Removind data after backup
rm -rf /root/backups/*
rm -rf /root/backups-temp/*
echo "Backup Complete"