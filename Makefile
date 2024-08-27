include .env
IMAGE_NAME=ynput/ayon-ash
VERSION=$(shell python -c "import ash; print(ash.__version__, end='')")

run: build
	docker run \
		-it --rm \
		--hostname worker \
		-v $(shell pwd)/ash:/ash/ash \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e AYON_API_KEY=${AYON_API_KEY} \
		-e AYON_SERVER_URL=${AYON_SERVER_URL} \
		--log-driver=syslog \
		--log-opt syslog-address=udp://localhost:514 \
		$(IMAGE_NAME):latest

check:
	sed -i "s/^version = \".*\"/version = \"$(VERSION)\"/" pyproject.toml
	poetry run black .
	poetry run ruff --fix .
	poetry run mypy .

build: check
	docker build -t $(IMAGE_NAME):latest -t $(IMAGE_NAME):$(VERSION) .

dist: build
	docker push ynput/ayon-ash:$(VERSION)
	docker push ynput/ayon-ash:latest
