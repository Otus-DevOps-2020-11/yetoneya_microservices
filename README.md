# yetoneya_microservices

yetoneya microservices repository

## homework-12

установлен Docker, docker-machine, docker-compose

    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    #sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

    #curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    #sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
 
    sudo apt update
    apt-cache policy docker-ce
    sudo apt install docker-ce
    sudo systemctl status docker

    sudo usermod -aG docker ${USER}
    su - ${USER}

    sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
    
    wget https://github.com/docker/machine/releases/download/v0.15.0/docker-machine-$(uname -s)-$(uname -m)
    mv docker-machine-Linux-x86_64 docker-machine
    chmod +x docker-machine
    sudo mv docker-machine /usr/local/bin
    docker-machine version 

docker version && docker info && docker-compose --version && docker-machine --version - проверка, что все нормально

запущены контейнеры hello-word и ubuntu

выполнены команды docker ps, docker ps -a, docker images

docker run каждый раз запускает новый контейнер:

    elena@debian:~$ docker run -it ubuntu:18.04 /bin/bash
    root@968e88f9b2a8:/# echo 'Hello world!' > /tmp/file
    root@968e88f9b2a8:/# exit
    exit
    elena@debian:~$ docker run -it ubuntu:18.04 /bin/bash
    root@6a680e2c2c3b:/# cat /tmp/file
    cat: /tmp/file: No such file or directory
    root@6a680e2c2c3b:/# exit

запущен остановленный контейнер с /tmp/file, подсоединен терминал

    elena@debian:~$ docker start 968e88f9b2a8
    968e88f9b2a8
    elena@debian:~$ docker attach 968e88f9b2a8
    root@968e88f9b2a8:/# cat /tmp/file
    Hello world!
    root@968e88f9b2a8:/#

запущен новый процесс внутри контейнера

    elena@debian:~$ docker start 968e88f9b2a8
    968e88f9b2a8
    elena@debian:~$ docker exec -it 968e88f9b2a8 bash
    root@968e88f9b2a8:/#

создан image из запущенного контейнера. результат записан в docker-1.log

### задание со *

сравнение docker inspect <container_id> и docker inspect <image_id>

остановлены запущенные контейнеры и затем удалены все контейнеры и образы

### yc

создан compute instance на yc

    yc compute instance create \
    --folder-name catalog \
    --name vm \
    --zone ru-central1-a \
    --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
    --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
    --ssh-key ~/.ssh/id_rsa.pub

    one_to_one_nat:
      address: 84.252.131.39

создан docker-machine

    docker-machine create \
      --driver generic \
      --generic-ip-address=84.201.172.194 \
      --generic-ssh-user yc-user \
      --generic-ssh-key ~/.ssh/id_rsa \
    docker-host

    elena@debian:~$ docker-machine ls
    NAME             ACTIVE   DRIVER    STATE     URL                            SWARM   DOCKER     ERRORS

    docker-host         -     generic   Running   tcp://84.201.172.194:2376              v20.10.3 

    eval $(docker-machine env docker-host)

демо из лекции:

    yc-user@docker-host:~$ ps auxf
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root         2  0.0  0.0      0     0 ?        S    18:51   0:00 [kthreadd]
    root         4  0.0  0.0      0     0 ?        I<   18:51   0:00  \_ [kworker/0:0H]
    .....

    yc-user@docker-host:~$ df -h
    Filesystem      Size  Used Avail Use% Mounted on
    udev            975M     0  975M   0% /dev
    tmpfs           200M  4.0M  196M   2% /run 
    .....

    yc-user@docker-host:~$ ip -c -br a
    lo               UNKNOWN        127.0.0.1/8 ::1/128
    eth0             UP             10.130.0.34/24 fe80::d20d:12ff:fe30:2b7b/64
    docker0          DOWN           172.17.0.1/16 

### Dockerfile

создан Dockerfile и файлы конфигурации

создан образ

    docker build -t reddit:latest .

запусk:

    elena@debian:~$ docker run --name reddit -d --network=host reddit:latest
    421ced171624459be47bdebd6a397f52cdf46813aee618cf1b46d485cd16591c

проверка:

[![](https://github.com/yetoneya/pictures/blob/main/homework12-01.png)

### Docker Hub

загружен образ на Docker Hub

    docker login
    docker tag reddit:latest yetoneya/otus-reddit:1.0
    docker push yetoneya/otus-reddit:1.0

в консоли vm yc:

    docker run --name reddit -d -p 9292:9292 yetoneya/otus-reddit:1.0

проверка:

[![](https://github.com/yetoneya/pictures/blob/main/homework12-02.png)

выполнены команды для проверки

    yc-user@docker-h:~$ docker logs reddit -f
    about to fork child process, waiting until server is ready for connections.
    forked process: 10
    child process started successfully, parent exiting
    Puma starting in single mode...
    ....
    ....
    .... 
        docker exec -it reddit bash
    ps aux
    killall5 1
    docker start reddit
    docker stop reddit && docker rm reddit
    docker run --name reddit --rm -it /otus-reddit:1.0 bash
    ps aux
    exit

    docker inspect /otus-reddit:1.0
    docker run --name reddit -d -p 9292:9292 /otus-reddit:1.0

    docker exec -it reddit bash
    mkdir /test1234
    touch /test1234/testfile
    rmdir /opt
    exit
    docker diff reddit
    docker stop reddit && docker rm reddit
    docker run --name reddit --rm -it /otus-reddit:1.0 bash
    ls /

выполнены команды

    docker kill $(docker ps -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q)
    docker rmi -f $(docker images -q)
    docker network rm reddit
    docker ps -a
    docker images -a

### задание со *

директории ansible, terrafform, packer в docker-monolith/infra

запуск:

в директории infra/packer:

    packer validate -var-file=variables.json ./ubuntu-docker.json
    packer build -var-file=variables.json ./ubuntu-docker.json

в директории infra/terraform:

id образа -> image_id

    terraform init
    terraform plan
    terraform apply

в директории infra/ansible:

    ./import-inventory
    ansible-playbook playbooks/start_reddit.yml

## homework-13

приложение разделено на несколько компонентов, оптимизированы Dockerfiles(не уверена, что оптимизированы)

    docker pull mongo:latest
    docker build -t post:1.0 ./post-py
    docker build -t comment:1.0 ./comment
    docker build -t ui:1.0 ./ui
    docker images -a
    docker network create reddit
    docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
    docker run -d --network=reddit --network-alias=post post:1.0
    docker run -d --network=reddit --network-alias=comment comment:1.0
    docker run -d --network=reddit -p 9292:9292 ui:1.0

проверка

[![](https://github.com/yetoneya/pictures/blob/main/homework13-01.png)

    docker login
    docker tag post:latestyetoneya/otus-post:1.0
    docker push yetoneya/otus-post:1.0
    docker tag comment:latest yetoneya/otus-comment:1.0
    docker push yetoneya/otus-comment:1.0
    docker tag ui:latest yetoneya/otus-ui:1.0
    docker push yetoneya/otus-ui:1.0

    ssh yc-user@<ip>

    yc-user@docker-h:~$<ip>
    docker network create reddit
    docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
    docker run -d --network=reddit --network-alias=post yetoneya/otus-post:1.0
    docker run -d --network=reddit --network-alias=comment yetoneya/otus-comment:1.0
    docker run -d --network=reddit -p 9292:9292 yetoneya/otus-ui:1.0

проверка

[![](https://github.com/yetoneya/pictures/blob/main/homework13-02.png)

### задание со * 

запуск контейнеров с другими сетевыми алиасами:

остановили контейнеры

    docker kill $(docker ps -q)

    docker run -d --network=reddit --network-alias=post_db --netwodocker-machine ssh docker-hostrk-alias=comment_db mongo:latest
    docker run -d --network=reddit --network-alias=post-new post:latest
    docker run -d --network=reddit --network-alias=comment-new comment:latest
    docker run -d --network=reddit -p 9292:9292  -e POST_SERVICE_HOST=post-new  -e COMMENT_SERVICE_HOST=comment-new ui:latest

    docker kill $(docker ps -q)

изменен Dockerfile в директории ui, пересобрали

    docker build -t ui:2.0 ./ui

    REPOSITORY   TAG            IMAGE ID       CREATED          SIZE
    ui           2.0            071ac2d151da   36 seconds ago   458MB
    ui           1.0            e9c90cdb77ea   2 hours ago      771MB

### задание со * 

создан образ на основе Alpine Linux

    docker build -t ui:3.0 ./ui

    REPOSITORY   TAG            IMAGE ID       CREATED          SIZE
    ui           3.0            4a0c918b6be8   14 seconds ago   203MB
    ui           2.0            071ac2d151da   21 minutes ago   458MB
    ui           1.0            e9c90cdb77ea   2 hours ago      771M

    docker build -t ui:4.0 ./ui

    REPOSITORY   TAG            IMAGE ID       CREATED          SIZE
    ui           4.0            4a553482d620   59 seconds ago   52.8MB
    ui           3.0            4a0c918b6be8   11 minutes ago   203MB
    ui           2.0            071ac2d151da   32 minutes ago   458MB
    ui           1.0            e9c90cdb77ea   2 hours ago      771MB


    docker kill $(docker ps -q)

    docker volume create reddit_db
    docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
    docker run -d --network=reddit --network-alias=post post:1.0
    docker run -d --network=reddit --network-alias=comment comment:1.0
    docker run -d --network=reddit -p 9292:9292 ui:2.0

остановили контейнеры, затем перезапустили

[![](https://github.com/yetoneya/pictures/blob/main/homework13-03.png)

    docker kill $(docker ps -q)

## homework-14

### networks

Запустили контейнер с использованием none-драйвера:

    eval $(docker-machine env docker-h)
    docker-machine ssh docker-h

yc-user@docker-h:~$

    docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig
    lo

Запустили контейнер с использованием host-драйвера:

    docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig 

br-42b4029a01d0 docker0 eth0 lo

yc-user@docker-h:~$ docker run --network host -d nginx

    Unable to find image 'nginx:latest' locally
    latest: Pulling from library/nginx
    a076a628af6f: Pull complete
    0732ab25fa22: Pull complete
    d7f36f6fe38f: Pull complete
    f72584a26f32: Pull complete
    7125e4df9063: Pull complete
    Digest: sha256:10b8cc432d56da8b61b070f4c7d2543a9ed17c2b23010b43af434fd40e2ca4aa
    Status: Downloaded newer image for nginx:latest
    d0e1eaaa0110e4eb8e80e37f37ad3530dbf6d2dba63ee9b8dd8d01441c0e5bcc

yc-user@docker-h:~$ docker run --network host -d nginx

    fed41d28ff36384dfac4fb4b7bfb0a5878a7823e5dc0abd4a647dca6a01774fc

во второй раз использовался первый контейнер, сам первый контейнер был остановлен

    CONTAINER ID   IMAGE     COMMAND                  CREATED             STATUS                     PORTS    NAMES
    d0e1eaaa0110   nginx     "/docker-entrypoint.…"   About an hour ago   Up About an hour                    confident_lichterman

    CONTAINER ID   IMAGE     COMMAND                  CREATED             STATUS                     PORTS     NAMES
    fed41d28ff36   nginx     "/docker-entrypoint.…"   2 minutes ago       Exited (1) 2 minutes ago             heuristic_beaver
    d0e1eaaa0110   nginx     "/docker-entrypoint.…"   About an hour ago   Up About an hour                     confident_lichterman

net-namespaces

    sudo ln -s /var/run/docker/netns /var/run/netns

    docker network rm reddit 
    docker network create reddit --driver none

    docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
    docker run -d --network=reddit --network-alias=post yetoneya/otus-post:1.0
    docker run -d --network=reddit --network-alias=comment yetoneya/otus-comment:1.0
    docker run -d --network=reddit -p 9292:9292 yetoneya/otus-ui:1.0

    sudo ip netns

    .........

    docker network rm reddit
    docker network create reddit --driver host

    .......

Запустили с использованием bridge-сети

    docker network rm reddit
    docker network create reddit --driver bridge

    docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
    docker run -d --network=reddit --network-alias=post yetoneya/otus-post:1.0
    docker run -d --network=reddit --network-alias=comment yetoneya/otus-comment:1.0
    docker run -d --network=reddit -p 9292:9292 yetoneya/otus-ui:1.0

Запустили в двух bridge-сетях

    docker kill $(docker ps -q)
    (--driver bridge === default)
    docker network create back_net  --driver bridge --subnet=10.0.2.0/24
    docker network create front_net  --driver bridge --subnet=10.0.1.0/24


    docker run -d --network=front_net -p 9292:9292 --name ui yetoneya/otus-ui:1.0
    docker run -d --network=back_net --name comment --network-alias=comment yetoneya/otus-comment:1.0
    docker run -d --network=back_net --name post --network-alias=post yetoneya/otus-post:1.0
    docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest
    docker network connect front_net post
    docker network connect front_net comment

[![](https://github.com/yetoneya/pictures/blob/main/homework14-01.png)

информация о сетевых интерфейсах

    sudo apt-get update && sudo apt-get install bridge-utils
    docker network ls

    NETWORK ID     NAME        DRIVER    SCOPE
    1d250d9fb93e   back_net    bridge    local
    c0aa6abbb7ff   bridge      bridge    local
    789b5b146877   front_net   bridge    local
    68de7983e752   host        host      local
    22cbd7374693   none        null      local
    814c8ac296d4   reddit      bridge    local

    ifconfig | grep br

    br-1d250d9fb93e: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
    ....

    yc-user@docker-h:~$ brctl show br-1d250d9fb93e
    bridge name             bridge id               STP enabled     interfaces
    br-1d250d9fb93e         8000.02427804d003       no              veth2a0135a
                                                                    veth88f69c8
                                                                    vethbb067c3
    sudo iptables -nL -t nat
    ps ax | grep docker-proxy

### docker-compose

#### локально

    docker-compose build
    docker-compose up -d
    docker ps

        Name                  Command             State           Ports         
    ----------------------------------------------------------------------------
    src_comment_1   puma                          Up                            
    src_post_1      python3 post_app.py           Up                            
    src_post_db_1   docker-entrypoint.sh mongod   Up      27017/tcp             
    src_ui_1        puma                          Up      0.0.0.0:9292->9292/tcp

[![](https://github.com/yetoneya/pictures/blob/main/homework14-02.png)

#### yc

создан файл docker-compose-yc.yml

    eval $(docker-machine env docker-h)
    docker-machine ssh docker-h
    sudo apt update
    sudo apt install python3-pip
    sudo pip3 install docker-compose


    docker-machine ssh docker-h docker kill $(docker ps -q)
    docker-machine ssh docker-h docker rm $(docker ps -a -q)
    docker-machine ssh docker-h docker rmi -f $(docker images -q)
    docker-machine scp -r docker-compose-yc.sample docker-h:docker-compose.yml

    docker-machine ssh docker-h docker-compose up -d
    docker-machine ssh docker-h docker-compose ps

          Name                    Command             State           Ports         
    --------------------------------------------------------------------------------
    yc-user_comment_1   puma                          Up                            
    yc-user_post_1      python3 post_app.py           Up                            
    yc-user_post_db_1   docker-entrypoint.sh mongod   Up      27017/tcp             
    yc-user_ui_1        puma                          Up      0.0.0.0:9292->9292/tcp

[![](https://github.com/yetoneya/pictures/blob/main/homework14-03.png)

#### базовое имя проекта

имя сущности: директория, в которой находится docker-compose.yml, tag

базовое имя проекта можно задать в файле .env:

    COMPOSE_PROJECT_NAME=SOMEPROJECTNAME

### задание *

docker-compose.override.yml

## homework-15

созданв vm на yc, установлены docker, docker-compose

установлен и запущен gitlab_ci, выполнены пп. 2.1 - 6.2 дз

    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"


    sudo apt update
    apt-cache policy docker-ce
    sudo apt install docker-ce
    sudo systemctl status docker

    sudo usermod -aG docker ${USER}
    

    sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

    sudo mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs
    cd /srv/gitlab
    sudo nano docker-compose.yml
    

    web:
      image: 'gitlab/gitlab-ce:latest'
      restart: always
      hostname: 'gitlab.example.com'
      environment:
        GITLAB_OMNIBUS_CONFIG: |
          external_url 'http://84.252.130.104'
      ports:
        - '80:80'
        - '443:443'
        - '2222:22'
      volumes:
        - '/srv/gitlab/config:/etc/gitlab'
        - '/srv/gitlab/logs:/var/log/gitlab'
        - '/srv/gitlab/data:/var/opt/gitlab'

    sudo docker-compose up -d

    git remote rm gitlab
    git remote add gitlab http://84.252.130.104/homework/example.git
    git push gitlab gitlab-ci-1


    sudo docker run -d --name gitlab-runner --restart always -v /srv/gitlabrunner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest

    sudo docker exec -it gitlab-runner gitlab-runner register \
    --url http://84.252.130.104/ \
    --non-interactive \
    --locked=false \
    --name DockerRunner \
    --executor docker \
    --docker-image alpine:latest \
    --registration-token vtvsPsywhGbxyVwmX2Mf \
    --tag-list "linux,xenial,ubuntu,docker" \
    --run-untagged

#### задание со *

директория gitlab_ci/infra, RAM - вручную на YC

#### окружения

добавлены окружения, проверена работоспособность

## homework-16

основы работы  с prometheus:

[![](https://github.com/yetoneya/pictures/blob/main/homework16-01.png)


[![](https://github.com/yetoneya/pictures/blob/main/homework16-02.png)

## homework-15



https://hub.docker.com/repository/docker/yetoneya/ui
https://hub.docker.com/repository/docker/yetoneya/post
https://hub.docker.com/repository/docker/yetoneya/comment
https://hub.docker.com/repository/docker/yetoneya/prometheus

#### задания *

выполнены задания cо *. 


## homework-17

основы работы с cAdvisor

основы работы с grafana

основы работы с alertmanager


## homework-18

выполнены задания дз логгирование Docker контейнеров

## homework-19

выполнены команды:

ansible-playbook initial.yml - запуск команд sudo без ввода пароля

sudo curl https://docs.projectcalico.org/manifests/calico.yaml -O на каждой ноде

ansible-playbook cube-dependencies.yml - установка зависимостей kubernetes
ansible-playbook master.yml - настройка главного узла
ansible-playbook workers.yml - настройка рабочих узлов

kubectl apply -f calico.yaml - на master

задание со * - директории terraform, ansible

## homework-20

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

validate:

echo "$(<kubectl.sha256) kubectl" | sha256sum --check 

install:

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

check:

kubectl version --client