TAG=local

lbuild:
	docker build -t colomoto/colomoto-docker:local .
hbuild:
	IMAGE=colomoto/colomoto-docker:$(TAG) ./hooks/build
validate:
	docker run --rm colomoto/colomoto-docker:$(TAG) env validate.sh
