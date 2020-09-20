# Le réseau

La configuration réseau se passe dans le répertoire suivant :
/etc/netplan/

Il faut écrire un fichier contenant '/etc/netplan/01-netcfg.yaml' ceci :

~~~conf
# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
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

Appliquer la configuration qui vient d'être écrite

~~~bash
sudo netplan apply
Puis vérifier avec
ip a
~~~

~~~bash
sudo hostnamectl set-hostname docker.jobjects.org
sudo reboot
~~~
