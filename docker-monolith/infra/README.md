### packer

packer validate -var-file=variables.json ./ubuntu-docker.json
packer build -var-file=variables.json ./ubuntu-docker.json

### terraform

terraform init
terraform plan
terraform apply

### image

docker build -t reddit:1.0 .
docker images -a
export USERNAME=yetoneya
docker login
docker tag reddit:1.0 ${USERNAME}/otus-reddit:1.0
docker push ${USERNAME}/otus-reddit:1.0

ssh ubuntu@<ip_address>

sudo passwd ubuntu
...
sudo usermod -aG docker ${USER}
su - ${USER}

export USERNAME=yetoneya
docker login
docker run --name reddit -d -p 9292:9292 ${USERNAME}/otus-reddit:1.0


