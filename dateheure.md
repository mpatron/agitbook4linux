
# Ubuntu : /etc/chrony/chrony.conf  RedHat : /etc/chrony.conf
# mettre ces serveurs : 
server 0.fr.pool.ntp.org iburst
server 1.fr.pool.ntp.org iburst
server 2.fr.pool.ntp.org iburst
server 3.fr.pool.ntp.org iburst
# On redémarre le service de temps
sudo timedatectl set-timezone Europe/Paris
sudo systemctl restart chronyd
sudo chronyc sources && sudo chronyc -a makestep && sudo date && ntpstat
sudo systemctl restart chronyd && sudo watch chronyc tracking
ou
ntpdate -s 0.fr.pool.ntp.org
