SOURCES := $(wildcard *.moon) $(wildcard **/*.moon)
LUAOUT := $(SOURCES:.moon=.lua)

.PHONY: all run build example

all: run

build: $(LUAOUT)

%.lua: %.moon
	moonc $<

run: build
	luajit init.lua

example: 
	gcc example.c -o redshift_example