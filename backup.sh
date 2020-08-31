export DATE=`date +"%d-%m-%Y_%H-%M-%S"`
export GZIP=-9

if ! [[ -z "$RESTORE_BACKUP" ]]; then
    curl $RESTORE_URL -o ./restore/backup.tar.gz
    tar xzfv ./restore/backup.tar.gz --directory=./restore
    cp -r ./restore/home/. /home/
    echo "Waiting for some time for server to come up"
    sleep 60
    if ! [[ -z "$MYSQL_HOST" ]]; then
        echo "Restoring mysql"
        export mysql_backup_name=`ls ./restore/root/backups-temp | grep sql`
        mysql --host $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD  < ./restore/root/backups-temp/$mysql_backup_name
        echo "Restoring mysql complete"
    fi
    
    if ! [[ -z "$MONGO_HOST" ]]; then
        echo "Restoring mongo"
        export mongo_backup_name=`ls ./restore/root/backups-temp | grep mongo`
        mongorestore --host=$MONGO_HOST --port=$MONGO_PORT --username=$MONGO_USER --password=$MONGO_PASSWORD ./restore/root/backups-temp/$mongo_backup_name/
        echo "Mongo Restore Complete"
    fi
    
    rm -rf restore/*
    echo "Restore Done"
    exit
fi

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