## Run Hbase Cluster within Docker Containers



### 3 Nodes Hbase Cluster


##### 1. clone github repository

```
git clone https://github.com/amineel/Docker-Hbase-cluster/
```


##### 2. build the image 

```
./buil-image.sh

```


##### 3. create hadoop network

```
sudo docker network create --driver=bridge hadoop
```

##### 4. start container

```
cd hadoop-cluster-docker
sudo ./start-container.sh
```

**output:**

```
start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 
```
- start 3 containers with 1 master and 2 slaves
- you will get into the /root directory of hadoop-master container

```


