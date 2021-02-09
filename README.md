# yetoneya_microservices

yetoneya microservices repository

## homework-12

установлен Docker, docker-machine, docker-compose

docker version && docker info && docker-compose --version  && docker-machine --version  - проверка, что все нормально

запущены контейнеры hello-word и ubuntu

выполнены команды  docker ps, docker ps -a, docker images 

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

сравнение docker inspect <container_id> и  docker inspect <image_id>

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
    docker ps -a
    docker images -a

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
    docker tag post:latest yetoneya/otus-post:1.0
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

    docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
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

