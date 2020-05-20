build:
	docker-compose build hal

run:
	docker-compose up -d hal

down:
	docker-compose down

exec:
	docker-compose exec hal /bin/bash

clean:
	rm -rf .hal
	mkdir .hal
	chmod -R 777 .hal 