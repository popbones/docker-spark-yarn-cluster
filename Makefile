up:
	docker-compose up -d

logs:
	docker-compose logs -f

down:
	docker-compose down

build:
	docker build -t pierrekieffer/spark-hadoop-cluster .
