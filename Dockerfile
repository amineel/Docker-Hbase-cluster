FROM ubuntu:14.04

MAINTAINER Amine EL AJI <amineelaji@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server openjdk-7-jdk wget

# install 3PP sofrtwares
RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.2/hadoop-2.7.2.tar.gz  && \
    tar -xzvf hadoop-2.7.2.tar.gz && \
    mv hadoop-2.7.2 /usr/local/hadoop && \
    rm hadoop-2.7.2.tar.gz
	
RUN wget  https://archive.apache.org/dist/hbase/1.2.5/hbase-1.2.5-bin.tar.gz   && \
    tar -xzvf hbase-1.2.5-bin.tar.gz && \
	mv hbase-1.2.5 /usr/local/hbase && \
    rm hbase-1.2.5-bin.tar.gz

	
RUN  wget archive.apache.org/dist/drill/drill-1.6.0/apache-drill-1.6.0.tar.gz  && \
	tar -xzvf apache-drill-1.6.0.tar.gz && \
	mv apache-drill-1.6.0 /usr/local/drill && \
    rm apache-drill-1.6.0.tar.gz
	
# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop
ENV HBASE_HOME=/usr/local/hbase 
ENV DRILL_HOME=/usr/local/drill
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/user/local/hbase/bin:/user/local/drill/bin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/hbase-site.xml  $HBASE_HOME/conf/hbase-site.xml && \
    mv /tmp/hbase-env.sh  $HBASE_HOME/conf/hbase-env.sh && \
    mv /tmp/regionservers $HBASE_HOME/conf/regionservers && \
    mv /tmp/drill-override.conf  $DRILL_HOME/conf/drill-override.conf 
	
RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]
