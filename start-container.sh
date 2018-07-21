#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
	        -p 16010:16010 \
                -p 8080:8080 \
	 	--privileged \
                --name hadoop-master \
                --hostname hadoop-master \
	 	-v /home/ec2-user/hadoop-cluster-docker/3PP:/root/3PP \
                amine:1.0 &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
			--privileged \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	               amine:1.0 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash
