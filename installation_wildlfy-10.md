Installation de wildfly 10 sous CentOS 7
===================

## Téléchargement et Installation de wildfly
Wildfly n'est pas encore disponible sous yum

~~~bash
wget http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.tar.gz
tar -xvf /root/wildfly-10.1.0.Final.tar.gz -C /opt/
ln -s /opt/wildfly-10.1.0.Final /opt/wildfly
chown -RL wildfly:wildfly /opt/wildfly
mkdir /etc/wildfly
mkdir /var/run/wildfly/
chown -R wildfly:wildfly /var/run/wildfly/
cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/
cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/
cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/
chmod +x /opt/wildfly/bin/launch.sh
sed -i 's#$WILDFLY_HOME/bin/standalone.sh -c $2 -b $3#$WILDFLY_HOME/bin/standalone.sh -c $2 -b $3 -bmanagement=0.0.0.0#g' /opt/wildfly/bin/launch.sh
systemctl start wildfly.service
systemctl enable wildfly.service
~~~


~~~bash
# CLI to Enable RBAC
/core-service=management/access=authorization:write-attribute(name=provider, value=rbac)
# CLI to Disable RBAC
/core-service=management/access=authorization:write-attribute(name=provider, value=simple)
# CLI to read RBAC
/core-service=management/access=authorization:read-attribute(name=provider)

# Creation de la configuration de connection au serveur LDAP :
/core-service=management/ldap-connection=ldap-connection/:add(search-credential=mypassword,url=ldaps://central.jobjects.org:636,search-dn="uid=admin,cn=users,cn=accounts,dc=jobjects,dc=org")
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

/core-service=management/access=authorization/role-mapping=Auditor:read-resource(recursive=true)

clear-batch
batch
/core-service=management/security-realm=ManagementRealm/authorization=properties:remove()
/core-service=management/security-realm=ManagementRealm/authorization=ldap:add(connection="ldap-connection")
/core-service=management/security-realm=ManagementRealm/authorization=ldap/username-to-dn=username-filter:add(base-dn="cn=users,cn=accounts,dc=jobjects,dc=org", recursive="false", attribute="uid", user-dn-attribute="dn", force="true")
/core-service=management/security-realm=ManagementRealm/authorization=ldap/group-search=principal-to-group:add(group-attribute="memberOf",iterative=true,group-dn-attribute="dn", group-name="SIMPLE",group-name-attribute="cn")
run-batch
:reload

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

/core-service=management/security-realm=ApplicationRealm:read-resource(recursive=true)
~~~

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
