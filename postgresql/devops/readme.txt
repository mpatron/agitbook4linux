Readme

    .env - a key-value file for defined variables in other files
    init.sh - an initialization script
    docker-compose.yml - main Compose file
    register-runner.sh - a script to register gitlab-runner container in GitLab server

Then, follow the below steps (commands should be executed in DevOps directory):

    chmod +x init.sh && sudo ./init.sh
    docker-compose up -d
    Config GitLab Server
    Register GitLab Runner
    Config Nexus

Source : http://www.devocative.org/article/tech/docker03