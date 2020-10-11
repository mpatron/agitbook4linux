Wildfly 10 dans un domain FreeIPA
===================

Objectif : Installer wildfly 10 dans un serveur linux sur un réseau FreeIPA
Bénéfices : Les comptes d'administration de wildfly sont directement gérés dans FreeIPA

Commencer par ajouter les groupes de wildfly dans FreeIPA
```bash
ipa group-add 'Monitor' --desc="Wildfly : a read-only role. Cannot modify any resource."
ipa group-add 'Operator' --desc="Wildfly : Monitor permissions, plus can modify runtime state, but cannot modify anything that ends up in the persistent configuration. Could, for example, restart a server."
ipa group-add 'Maintainer' --desc="Wildfly : Operator permissions, plus can modify the persistent configuration."
ipa group-add 'Deployer' --desc="Wildfly : like a Maintainer, but with permission to modify persistent configuration constrained to resources that are considered to be 'application resources'. A deployment is an application resource. The messaging server is not. Items like datasources and JMS destinations are not considered to be application resources by default, but this is configurable."
ipa group-add 'SuperUser' --desc="Wildfly : has all permissions. Equivalent to a JBoss AS 7 administrator."
ipa group-add 'Administrator' --desc="Wildfly : has all permissions except cannot read or write resources related to the administrative audit logging system."
ipa group-add 'Auditor' --desc="Wildfly : can read anything. Can only modify the resources related to the administrative audit logging system."
```
http://blog.c2b2.co.uk/2014/09/configuring-rbac-in-jboss-eap-and.html

Puis ajouter l'utilisateur wildfly
~~~bash
ipa user-add wildfly --first="Wildfly" --last="JBoss" --random > ~/user-wildfly.txt && cat ~/user-wildfly.txt
~~~

Puis ajouter l'utilisateur wildfly au groupe SuperUser
```bash
ipa group-add-member --users=wildfly SuperUser
```

Configuration du firewall
```bash
firewall-cmd --permanent --add-service={http,https}
firewall-cmd --permanent --add-port=8080/tcp --zone=public
firewall-cmd --permanent --add-port=9990/tcp --zone=public
firewall-cmd --complete-reload
firewall-cmd --list-all
```

Installation de wildfly version 10
```bash
wget http://download.jboss.org/wildfly/10.0.0.Final/wildfly-10.0.0.Final.tar.gz
tar -xvf /root/wildfly-10.0.0.Final.tar.gz -C /opt/
ln -s /opt/wildfly-10.0.0.Final /opt/wildfly
chown -RL wildfly:wildfly /opt/wildfly
mkdir /etc/wildfly
mkdir /var/run/wildfly/
chown -R wildfly:wildfly /var/run/wildfly/
cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/
cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/
cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/
chmod +x /opt/wildfly/bin/launch.sh
```

# Mise en place du lanceur
Editer /opt/wildfly/bin/launch.sh et ajouter le parametre qui permet de configurer la adresse d'écoute de l'administration (9990), ici je met toutes les adresses.
Editer le fichier /opt/wildfly/bin/launch.sh,
Ligne 10,mettre " -bmanagement=0.0.0.0 " à la fin de ligne pour donner : `$WILDFLY_HOME/bin/standalone.sh -c $2 -b $3 -bmanagement=0.0.0.0`

~~~bash
#!/bin/sh

if [ "x$WILDFLY_HOME" = "x" ]; then
    WILDFLY_HOME="/opt/wildfly"
fi

if [[ "$1" == "domain" ]]; then
    $WILDFLY_HOME/bin/domain.sh -c $2 -b $3
else
    $WILDFLY_HOME/bin/standalone.sh -c $2 -b $3 -bmanagement=0.0.0.0
fi
# Installation du service
systemctl start wildfly.service
systemctl enable wildfly.service
~~~
Sources :
* [CLI](https://access.redhat.com/documentation/en-US/JBoss_Enterprise_Application_Platform/6.2/html/Security_Guide/Configure_Group_Role_Assignment_with_jboss-cli.sh.html)
* [JBoss](https://access.redhat.com/documentation/en/red-hat-jboss-enterprise-application-platform/7.0/paged/how-to-configure-server-security/chapter-4-securing-users-of-the-server-and-its-management-interfaces)
* [LDAP](https://wildscribe.github.io/Wildfly/10.0.0.Final/core-service/management/security-realm/authorization/ldap/index.html)

# Configuration de wildfly pour le connecter à LDAP de FreeIPA
Il faut d'abors l'éteindre
`# systemctl stop wildfly.service`
Puis dans /opt/wildfly/standalone/configuration/standalone.xml mettre
~~~xml
        <security-realms>
            <security-realm name="ManagementRealm">
				<authentication>
				  <ldap connection="LocalLdap" base-dn="cn=users,cn=accounts,dc=jobjects,dc=org">
					<username-filter attribute="uid"/>
				  </ldap>
				</authentication>
				<authorization>
				  <ldap connection="LocalLdap">
					<username-to-dn force="true">
					  <username-filter base-dn="cn=users,cn=accounts,dc=jobjects,dc=org" recursive="false" attribute="uid" user-dn-attribute="dn" />
					</username-to-dn>
					<group-search group-name="SIMPLE" iterative="true" group-dn-attribute="dn" group-name-attribute="cn">
					  <principal-to-group group-attribute="memberOf" />
					</group-search>
				  </ldap>
				</authorization>
            </security-realm>
            <security-realm name="ApplicationRealm">
				<authentication>
				  <ldap connection="LocalLdap" base-dn="cn=users,cn=accounts,dc=jobjects,dc=org">
					<username-filter attribute="uid"/>
				  </ldap>
				</authentication>
				<authorization>
				  <ldap connection="LocalLdap">
					<username-to-dn force="true">
					  <username-filter base-dn="cn=users,cn=accounts,dc=jobjects,dc=org" recursive="false" attribute="uid" user-dn-attribute="dn" />
					</username-to-dn>
					<group-search group-name="SIMPLE" iterative="true" group-dn-attribute="dn" group-name-attribute="cn">
					  <principal-to-group group-attribute="memberOf" />
					</group-search>
				  </ldap>
				</authorization>
            </security-realm>
        </security-realms>
        <outbound-connections>
            <ldap name="LocalLdap" url="ldap://jupiter.jobjects.org:389" search-dn="uid=admin,cn=users,cn=accounts,dc=jobjects,dc=org" search-credential="PasswordO!">
               <properties>
                   <property name="com.sun.jndi.ldap.connect.timeout" value="1000" />
                   <property name="com.sun.jndi.ldap.read.timeout" value="2000" />
               </properties>
            </ldap>
        </outbound-connections>
~~~


/core-service=management/access=authorization/role-mapping=SuperUser/include=wildfly:add(name=wildfly,realm=ManagementRealm,type=USER)
~~~bash
        <access-control provider="rbac">
            <role-mapping>
               <role name="Monitor">
                   <include>
                       <group alias="group-standard-devs" name="developers"/>
                   </include>
               </role>
               <role name="Operator">
                   <include>
                       <group alias="group-standard-devs" name="developers"/>
                   </include>
               </role>
               <role name="Maintainer">
                   <include>
                       <group alias="group-standard-devs" name="developers"/>
                   </include>
               </role>
                <role name="Deployer">
                   <include>
                       <group alias="group-lead-devs" name="lead-developers"/>
                   </include>
               </role>
                <role name="SuperUser">
                    <include>
                        <user name="$local"/>
                        <user alias="wildfly" realm="ManagementRealm" name="wildfly"/>
                        <group alias="admins" name="admins"/>
                    </include>
                </role>			   
             </role-mapping>
        </access-control>
~~~

https://access.redhat.com/documentation/en/red-hat-jboss-enterprise-application-platform/7.0/paged/how-to-configure-identity-management/chapter-3-securing-the-management-interfaces-with-ldap

CLI to Enable RBAC
~~~bash
/core-service=management/access=authorization:write-attribute(name=provider, value=rbac)
~~~
CLI to Disable RBAC
~~~bash
/core-service=management/access=authorization:write-attribute(name=provider, value=simple)
~~~
CLI to read RBAC
~~~bash
/core-service=management/access=authorization:read-attribute(name=provider)
~~~

Creation de la configuration de connection au serveur LDAP :
~~~bash
/core-service=management/ldap-connection=ldap-connection/:add(search-credential=Password0!,url=ldaps://central.jobjects.org:636,search-dn="uid=admin,cn=users,cn=accounts,dc=jobjects,dc=org")
:reload
/core-service=management/security-realm=ManagementRealm/authentication=properties:remove()
/core-service=management/security-realm=ManagementRealm/authentication=ldap:add(connection="ldap-connection", base-dn="cn=users,cn=accounts,dc=jobjects,dc=org",username-attribute="uid",user-dn="dn")
:reload
~~~

Commencer par ajouter les groupes de wildfly dans FreeIPA
~~~bash
ipa group-add 'wfmonitor' --desc="Wildfly : Users of the Monitor role have the fewest permissions and can only read the current configuration and state of the server. This role is intended for users who need to track and report on the performance of the server. Monitors cannot modify server configuration, nor can they access sensitive data or operations."
ipa group-add 'wfoperator' --desc="Wildfly : The Operator role extends the Monitor role by adding the ability to modify the runtime state of the server. This means that Operators can reload and shutdown the server as well as pause and resume JMS destinations. The Operator role is ideal for users who are responsible for the physical or virtual hosts of the application server so they can ensure that servers can be shutdown and restarted correctly when need be. Operators cannot modify server configuration or access sensitive data or operations."
ipa group-add 'wfmaintainer' --desc="Wildfly : The Maintainer role has access to view and modify the runtime state and all configurations except sensitive data and operations. The Maintainer role is the general purpose role that does not have access to sensitive data and operation. The Maintainer role allows users to be granted almost complete access to administer the server without giving those users access to passwords and other sensitive information. Maintainers cannot access sensitive data or operations."
ipa group-add 'wfdeployer' --desc="Wildfly : The Deployer role has the same permissions as the Monitor, but it can modify the configuration and state for deployments and any other resource type enabled as an application resource."
ipa group-add 'wfsuperuser' --desc="Wildfly : The SuperUser role does not have any restrictions, and it has complete access to all resources and operations of the server, including the audit logging system. If RBAC is disabled, all management users have permissions equivalent to the SuperUser role."
ipa group-add 'wfadministrator' --desc="Wildfly : The Administrator role has unrestricted access to all resources and operations on the server except the audit logging system. The Administrator role has access to sensitive data and operations. This role can also configure the access control system. The Administrator role is only required when handling sensitive data or configuring users and roles. Administrators cannot access the audit logging system and cannot change themselves to the Auditor or SuperUser role."
ipa group-add 'wfauditor' --desc="Wildfly : The Auditor role has all the permissions of the Monitor role and can also view (but not modify) sensitive data. It has full access to the audit logging system. The Auditor role is the only role besides SuperUser that can access the audit logging system. Auditors cannot modify sensitive data or resources. Only read access is permitted."
~~~

Dans jboss_cli.sh, il faut mapper les groupes kerberos avec les roles JEE.
~~~bash
/core-service=management/access=authorization/role-mapping=SuperUser/include=group-wfsuperuser:add(name=wfsuperuser, type=GROUP)
/core-service=management/access=authorization/role-mapping=Monitor:add()
/core-service=management/access=authorization/role-mapping=Monitor/include=group-wfmonitor:add(name=wfmonitor, type=GROUP)
/core-service=management/access=authorization/role-mapping=Operator:add()
/core-service=management/access=authorization/role-mapping=Operator/include=group-wfoperator:add(name=wfoperator, type=GROUP)
/core-service=management/access=authorization/role-mapping=Maintainer:add()
/core-service=management/access=authorization/role-mapping=Maintainer/include=group-wfmaintainer:add(name=wfmaintainer, type=GROUP)
/core-service=management/access=authorization/role-mapping=Administrator:add()
/core-service=management/access=authorization/role-mapping=Administrator/include=group-wfadministrator:add(name=wfadministrator, type=GROUP)
/core-service=management/access=authorization/role-mapping=Deployer:add()
/core-service=management/access=authorization/role-mapping=Deployer/include=group-wfdeployer:add(name=wfdeployer, type=GROUP)
/core-service=management/access=authorization/role-mapping=Auditor:add()
/core-service=management/access=authorization/role-mapping=Auditor/include=group-wfauditor:add(name=wfauditor, type=GROUP)
~~~

Vérification
>/core-service=management/access=authorization/role-mapping=Auditor:read-resource(recursive=true)

~~~bash
clear-batch
batch
/core-service=management/security-realm=ManagementRealm/authorization=properties:remove()
/core-service=management/security-realm=ManagementRealm/authorization=ldap:add(connection="ldap-connection")
/core-service=management/security-realm=ManagementRealm/authorization=ldap/username-to-dn=username-filter:add(base-dn="cn=users,cn=accounts,dc=jobjects,dc=org", recursive="false", attribute="uid", user-dn-attribute="dn", force="true")
/core-service=management/security-realm=ManagementRealm/authorization=ldap/group-search=principal-to-group:add(group-attribute="memberOf",iterative=true,group-dn-attribute="dn", group-name="SIMPLE",group-name-attribute="cn")
run-batch
:reload
~~~

Vérification
~~~bash
/subsystem=logging/root-logger=ROOT:read-attribute(name=level)
/subsystem=logging/root-logger=ROOT:write-attribute(name=level, value=ALL)
~~~

Et pour les applications, c'est pareil :
~~~bash
/core-service=management/security-realm=ApplicationRealm/authentication=properties:remove()
:reload
/core-service=management/security-realm=ApplicationRealm/authentication=ldap:add(connection="ldap-connection", base-dn="cn=users,cn=accounts,dc=jobjects,dc=org",username-attribute="uid",user-dn="dn")
:reload
clear-batch
batch
/core-service=management/security-realm=ApplicationRealm/authorization=properties:remove()
/core-service=management/security-realm=ApplicationRealm/authorization=ldap:add(connection="ldap-connection")
/core-service=management/security-realm=ApplicationRealm/authorization=ldap/username-to-dn=username-filter:add(base-dn="cn=users,cn=accounts,dc=jobjects,dc=org", recursive="false", attribute="uid", user-dn-attribute="dn", force="true")
/core-service=management/security-realm=ApplicationRealm/authorization=ldap/group-search=principal-to-group:add(group-attribute="memberOf",iterative=true,group-dn-attribute="dn", group-name="SIMPLE",group-name-attribute="cn")
run-batch
:reload
~~~


Vérification
<div class="alert alert-info">

>/core-service=management/security-realm=ApplicationRealm:read-resource(recursive=true)

</div>

Mise en place du cache
~~~bash
# Un des deux peut être actif à la fois, c'est en seconde
/core-service=management/security-realm=ApplicationRealm/authentication=ldap/cache=by-access-time:add(eviction-time=300, cache-failures=true, max-cache-size=100)
/core-service=management/security-realm=ApplicationRealm/authentication=ldap/cache=by-search-time:add(eviction-time=300, cache-failures=true, max-cache-size=100)
# Verifier la présence d'un utilisateur
/core-service=management/security-realm=ApplicationRealm/authentication=ldap/cache=by-access-time:contains(name=TestUserOne)
# netoyer le cache
/core-service=management/security-realm=ApplicationRealm/authentication=ldap/cache=by-access-time:flush-cache()
# Lire les infos du cache
/core-service=management/security-realm=ApplicationRealm/authentication=ldap/cache=by-access-time:read-resource(include-runtime=true)
# Détruire le cache
/core-service=management/security-realm=ApplicationRealm/authentication=ldap/cache=by-access-time:remove()
~~~

Red_Hat_JBoss_Enterprise_Application_Platform-7.0-How_to_Configure_Identity_Management-en-US.pdf
pour CHAPTER 4. CONFIGURING A SECURITY DOMAIN TO USE LDAP
https://www.jtips.info/index.php?title=WildFly/cli
