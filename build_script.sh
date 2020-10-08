apk update && apk add git
echo "$GITLAB_PASSWORD" | docker login -u "$GITLAB_USER" --password-stdin registry.gitlab.com
export TAG_NAME=`git rev-parse HEAD`
docker build -t registry.gitlab.com/ranapushpender/backup-server/backup-server:latest -t registry.gitlab.com/ranapushpender/backup-server/backup-server:$TAG_NAME  -f Dockerfile .
docker push registry.gitlab.com/ranapushpender/backup-server/backup-server:latest
docker push registry.gitlab.com/ranapushpender/backup-server/backup-server:$TAG_NAME