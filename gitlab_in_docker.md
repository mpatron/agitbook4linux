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
    --dns 192.168.56.121 --dns 192.168.1.1 \
    --name gitlab \
    --restart always \
    --volume ~/gitlab/config:/etc/gitlab \
    --volume ~/gitlab/logs:/var/log/gitlab \
    --volume ~/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
~~~

~~~bash
mickael@docker:~/gitlab/config$ cat ldap_settings.yml
main:
  label: 'FreeIPA'
  host: 'idm1.jobjects.org'
  port: 389
  uid: 'uid'
  method: 'tls'
  bind_dn: 'uid=ansible,cn=users,cn=accounts,dc=jobjects,dc=org'
  password: 'Welcome1!'
  base: 'cn=users,cn=accounts,dc=jobjects,dc=org'
  user_filter: '(&(objectclass=inetUser)(|(memberOf=cn=developpeurs,cn=groups,cn=accounts,dc=jobjects,dc=org)))'
  group_base: 'cn=groups,cn=accounts,dc=jobjects,dc=org'
  admin_group: 'admins'
  block_auto_created_users: false
  verify_certificates: false
mickael@docker:~/gitlab/config$ sudo cat gitlab.rb | grep ldap_settings.yml
gitlab_rails['ldap_servers'] = YAML.load_file('/etc/gitlab/ldap_settings.yml')
~~~

> Attention à la ligne avec les dns, c'est important pour la résolution sur internet et freeipa.

ssh://git@docker.jobjects.org:2222/ansible/monprojet

Rapidos :-)

## Arrêt

~~~bash
sudo docker stop gitlab
sudo docker rm gitlab
~~~

## Suivre les logs

~~~bash
sudo docker logs gitlab -f
~~~

## problèmes

sudo docker exec -it gitlab /bin/bash
sudo gitlab-rake gitlab:ldap:check
sudo docker exec -it gitlab editor /etc/gitlab/gitlab.rb

docker run busybox ping -c 1 idm1.jobjects.org

mickael@docker:~$ docker run busybox ping -c 1 idm1.jobjects.org
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
df8698476c65: Pull complete
Digest: sha256:d366a4665ab44f0648d7a00ae3fae139d55e32f9712c67accd604bb55df9d05a
Status: Downloaded newer image for busybox:latest
ping: bad address 'idm1.jobjects.org'
mickael@docker:~$ docker run busybox nslookup google.com
Server:         192.168.1.1
Address:        192.168.1.1:53

Non-authoritative answer:
Name:   google.com
Address: 216.58.204.110

*** Can't find google.com: No answer

mickael@docker:~$