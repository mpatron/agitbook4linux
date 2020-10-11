# Les descripteurs J2EE-7

Lorsque vous développez une application Java EE 7 assurez - vous d'utiliser les espaces de noms J2EE 7 sinon vous ferez du J2EE 6.

## CDI 1.1

Le descripteur de déploiement CDI ( de beans.xml ) est obligatoire, même si il reste totalement vide. Notez que dans le CDI 1.1 ( JSR 346 ) , il y a un nouveau  mode de _bean-discovery-mode_ élément qui informe le CDI de découvrir tous les beans, aucun, ou seulement les annotés.

> beans.xml
> ~~~xml
<beans xmlns="http://xmlns.jcp.org/xml/ns/javaee"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/beans_1_1.xsd"
       version="1.1" bean-discovery-mode="all">
</beans>
> ~~~

## Bean Validation 1.1

Validation Bean 1.1 ( JSR 349 ) est la seule spécification qui n'a pas mis à jour l'espace de noms et utilise encore http://jboss.org/xml/ns . Notez que Bean Validation et spécifications CDI sont gérés par RedHat

> validation.xml
> ~~~xml
<validation-config
        xmlns="http://jboss.org/xml/ns/javax/validation/configuration"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://jboss.org/xml/ns/javax/validation/configuration validation-configuration-1.1.xsd"
        version="1.1">
</validation-config>
> ~~~

> constraints.xml
> ~~~xml
<constraint-mappings
        xmlns="http://jboss.org/xml/ns/javax/validation/mapping"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://jboss.org/xml/ns/javax/validation/mapping validation-mapping-1.1.xsd"
        version="1.1">
</constraint-mappings>
> ~~~

## JPA 2.1

Seul descripteur de déploiement obligatoire en Java EE 7, JPA 2.1 ( JSR 338 )  le fichier _persistence.xml_  introduit de nouvelles propriétés pour la génération de schéma.

> persistence.xml
> ~~~xml
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/persistence http://xmlns.jcp.org/xml/ns/persistence/persistence_2_1.xsd"
             version="2.1">
</persistence>
> ~~~

> mapping.xml
> ~~~xml
<entity-mappings xmlns="http://xmlns.jcp.org/xml/ns/persistence/orm"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/persistence/orm http://xmlns.jcp.org/xml/ns/persistence/orm_2_1.xsd"
                 version="2.1">
</entity-mappings>
> ~~~

## EJB 3.2

Pas beaucoup de changements dans EJB 3.2 ( JSR 342 ) par rapport à 3,1. Ainsi , le ejb-jar.xml suit doucement ces mises à jour mineures.

> ejb-jar.xml
> ~~~xml
<ejb-jar xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/ejb-jar_3_2.xsd"
         version="3.2">
</ejb-jar>
> ~~~

## Servlet 3.1

Comme la précédente version, le web.xml dans Servlet 3.1 ( JSR 340 ) est facultative, ainsi que la web-fragment.xml.

> web.xml
> ~~~xml
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">
</web-app>
> ~~~


## JSF 2.2

Dans JSF 2.2 ( JSR 344 ) les faces-config.xml est toujours en option. Notez que les espaces de noms des bibliothèques de composants ont également été mis à jour.

> faces-config.xml
> ~~~xml
<faces-config xmlns="http://xmlns.jcp.org/xml/ns/javaee"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-facesconfig_2_2.xsd"
              version="2.2">
</faces-config>
> ~~~

> aJSFPage.xhtml
> ~~~html
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="http://xmlns.jcp.org/jsf/html"
      xmlns:ui="http://xmlns.jcp.org/jsf/facelets">
</html>
> ~~~

## JAX-WS 2.2

Le paysage WS- * est défini dans plusieurs spécifications (JAX-WS 2.2a avec JSR 224, Web Services 1.4 avec JSR 109 et les Web Services Metadata 2.1 avec JSR 181 ). Le descripteur webservices.xml de déploiement a été mis à jour avec le nouvel espace de noms.

> webservices.xml
> ~~~xml
<webservices xmlns="http://xmlns.jcp.org/xml/ns/javaee"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/javaee_web_services_1_4.xsd"
             version="1.4">
</webservices>
> ~~~

_Source : https://antoniogoncalves.org/2013/06/04/java-ee-7-deployment-descriptors/_
