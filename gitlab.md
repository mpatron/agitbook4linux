# Gitlab dans docker

## Préparation

~~~bash
mkdir -p ~/gitlab/{config,data,logs}
~~~

## Lancement

~~~bash
sudo docker run --detach \
    --hostname gitlab.mon-domaine.fr \
    --publish 4433:443 --publish 8080:80 --publish 2222:22 \
    --name gitlab \
    --restart always \
    --volume ~/gitlab/config:/etc/gitlab \
    --volume ~/gitlab/logs:/var/log/gitlab \
    --volume ~/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
~~~
ssh://git@docker.jobjects.org:2222/ansible/monprojet

Rapidos :-)
