FROM ubuntu:16.04

USER root

RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y openssh-server default-jdk wget scala
RUN  apt-get -y update
RUN  apt-get -y install zip 
RUN  apt-get -y install vim
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV SPARK_VERSION=2.4.5

RUN ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -P "" \
    && cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

RUN wget -O /hadoop.tar.gz http://archive.apache.org/dist/hadoop/core/hadoop-2.7.3/hadoop-2.7.3.tar.gz \
        && tar xfz hadoop.tar.gz \
        && mv /hadoop-2.7.3 /usr/local/hadoop \
        && rm /hadoop.tar.gz

RUN wget -O /spark.tar.gz https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz
RUN tar xfz spark.tar.gz
RUN mv /spark-$SPARK_VERSION-bin-hadoop2.7 /usr/local/spark
RUN rm /spark.tar.gz


ENV HADOOP_HOME=/usr/local/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME:sbin

RUN mkdir -p $HADOOP_HOME/hdfs/namenode \
        && mkdir -p $HADOOP_HOME/hdfs/datanode

COPY config/ /tmp/
RUN mv /tmp/ssh/ssh_config $HOME/.ssh/config \
    && mv /tmp/hadoop/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh \
    && mv /tmp/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml \
    && mv /tmp/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && mv /tmp/hadoop/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml.template \
    && cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml \
    && mv /tmp/hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml \
    && cp /tmp/hadoop/slaves $HADOOP_HOME/etc/hadoop/slaves \
    && mv /tmp/hadoop/slaves $SPARK_HOME/conf/slaves \
    && mv /tmp/spark/spark-env.sh $SPARK_HOME/conf/spark-env.sh \
    && mv /tmp/spark/log4j.properties $SPARK_HOME/conf/log4j.properties \
    && mv /tmp/spark/spark.defaults.conf $SPARK_HOME/conf/spark.defaults.conf

ADD scripts/spark-services.sh $HADOOP_HOME/spark-services.sh

RUN chmod 744 -R $HADOOP_HOME

RUN $HADOOP_HOME/bin/hdfs namenode -format

EXPOSE 50010 50020 50070 50075 50090 8020 9000
EXPOSE 10020 19888
EXPOSE 8030 8031 8032 8033 8040 8042 8088
EXPOSE 49707 2122 7001 7002 7003 7004 7005 7006 7007 8888 9000

ENTRYPOINT service ssh start; cd $SPARK_HOME; bash


