Installation de Java 8 sous CentOS 7
===================

## Developpement Java Oracle
Installation du JDK ainsi que les librairies contenant les derniers (2014 quand même) de cryptographie.
~~~bash
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.rpm"
yum install jdk-8u121-linux-x64.rpm
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip"
jar -xf jce_policy-8.zip
for file in /usr/java/jdk1.8.0_121/jre/lib/security/*.jar
do
    mv -i "${file}" "${file}-`date +%Y-%m-%d`-old"
done
cp -i UnlimitedJCEPolicyJDK8/*.jar /usr/java/jdk1.8.0_121/jre/lib/security/
rm -rf UnlimitedJCEPolicyJDK8
~~~

## Developpement avec Java open-source implementation
Le package java-1.8.0-openjdk n'est pas complet pour faire du développement. il faut Utiliser le package java-1.8.0-openjdk-devel.
> yum install java-1.8.0-openjdk-devel


## Avant, faire un état des lieux avec alternatives :
Il est possible d'avoir plusieur version de Java. Mais il faut définir une jvm par défaut. alternatives sert à cela. Certain logiciel comme Cloudera permet de spécifier la jvm utilisé, dans ce cas il faudra prendre la valeur /usr/java/default. Pour des logiciels comme wildfly, la valeur par defaut d'alternatives sera utilisée. En premier lieu, il faut regarder ce qui est disponible :
~~~bash
alternatives --display java
~~~

~~~bash
#alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_121/bin/java 2
#alternatives --config java
#alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_121/bin/jar 2
#alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_121/bin/javac 2
#alternatives --set jar /usr/java/jdk1.8.0_121/bin/jar
#alternatives --set javac /usr/java/jdk1.8.0_121/bin/javac
java -version
~~~

## Variable d'environnement
Les scripts de lancement de programme java utilise parfois les variables d'environnement JAVA_HOME et JRE_HOME. Créons le fichier /etc/profile.d/java.sh
~~~bash
cat <<EOF > /etc/profile.d/java.sh
export JAVA_HOME=/usr/java/default
export JRE_HOME=/usr/java/default/jre
##Utiliser alternatives c'est mieux, sinon il faut décommenter
# export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/jre/bin
EOF
~~~
