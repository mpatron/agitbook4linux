# Quelque commandes sed, grep et find

## Supppresion de commentaire dans un fichier de configuration

~~~bash
sed -e "/^[[:space:]]*$/d" -e "/^#/d" /etc/chrony.conf
~~~

~~~bash
find . -type f -name *.java -exec sed -i '/catch*}//p' {}+

sed -n '/catch/,/}/p' $MYFILE | grep throw
find . -type f -name *.java -exec sed -n '/catch/,/}/p' {} \;  | grep throw

# Nombre de class Java
$ find . -type f -name *.java | wc -l
18216
# Nombre de catch
$ find . -type f -name *.java -exec grep catch  {} \; | wc -l
16926
# Nombre de throw
$ find . -type f -name *.java -exec sed -n '/catch/,/}/p' {} \;  | grep throw | wc -l
3856
# Nombre de catch sans throw
# 16926-3856=13070 (77%)
~~~bash
