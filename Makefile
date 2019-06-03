default:
	cd src && docker build \
		--target base \
		--tag humanzilla/python:latest \
		--cache-from humanzilla/python:latest .
	cd src && docker build \
		--target develop \
		--tag humanzilla/python:develop \
		--cache-from humanzilla/python:develop .

push:
	docker push humanzilla/python:latest
	docker push humanzilla/python:develop
