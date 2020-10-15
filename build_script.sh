apk update && apk add git
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin
docker build -t ranapushpender/backup-to-rclone:latest -t ranapushpender/backup-to-rclone:$TAG_NAME backup
docker push ranapushpender/backup-to-rclone:latest
docker push ranapushpender/backup-to-rclone:$TAG_NAME