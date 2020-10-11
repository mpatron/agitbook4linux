journald et auditd
===================

===================
!!  Journald     !!
===================

Voir les erreurs
journalctl -p err

Voir entre deux dates
journalctl --since "2015-01-10" --until "2015-01-11 03:00"
Voir depuis hier
journalctl --since yesterday
voir depuis le boot
journalctl -b

Liste des boots du serveur:
journalctl --list-boots

Mode debug comme un tail -f
journalctl -f

Voir la taille utilisé
journalctl --disk-usage

Validation de l'intégriter
journalctl --verify

vim /etc/systemd/journald.conf
[Journal]
Storage=persistent
SystemMaxUse=200M
SystemMaxFileSize=50M

sudo vim /etc/rsyslog.conf
  9 $ModLoad imuxsock # provides support for local system logging (e.g. via logger command)
 10 $OmitLocalLoggin off # <<=== Ajouter la ligne pour rsyslog et le journal communique
 11 $ModLoad imjournal # provides access to the systemd journal

 /etc/rsyslog.d/listen.conf
 $SystemLogSocketName /run/systemd/journal/syslog

systemctl restart rsyslog.service
systemctl restart systemd-journald.service

Source :
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/s1-interaction_of_rsyslog_and_journal.html
https://wiki.manjaro.org/index.php?title=Limit_the_size_of_.log_files_%26_the_journal


===================
!!     Audit     !!
===================
/etc/audit/auditd.conf
num_logs = 10 ou 5
max_log_file = 30 ou 8
max_log_file_action = ROTATE

[root@jupiter ~]# yum install audit
[root@jupiter ~]# systemctl status auditd
# lists all currently loaded Audit rules
[root@jupiter ~]# auditctl -l
[root@jupiter ~]# cp /etc/audit/audit.rules /etc/audit/audit.rules_backup
[root@jupiter ~]# cp /usr/share/doc/audit-`auditctl -v | awk '{print $3}'`/stig.rules /etc/audit/audit.rules
[root@jupiter ~]# systemctl status auditd
[root@jupiter ~]# ausearch --start today --loginuid 602400001 --raw | aureport -f --summary
#chargement des règles en mémoire (non-persistant)
[root@jupiter ~]# auditctl -R /usr/share/doc/audit-`auditctl -v | awk '{print $3}'`/stig.rules
#chargement des règles au boot (persistant)
[root@jupiter ~]# ln -s /usr/share/doc/audit-`auditctl -v | awk '{print $3}'`/stig.rules /etc/audit/rules.d/stig.rules
[root@jupiter ~]# shutdown -r now

======== ATTENTION =======
==== Si audit > 2.6.5 ====
ln -s /usr/share/doc/audit-`auditctl -v | awk '{print $3}'`/rules/30-stig.rules /etc/audit/rules.d/30-stig.rules
mv /etc/audit/rules.d/audit.rules /etc/audit/rules.d/00-audit.rules
auditctl -R /etc/audit/rules.d/30-stig.rules
auditctl -R /etc/audit/rules.d/00-audit.rules
auditctl -l
shutdown -r now
==========================
~~~bash
# To generate a report for logged events in the past three days excluding the current example day, use the following command:
[root@jupiter ~]# aureport --start 04/08/2013 00:00:00 --end 04/11/2013 00:00:00
# To generate a report of all executable file events, use the following command:
[root@jupiter ~]# aureport -x
# To generate a summary of the executable file event report above, use the following command:
[root@jupiter ~]# aureport -x --summary
# To generate a summary report of failed events for all users, use the following command:
[root@jupiter ~]# aureport -u --failed --summary -i
# To generate a summary report of all failed login attempts per each system user, use the following command:
[root@jupiter ~]# aureport --login --summary -i
# To generate a report from an ausearch query that searches all file access events for user 500, use the following command:
[root@jupiter ~]# ausearch --start today --loginuid 500 --raw | aureport -f --summary
# To generate a report of all Audit files that are queried and the time range of events they include, use the following command:
[root@jupiter ~]# aureport -t
~~~

Source :
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/sec-Creating_Audit_Reports.html


beeline -u "jdbc:hive2://bda1node04.hebergement.fr:10000/begonia;principal=hive/bda1node04.hebergement.fr@SOFTBDA.CORP;hive.server2.proxy.user=mpt"
