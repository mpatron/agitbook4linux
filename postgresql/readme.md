# Readme

création du reseau virtuel dans docker

~~~bash
docker network create mynetwork
~~~

Avec firefox aller sur
http://http://docker.jobjects.org:16543

Se connecter avec postgresql@gmail.com / Welcome1!

Puis configurer sur
Host: postgres:5432
Login: postgres
Password: Welcome1!

http://pgadmin.docker.jobjects.org
http://docker.jobjects.org:8080/dashboard


https://www.pgadmin.org/docs/pgadmin4/development/import_export_servers.html
python /pgadmin4/setup.py --dump-servers /tmp/toto.txt --user postgresql@gmail.com

mickael@docker:~/postgres$ docker-compose ps
       Name                      Command              State                                Ports
------------------------------------------------------------------------------------------------------------------------------
postgres_pgadmin_1    /entrypoint.sh                  Up      443/tcp, 0.0.0.0:16543->80/tcp
postgres_postgres_1   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp
traefik               /entrypoint.sh traefik          Up      0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp, 0.0.0.0:8080->8080/tcp
mickael@docker:~/postgres$ docker exec -it postgres_pgadmin_1 /bin/bash
OCI runtime exec failed: exec failed: container_linux.go:349: starting container process caused "exec: \"/bin/bash\": stat /bin/bash: no such file or directory": unknown
mickael@docker:~/postgres$ docker exec -it postgres_pgadmin_1 /bin/sh
docker exec -it postgres_pgadmin_1

docker-compose exec pgadmin python /pgadmin4/setup.py --load-servers /mnt/data/pgadmin-conf.json --user postgresql@gmail.com
docker-compose exec pgadmin python /pgadmin4/setup.py --load-servers /mnt/data/pgadmin-conf.json --user postgresql@gmail.com


https://www.pgadmin.org/docs/pgadmin4/development/container_deployment.html