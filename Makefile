up: testdata/HelloWorld.jar
	docker-compose up -d

logs:
	docker-compose logs -f

down:
	docker-compose down

build:
	docker build -t popbones/spark-hadoop-cluster -f hadoop.Dockerfile .
	docker build -t popbones/livy -f livy.Dockerfile .

testdata/spark-hello-world/target/scala-2.11/HelloWorld-assembly-0.1.0.jar:
	git submodule init && git submodule update
	bash -c 'cd testdata/spark-hello-world && sbt assembly'

testdata/HelloWorld.jar: testdata/spark-hello-world/target/scala-2.11/HelloWorld-assembly-0.1.0.jar
	cp testdata/spark-hello-world/target/scala-2.11/HelloWorld-assembly-0.1.0.jar testdata/HelloWorld.jar

test-livy:
	curl --request POST \
		--url http://localhost:8998/batches \
  		--header 'content-type: application/json' \
		--header 'user-agent: vscode-restclient' \
		--data '{"className": "HelloWorld","file":"local:/testdata/HelloWorld.jar"}'
