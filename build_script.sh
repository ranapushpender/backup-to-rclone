apk update && apk add git
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin
docker build -t ranapushpender/backup-server:latest -t ranapushpender/backup-server:$TAG_NAME -f Dockerfile ./backup
docker push ranapushpender/backup-server:latest
docker push ranapushpender/backup-server:$TAG_NAME