# Backup Server
A docker container to make automated backups of your application's data and databases to object storage or any cloud server using rclone. Currently supports mysql and mongodb backups along with other persistent data that your application may have are supported to be backed up. Remote can be any s3 or cloud storage that rclone supports. 

Also supports restoring data from a older backup on startup for easy deployment of applications.

Only those databases are backed up for which configuration environment variables have been provided.
### Instructions
* Pull the latest image using:
```
 docker pull ranapushpender/backup-server:latest
```
* Run the container using the following:
```
docker run --name backup 
    -e MYSQL_HOST=localhost
    -e MYSQL_USER=username
    -e MYSQL_PASSWORD=password
    -e MONGO_HOST=host
    -e MONGO_PORT=port
    -e MONGO_USER=user
    -e MONGO_PASSWORD=password
    -e START_NOW=yes
    -e REMOTE=rclone_remote_name
    -e BUCKET=folder_path_in_rclone_remote
    -e DIRECTORY=folder_to_make_inside_bucket
    -e NAME=name_to_give_to_backup_archives
    -e CRON_SCHEDULE=0 23 * * *
    -v /my-data-folder-1:/home/data/my-data-folder-1
    -v /my-data-folder-2:/home/data/my-data-folder-2
    -v /rclone-config-folder:/root/.config/rclone
```
* Example to restore data from a previously created backup:
```
docker run --name backup 
    -e MYSQL_HOST=localhost
    -e MYSQL_USER=username
    -e MYSQL_PASSWORD=password
    -e MONGO_HOST=host
    -e MONGO_PORT=port
    -e MONGO_USER=user
    -e MONGO_PASSWORD=password
    -e START_NOW=yes
    -e REMOTE=rclone_remote_name
    -e BUCKET=folder_path_in_rclone_remote
    -e DIRECTORY=folder_to_make_inside_bucket
    -e NAME=name_to_give_to_backup_archives
    -e CRON_SCHEDULE=0 23 * * *
    -e RESTORE_URL='https://url-of-the-backup-to-restore-data-from'
    -v /my-data-folder-1:/home/data/my-data-folder-1
    -v /my-data-folder-2:/home/data/my-data-folder-2
    -v /rclone-config-folder:/root/.config/rclone
```
#### Note
The application tries to restore data on each startup if the RESTORE_URL environment variable is specified. Remove the environment variable after the restore to prevent overwrite of new data from the backup on each startup.

### Configuration Parameters
| Environment variable name      | Description |
| -------------------------------| ----------- |
| MYSQL_HOST                         | Address of the mysql host       |
| MYSQL_USER                      | Username to use with mysql backups        |
| MYSQL_PASSWORD                      | Password to use with mysql backups        |
| MONGO_USER                      | Username to use with mongodb backups        |
| MONGO_PASSWORD                      | Password to use with mongodb backups        |
| MONGO_HOST                      | Address of the mongodb host      |
| MONGO_PORT                      | Port of the mongodb host      |
| START_NOW                      | Specifies whether to run the backup on first run of the container. Don't include it if you don't want the backup to start on first run       |
|REMOTE | Name of the remote in rclone config to upload the backup to.
| BUCKET                      | Specifies the folder in the remote to which the backup is to be uploaded        |
| DIRECTORY                      | Specifies the directory inside the bucket folder        |
| NAME                      | Specifies the name to be given to backup archives        |
| CRON_SCHEDULE                      | Specifies cron schedule to be followed        |
| RESTORE_URL | If this environment variable is specified, then the application downloads the backup archive from the URL specified in this parameter and restores the data of mysql, mongodb and other persistent data on first run. Remove this environment variable when the restore is finished else it will download and restore old data on each restart.
