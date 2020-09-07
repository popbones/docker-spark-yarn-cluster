up:
	docker-compose up -d

logs:
	docker-compose logs -f

down:
	docker-compose down

build:
	docker build -t popbones/spark-hadoop-cluster -f hadoop.Dockerfile .
	docker build -t popbones/livy -f livy.Dockerfile .
