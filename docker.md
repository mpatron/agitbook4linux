# Docker sous Ubuntu 20.04 LTS

~~~bash
sudo apt -y update
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt -y update
~~~

On vérifie que dans le cache de la repo docker, il y a bien le package docker :

~~~bash
mickael@docker:~$ apt-cache policy docker-ce
docker-ce:
  Installé : (aucun)
  Candidat : 5:19.03.13~3-0~ubuntu-focal
 Table de version :
     5:19.03.13~3-0~ubuntu-focal 500
        500 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
     5:19.03.12~3-0~ubuntu-focal 500
        500 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
     5:19.03.11~3-0~ubuntu-focal 500
        500 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
     5:19.03.10~3-0~ubuntu-focal 500
        500 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
     5:19.03.9~3-0~ubuntu-focal 500
        500 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
~~~

On installe docker. Les dépendance __docker-ce-cli__ et __containerd.io__ sont installés à partir de __docker-ce__.

~~~bash
mickael@docker:~$ sudo apt -y install docker-ce
~~~

On vérifie que le service docker fonctionne.

~~~bash
mickael@docker:~$ sudo systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2020-09-19 17:23:38 UTC; 8s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 2719 (dockerd)
      Tasks: 12
     Memory: 38.0M
     CGroup: /system.slice/docker.service
             └─2719 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

sept. 19 17:23:37 docker.jobjects.org dockerd[2719]: time="2020-09-19T17:23:37.417556646Z" level=warning msg="Your kernel does not s>
sept. 19 17:23:37 docker.jobjects.org dockerd[2719]: time="2020-09-19T17:23:37.417561176Z" level=warning msg="Your kernel does not s>
sept. 19 17:23:37 docker.jobjects.org dockerd[2719]: time="2020-09-19T17:23:37.417565606Z" level=warning msg="Your kernel does not s>
sept. 19 17:23:37 docker.jobjects.org dockerd[2719]: time="2020-09-19T17:23:37.417704024Z" level=info msg="Loading containers: start>
sept. 19 17:23:38 docker.jobjects.org dockerd[2719]: time="2020-09-19T17:23:38.266762470Z" level=info msg="Default bridge (docker0) >
sept. 19 17:23:38 docker.jobjects.org dockerd[2719]: time="2020-09-19T17:23:38.347160097Z" level=info msg="Loading containers: done."
sept. 19 17:23:38 docker.jobjects.org dockerd[2719]: time="2020-09-19T17:23:38.380565362Z" level=info msg="Docker daemon" commit=448>
sept. 19 17:23:38 docker.jobjects.org dockerd[2719]: time="2020-09-19T17:23:38.380660888Z" level=info msg="Daemon has completed init>
sept. 19 17:23:38 docker.jobjects.org dockerd[2719]: time="2020-09-19T17:23:38.395425983Z" level=info msg="API listen on /run/docker>
sept. 19 17:23:38 docker.jobjects.org systemd[1]: Started Docker Application Container Engine.
~~~

On ajoute l'utilisateur courant. Pas la peine de le faire si on est root. Là, je suis sur Ubuntu 20.04 LTS, alors il faut le faire.

~~~bash
mickael@docker:~$ sudo usermod -aG docker ${USER}
~~~

Il faut se déloguer pour récupérer les nouveaux droits donc faire un __logout__!
On vérifie que hello-world fonctionne.

~~~bash
mickael@docker:~$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete
Digest: sha256:4cf9c47f86df71d48364001ede3a4fcd85ae80ce02ebad74156906caff5378bc
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
~~~

## Script de nétoyage docker

Voici un petit script de nétoyage de docker. Avec le temps, les versions successives des containers, car va commencer à peser lourd sur le disque pour rien.

~~~bash
mickael@docker:~$ cat ./clean-all-in-docker.sh
#!/bin/bash
# Stop all
docker stop $(docker ps -a -q)
# Delete all containers
docker rm $(docker ps -a -q)
# Delete all images
docker rmi $(docker images -q)
docker volume prune -f
docker system prune -a -f
~~~

## Installation de docker-compose

La méthode à partir des source de docker

~~~bash
mickael@docker:~$ sudo curl -L "https://github.com/docker/compose/releases/download/1.27.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
[sudo] password for mickael:
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   651  100   651    0     0   2475      0 --:--:-- --:--:-- --:--:--  2475
100 11.6M  100 11.6M    0     0  3451k      0  0:00:03  0:00:03 --:--:-- 4291k
mickael@docker:~$ sudo chmod +x /usr/local/bin/docker-compose
mickael@docker:~$ docker-compose --version
docker-compose version 1.27.3, build 4092ae5d
~~~

Pour information, AWX a besoin des librairies python de docker compose, cette méthode est obligatoire.

~~~bash
# Et aussi, car c'est important pour le déploiement, python doit avoir les librairies python de docker :
mickael@docker:~$ sudo apt install python3-pip git pwgen vim
mickael@docker:~$ sudo pip3 install requests==2.14.2
mickael@docker:~$ sudo pip3 install docker-compose==1.27.3
~~~
