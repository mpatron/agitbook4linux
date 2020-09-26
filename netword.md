# Le réseau

## Ubuntu

La configuration réseau se réalise en positionnant des fichiers yaml de configuration. En créant un par carte dans le répertoire suivant :

~~~bash
mickael@docker:~$ sudo ls -la /etc/netplan
total 16
drwxr-xr-x   2 root root 4096 sept. 25 19:49 .
drwxr-xr-x 107 root root 4096 sept. 26 10:02 ..
-rw-r--r--   1 root root  117 avril 25 09:08 00-installer-config.yaml
-rw-r--r--   1 root root  345 sept. 25 19:49 01-netcfg.yaml
~~~

Il faut écrire un fichier yaml '/etc/netplan/01-netcfg.yaml' comme ceci :

~~~conf
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s8:
     dhcp4: no
     addresses: [192.168.56.116/24]
     gateway4: 192.168.56.1    <<<<<<<====== A Supprimer pour avoir internet
     nameservers:
       addresses: [8.8.8.8,8.8.4.4]
~~~

> **_NOTE:_** Sur VirtualBox, la gateway de la carte réseau sur "private network" ne doit pas avoir de gateway. On aurait envie de mettre 192.168.56.1, mais, si c'est fait, l'accès à internet ne fonctionnera pas. Quand la gateway est possitionnée, en même une règle de routage est positionné sur de any vers 192.168.56.1. Le problème est que l'ordre de routage n'est pas bien maitrise et la carte sur private network arrive avant la carte sur NAT. Et là, il n'y a point d'internet :-(.

Appliquer la configuration qui vient d'être écrite

~~~bash
sudo netplan apply
~~~

Puis vérifier avec la configuration souhaité avec *ip a*

~~~bash
mickael@docker:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:da:e5:36 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 85089sec preferred_lft 85089sec
    inet6 fe80::a00:27ff:feda:e536/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:fa:46:e9 brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.116/24 brd 192.168.56.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fefa:46e9/64 scope link
       valid_lft forever preferred_lft forever
~~~

## Le HOSTNAME et DOMAINNAME

On vient de finir la configuration des cartes et leur adresse IP. on passe à la configuration du nom de la machine. Une machine a un nom court et un nom long, le fqdn. Le nom long devrait être l'association du nom court avec le domaine. Et c'est important sur des machines gérés par FreeIPA.

~~~bash
mickael@docker:~$ hostname -a
docker
mickael@docker:~$ hostname -f
docker.jobjects.org
~~~

Pour le paramétrer, il faut commencer par hostnamectl et mettre un nom court à la machine

~~~bash
mickael@docker:~$ sudo hostnamectl set-hostname docker
mickael@docker:~$ sudo hostnamectl
   Static hostname: docker
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 3042615e2d994a50bf8db07d73d26bad
           Boot ID: d0111e3768c9480d9f9fb37dde13fd0d
    Virtualization: oracle
  Operating System: Ubuntu 20.04.1 LTS
            Kernel: Linux 5.4.0-48-generic
      Architecture: x86-64
~~~

Le hostnamectl positionne deux valeurs (la veille et la nouvelle)
mickael@docker:~$ cat /etc/hostname
docker
mickael@docker:~$ cat /proc/sys/kernel/hostname
docker

Alors le domainname,
mickael@docker:~$ cat /etc/sysctl.d/domain-name.conf
kernel.domainname=jobjects.org

domainname
sudo reboot