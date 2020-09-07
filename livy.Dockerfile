# Base image Java SE 1.8 JDK
FROM openjdk:8-jdk

# Set Hadoop and Spark environment variables
ENV SPARK_VERSION 2.4.5
ENV LIVY_VERSION 0.7.0
ENV HADOOP_VERSION 2.7

WORKDIR /usr/local

# Download and unbox Spark + Hadoop binaries
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz && \
        tar zxvf spark-$SPARK_VERSION-bin-hadoop2.7.tgz --owner root --group root --no-same-owner && \
        rm spark-$SPARK_VERSION-bin-hadoop2.7.tgz
# Rename Spark folder
RUN ln -s spark-$SPARK_VERSION-bin-hadoop2.7 /usr/local/spark

ENV SPARK_HOME /usr/local/spark
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info

RUN wget http://apache.mirror.amaze.com.au/incubator/livy/$LIVY_VERSION-incubating/apache-livy-$LIVY_VERSION-incubating-bin.zip

RUN unzip apache-livy-$LIVY_VERSION-incubating-bin.zip && \
    rm apache-livy-$LIVY_VERSION-incubating-bin.zip
RUN ln -s apache-livy-$LIVY_VERSION-incubating-bin /usr/local/livy

# Copy the local config file to the container
#COPY ./livy.conf /src/livy/apache-livy-$LIVY_VERSION-incubating-bin/conf/

WORKDIR /usr/local/livy

# Set the Livy logs folder and start the server
SHELL ["/bin/bash", "-c"]
RUN mkdir -p /usr/local/livy/logs
CMD ["/usr/local/livy/bin/livy-server"]
