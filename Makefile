OUT_DIR=bin

all: build

build:
	@echo "Building skull in $(shell pwd)"
	@mkdir -p $(OUT_DIR)
	@crystal build -o $(OUT_DIR)/skull src/skull.cr

install: build
	mkdir -p $(PREFIX)/bin
	cp ./bin/skull $(PREFIX)/bin

run:
	$(OUT_DIR)/skull

clean_all:
	rm -rf  $(OUT_DIR) .crystal .shards lib docs tmp *.dwarf *.tmp

release:
	@echo "you should execute: crelease x.x.x"
