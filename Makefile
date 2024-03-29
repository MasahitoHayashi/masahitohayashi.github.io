# targets that aren't filenames
.PHONY: all clean deploy build serve

all: build

PANDOC = pandoc
CFLAGS = -c css/bootstrap.min.css --shift-heading-level-by 2 -f latex -t html

_includes/publication-list.html: _data/hayashi-publication.tex
	$(PANDOC) $< $(CFLAGS) -o $@

build: _includes/publication-list.html
	jekyll build

# You can configure these at the shell, e.g.:
# SERVE_PORT=5001 make serve
SERVE_HOST ?= 127.0.0.1
SERVE_PORT ?= 5000

serve: _includes/publication-list.html
	jekyll serve --port $(SERVE_PORT) --host $(SERVE_HOST)

clean:
	$(RM) -r _site _includes/publication-list.html

DEPLOY_HOST ?= yourwebpage.com
DEPLOY_PATH ?= www/
RSYNC := rsync --compress --recursive --checksum --itemize-changes --delete -e ssh

deploy: clean build
	$(RSYNC) _site/ $(DEPLOY_HOST):$(DEPLOY_PATH)
