https://computingforgeeks.com/install-and-configure-ansible-awx-on-centos/

mickael@docker:~$ git clone https://github.com/ansible/awx.git
Cloning into 'awx'...
remote: Enumerating objects: 9, done.
remote: Counting objects: 100% (9/9), done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 253666 (delta 2), reused 0 (delta 0), pack-reused 253657
Receiving objects: 100% (253666/253666), 230.27 MiB | 8.33 MiB/s, done.
Resolving deltas: 100% (195893/195893), done.
mickael@docker:~$ cd awx
mickael@docker:~/awx$ git fetch --all --tags
Fetching origin
mickael@docker:~/awx$ git checkout tags/14.1.0 -b 14.1.0-branch
Switched to a new branch '14.1.0-branch'
mickael@docker:~/awx$ git clone https://github.com/ansible/awx-logos.git
Cloning into 'awx-logos'...
remote: Enumerating objects: 59, done.
remote: Total 59 (delta 0), reused 0 (delta 0), pack-reused 59
Unpacking objects: 100% (59/59), 457.95 KiB | 1.42 MiB/s, done.

mickael@docker:~$ sudo apt -y install ansible
mickael@docker:~$ sudo apt install python3-pip git pwgen vim
mickael@docker:~$ sudo pip3 install requests==2.14.2
mickael@docker:~$ pwgen -N 1 -s 30
FWH3hTloJalKqdhXzX3xtiR1U0yaPm

mickael@docker:~/awx$ cd installer/
mickael@docker:~/awx/installer$ vim ~/awx/installer/inventory
# Mettre le bon chemin de python, official et la clef random
localhost ansible_connection=local ansible_python_interpreter="/usr/bin/python3"
awx_official=true
secret_key=FWH3hTloJalKqdhXzX3xtiR1U0yaPm
awx_alternate_dns_servers="192.168.56.121"

mickael@docker:~/awx/installer$ ansible-playbook -i inventory install.yml -vv
Sur une autre console :
mickael@docker:~$docker logs -f awx_postgres

grep -v -e '^[[:space:]]*$' ~/awx/installer/inventory | grep -v '^#'
sed -e "/^[[:space:]]*$/d" -e "/^#/d" /etc/chrony.conf
https://www.tutorialspoint.com/unix/unix-regular-expressions.htm

sudo apt -y update && sudo apt -y dist-upgrade

~~~text
---
hosts:
  - host: idm1.jobjects.org
    groups: [ipaservers]
  - host: docker.jobjects.org
    groups: [ipaservers]
  - host: node1.jobjects.org
    groups: [ipaservers, moncluster]
  - host: node2.jobjects.org
    groups: [ipaservers, moncluster]
  - host: node3.jobjects.org
    groups: [ipaservers, moncluster]
~~~

~~~bash
ansible@docker:~/monprojet$ cat hosts
## set up ssh user name and path to python3 ##
[all:vars]
ansible_user='ansible'
ansible_become=yes
ansible_become_method=sudo
ansible_python_interpreter='/usr/bin/env python3'

##########################
## our aws server names
###########################
[servers]
node1.jobjects.org
node2.jobjects.org
node3.jobjects.org

ansible@docker:~/monprojet$ ansible-playbook -i hosts update.yml -K
~~~
