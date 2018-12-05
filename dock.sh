#! /bin/bash
li=$(uname -s)
li2="${li,,}"

u1=$(cat /etc/*-release | grep ubuntu)
f1=$(cat /etc/*-release | grep fedora)
c1=$(cat /etc/*-release | grep centos)
s1=$(cat /etc/*-release | grep suse)


if [ ! -z "$u1" ]
then 
	mi=$(lsb_release -cs)
	mi2="${mi,,}"
	ji=$(cat /etc/*-release | grep DISTRIB_ID | awk '{split($0,a,"=");print a[2]}')
	ki="${ji,,}"

	if [ "$ki" == "ubuntu" ]
	then
   	echo "IT IS UBUNTU"
   	cm1="apt-get"
   	cm2="apt-key"
	fi

	sudo $cm1 update
	sudo $cm1 install -yqq apt-transport-https ca-certificates
	sudo $cm2 adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

	if [ -f "/etc/apt/sources.list.d/docker.list" ]
	then
        	echo "docker.list found\n"
	else
        echo "Creating docker.list file in /etc/apt/sources.list.d"
        sudo touch /etc/apt/sources.list.d/docker.list
	sudo chmod 777 /etc/apt/sources.list.d/docker.list
        #sudo echo "deb https://apt.dockerproject.org/repo ubuntu-yakkety main" >> /etc/apt/sources.list.d/docker.list
	sudo echo "deb https://download.docker.com/$li2/$ki $mi2 stable" >> /etc/apt/sources.list.d/docker.list
	#sudo echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu/dists $(lsb_release -cs) stable" >> /etc/apt/sources.list.d/docker.list
	fi
	sudo chmod 777 /etc/apt/sources.list.d/docker.list

	sudo $cm1 update
	sudo $cm1  install -yqq docker-ce --allow-unauthenticated

#sudo apt-get upgrade -yqq docker-engine
fi


if [ ! -z "$f1" ]
then
        ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"=");print a[2]}')
        ki="${ji,,}"
        sudo dnf -y install dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/$li2/$ki/docker-ce.repo
        sudo dnf -y install docker-ce

fi #end of fedora


<<<<<<< HEAD

if [ ! -z "$c1" ]
then
	echo "it is a centos"
        ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"\"");print a[2]}')
        ki="${ji,,}"
	sudo yum install -y yum-utils device-mapper-persistent-data lvm2
	sudo yum-config-manager --add-repo https://download.docker.com/$li2/$ki/docker-ce.repo
        sudo yum -y install docker-ce
        cm1="yum -y"
fi #end of centos

=======
>>>>>>> c59661fd72b4344949fb67b5e52705f5463607c0
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo $cm1 update
docker version
