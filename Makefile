TAG=$(shell date +%F)

all:

update:
	git checkout master
	python update-n-freeze.py
	git diff Dockerfile
	git add Dockerfile
	git commit -m "upgrade tools"

next:
	git push
	git checkout next
	git rebase master
	git push
	git checkout master

tag:
	git tag $(TAG)
	git push --tags
