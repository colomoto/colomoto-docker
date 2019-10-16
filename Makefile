TAG=$(shell date +%F)
V=next
VALIDATE_ARGS=""

all:

update:
	git checkout master
	python update-n-freeze.py
	git diff Dockerfile
	git add Dockerfile
	git commit -m "upgrade tools"

validate:
	colomoto-docker -V $(V) validate.sh -- $(VALIDATE_ARGS)

next:
	git push
	git checkout next
	git rebase master
	git push
	git checkout master

tag:
	git tag $(TAG)
	git push --tags
