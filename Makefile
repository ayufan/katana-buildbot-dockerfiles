all:
	# make build
	# make run

FORCE:

build: FORCE
	docker build -t katana .

run: FORCE
	-docker rm -f katana
	docker run -d --name=katana -P katana
	docker port katana 8010
