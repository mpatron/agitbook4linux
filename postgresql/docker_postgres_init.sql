CREATE USER gitlab WITH PASSWORD 'Welcome1!' CREATEDB;
CREATE DATABASE gitlab
    WITH 
    OWNER = gitlab
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
CREATE USER awx WITH PASSWORD 'Welcome1!' CREATEDB;
CREATE DATABASE awx
    WITH 
    OWNER = awx
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
CREATE USER sonarqube WITH PASSWORD 'Welcome1!' CREATEDB;
CREATE DATABASE sonarqube
    WITH 
    OWNER = sonarqube
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

