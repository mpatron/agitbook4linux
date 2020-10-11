Mail : Dovecot + Postfix + rainloop + FreeIPA
===================

## Préparation de la repository

~~~bash
rpm -q kernel
yum install yum-utils
package-cleanup --oldkernels --count=2
sed -i -e "s/\]$/\]\npriority=1/g" /etc/yum.repos.d/CentOS-Base.repo
sed -i -e "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo
sed -i 's/installonly_limit=5/installonly_limit=2/g' /etc/yum.conf
~~~

## Installation des outils

~~~bash
#Centos Repo
yum -y install yum-plugin-priorities epel-release
#IPA Client
yum -y install ipa-client
#Tools
yum -y install net-tools vim lsof lynx nmap tree unzip
#Dovecot
yum -y install dovecot
#Rainloop
yum -y install httpd mod_ssl php php-mbstring php-pear php-fpm
~~~

## Configuration du client MX de FreeIPA, le serveur mail
~~~bash
ipa-client-install -U -p admin -w Passworld0
authconfig --enablemkhomedir --update
ipa dnsrecord-add jobjects.org mail --a-rec 192.168.56.119 --a-create-reverse
ipa dnsrecord-add 56.168.192.in-addr.arpa. 119 --ptr-rec=mail.jobjects.org.
ipa dnsrecord-add jobjects.org mail --a-rec 192.168.56.119
ipa dnsrecord-add jobjects.org @ --mx-rec="0 mail.jobjects.org."
~~~

## Création du service mail dans kerberos

Sur NS:
~~~bash
ipa service-add imap/mail.jobjects.org
ipa group-add mailusers --desc="Utilisateurs ayant le droit d'utiliser le mail."
ipa group-add-member mailusers --users={mpt,mfr,pvv,ymg}
~~~

## Récupération du keytab pour le service mail dovecot

Sur MX :
~~~bash
kinit admin
ipa-getkeytab -s central.jobjects.org -p imap/mail.jobjects.org -k /etc/dovecot/krb5.keytab
chown root:dovecot /etc/dovecot/krb5.keytab
chmod 640 /etc/dovecot/krb5.keytab
mkdir /mail
chmod 770 /mail
chgrp mailusers /mail
chcon -t user_home_t /mail
~~~

## Configuration des répertoires des mails, en phase 1

Dans /etc/dovecot/conf.d/10-mail.conf
>mail_location = mbox:/mail/%u/:INBOX=/var/mail/%u

Puis rédemarrage de docecot pour la prise en compte de la configuration.
>systemctl restart dovecot






## Dovecot

Modifier /etc/postfix/main.cf
~~~vim
76  myhostname = mail.jobjects.org
83  mydomain = jobjects.org
99  myorigin = $mydomain
113 inet_interfaces = all
119 inet_protocols = ipv4
164 mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
264 mynetworks = 127.0.0.0/8, 192.168.56.0/24
418 home_mailbox = Maildir/
~~~

Créer /etc/logrotate.d/dovecot
~~~vim
/var/log/dovecot*.log {
  missingok
  notifempty
  delaycompress
  sharedscripts
  postrotate
    doveadm log reopen
  endscript
}
~~~

Modifier /etc/dovecot/dovecot.conf
~~~vim
24 protocols = imap
30 listen = *
~~~

~~~bash
openssl genrsa -aes256 -out imap.jobjects.org.key.pem 4096
openssl req -new -x509 -days 3600 -key imap.jobjects.org.key.pem -out imap.jobjects.org.cert.pem -subj "/C=FR/ST=France/L=Paris/O=JObjects/OU=IT/CN=mail.jobjects.org"
# pour enlever le mots de passe
openssl rsa -in imap.jobjects.org.key.pem -out imap.jobjects.org.key.pem
~~~

Modifier /etc/dovecot/conf.d/10-auth.conf
~~~vim
100 #auth_mechanisms = plain
ajouter à la fin :
userdb {
  driver = static
  args = uid=dovecot gid=dovecot home=/var/spool/mail/%u
}
auth_mechanisms = plain login gssapi
auth_gssapi_hostname = jupiter.jobjects.org
auth_krb5_keytab = /etc/dovecot/krb5.keytab
auth_realms = jobjects.org
auth_default_realm = jobjects.org
~~~

Modifier /etc/dovecot/conf.d/10-logging.conf
ajouter à la fin :
~~~vim
log_path = /var/log/dovecot.log
auth_verbose = yes
auth_debug = yes
verbose_ssl = yes
auth_verbose_passwords = plain
mail_debug = yes
~~~

Modifier /etc/dovecot/conf.d/10-mail.conf
~~~vim
30 mail_location = maildir:~/Maildir
~~~

Modifier /etc/dovecot/conf.d/10-master.conf
~~~vim
89   unix_listener auth-userdb {
90     #mode = 0666
91     user = postfix
92     group = postfix
93   }
~~~















## Rainloop

### Sans SSl

/etc/httpd/conf.d/welcome.conf
Tout commenter puis mettre que :
~~~apache
<VirtualHost 192.168.56.119:80>
    ServerName mail.jobjects.org
    DocumentRoot "/var/www/html/rainloop"
</VirtualHost>
~~~

ou mieux creer le fichier /etc/httpd/conf.d/rainloop.conf
~~~apache
<VirtualHost 192.168.56.119:80>
  ServerName mail.jobjects.org
  DocumentRoot "/var/www/html/rainloop/"
  ServerAdmin mpt@jobjects.org
  ErrorLog "/var/log/httpd/rainloop-error_log"
  TransferLog "/var/log/httpd/rainloop-access_log"
  <Directory />
    Options +Indexes +FollowSymLinks +ExecCGI
    AllowOverride All
    Order deny,allow
    Allow from all
    Require all granted
  </Directory>
</VirtualHost>
~~~

### SSL La création des certificats

~~~bash
openssl genrsa -aes256 -out rainloop.lan.key 4096
openssl req -new -x509 -days 3600 -key rainloop.lan.key -out rainloop.lan.crt -subj "/C=FR/ST=France/L=Paris/O=JObjects/OU=IT/CN=mail.jobjects.org"
# pour enlever le mots de passe
openssl rsa -in rainloop.lan.key -out newrainloop.lan.key
sudo cp rainloop.lan.key /etc/pki/tls/private/
sudo cp rainloop.lan.crt /etc/pki/tls/certs/
sudo restorecon -RvF /etc/pki
~~~




sudo vim /etc/httpd/conf.d/rainloop-ssl.conf
~~~apache
<VirtualHost 192.168.56.119:443>
  ServerName mail.jobjects.org
  DocumentRoot "/var/www/html/rainloop/"
  ServerAdmin mpt@jobjects.org
  ErrorLog "/var/log/httpd/rainloop-ssl-error_log"
  TransferLog "/var/log/httpd/rainloop-ssl-access_log"
  SSLEngine on
  SSLCertificateFile "/etc/pki/tls/certs/rainloop.lan.crt"
  SSLCertificateKeyFile "/etc/pki/tls/private/rainloop.lan.key"
  <FilesMatch "\.(cgi|shtml|phtml|php)$">
    SSLOptions +StdEnvVars
  </FilesMatch>
  BrowserMatch "MSIE [2-5]" nokeepalive ssl-unclean-shutdown downgrade-1.0 force-response-1.0
  CustomLog "/var/log/httpd/ssl_request_log" "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"
  <Directory />
    Options +Indexes +FollowSymLinks +ExecCGI
    AllowOverride All
    Order deny,allow
    Allow from all
    Require all granted
  </Directory>
</VirtualHost>
~~~

### SE Linux

~~~bash
[root@mail rainloop]# yum install policycoreutils-python
[root@mail rainloop]# cd /var/www/html/rainloop
[root@mail rainloop]# semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/rainloop/data'
[root@mail rainloop]# restorecon -v '/var/www/html/rainloop/data'
[root@mail rainloop]# setsebool httpd_unified true
[root@mail rainloop]# setsebool httpd_can_network_connect true
[root@mail rainloop]# systemctl restart httpd
~~~



## Mutt pour les tests

~~~bash
[mpt@mail ~]$ cat ~/.muttrc
set imap_authenticators="gssapi"
set spoolfile="imaps://mpt@mail.jobjects.org:993/INBOX"
set folder="imaps://mpt@mail.jobjects.org/"
set record="=Sent"
set postponed="=Drafts"
~~~

~~~bash
[mfr@rserver ~]$ openssl s_client -crlf -connect mail.jobjects.org:465
ou
[mfr@rserver ~]$ telnet mail 25
Trying 192.168.56.110...
Connected to mail.
Escape character is '^]'.
220 jupiter.jobjects.org ESMTP Postfix
ehlo continuum.jobjects.org
250-jupiter.jobjects.org
250-PIPELINING
250-SIZE 10240000
250-VRFY
250-ETRN
250-ENHANCEDSTATUSCODES
250-8BITMIME
250 DSN
mail from:mpt@jobjects.org
250 2.1.0 Ok
rcpt to:mfr@jobjects.org
250 2.1.5 Ok
data
354 End data with <CR><LF>.<CR><LF>
ceci est un test!
.
250 2.0.0 Ok: queued as 16B0420BE4CB
quit
221 2.0.0 Bye
Connection closed by foreign host.
~~~
