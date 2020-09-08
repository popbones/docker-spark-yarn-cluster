# Hadoop with Spark on Yarn in Docker

This repo contains a simple local setup of Hadoop cluster with Spark running on Yarn. An Apache Livy is also included.

This is for Spark newbies to get handson with Hadoop/Spark/Yran locally.

* Hadoop Version: 2.7.3
* Spark Verson: 2.4.5
* Livy Version: 0.7.0

This repo uses git submodules. So after clone please remember to run

```
git submodule init && git submodule update
```

## Start Up

```
make up logs
```

This will build all the images and start all the services in the background and start tailing the log.

* Hadoop UI: http://localhost:8088

* HDFS UI: http://localhost:50070

* Spark UI: http://localhost:8080

* Livy UI: http://localhost:8998

## Use

You can test everything is working by submit a hello world Spark application via Livy.

You can do this with `make livy-test`.

Beyond that you can just use it as a normal Spark on YARN.

- spark-shell : `spark-shell --master yarn --deploy-mode client`
- spark : `spark-submit --master yarn --deploy-mode client or cluster --num-executors 2 --executor-memory 4G --executor-cores 4 --class org.apache.spark.examples.SparkPi $SPARK_HOME/examples/jars/spark-examples_2.11-2.4.1.jar`

## Shutdown

```
make down
```
