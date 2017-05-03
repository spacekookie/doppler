SOURCES := $(wildcard *.moon) $(wildcard **/*.moon)
LUAOUT := $(SOURCES:.moon=.lua)

.PHONY: all run build example clean

all: run

build: $(LUAOUT)

clean: 
	rm -vfr *.lua
	rm -vfr **/*.lua

%.lua: %.moon
	moonc $<

run: build
	luajit init.lua

example: 
	gcc example.c -o redshift_example