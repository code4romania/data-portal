build-all:
	docker-compose build --pull

build:
	docker-compose build --pull ckan

clean:
	docker-compose down -t 60
	docker system prune -f
