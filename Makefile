run:
	docker run -d -p 5050:5050 --rm --name fias --volume ${PWD}:/app fias_api
stop:
	docker stop fias