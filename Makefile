PROJECT=joommfutil
IPYNBPATH=docs/ipynb/*.ipynb
CODECOVTOKEN=54e51b25-3a19-438f-a491-55826e6da789
PYTHON?=python3

test: test-coverage #test-ipynb

test-all:
	$(PYTHON) -m pytest

test-ipynb:
	$(PYTHON) -m pytest --nbval $(IPYNBPATH)

test-coverage:
	$(PYTHON) -m pytest --cov=$(PROJECT) --cov-config .coveragerc

upload-coverage: SHELL:=/bin/bash
upload-coverage:
	bash <(curl -s https://codecov.io/bash) -t $(CODECOVTOKEN)

travis-build: test-coverage upload-coverage

test-docker:
	docker build -t dockertestimage .
	docker run -ti -d --name testcontainer dockertestimage
	docker exec testcontainer $(PYTHON) -m pytest
	#docker exec testcontainer $(PYTHON) -m pytest --nbval $(IPYNBPATH)
	docker stop testcontainer
	docker rm testcontainer

build-dists:
	rm -rf dist/
	$(PYTHON) setup.py sdist
	$(PYTHON) setup.py bdist_wheel

release: build-dists
	twine upload dist/*
