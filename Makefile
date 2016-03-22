

all: libmruby.so

mruby-orig:
	git clone . mruby-orig && cd mruby-orig && git checkout 2b0baec32a6bfe72a18199cc864c43d07575b14b

build: mruby-orig
	cd mruby-orig && ./minirake
	cp -r mruby-orig/build ./
	cp mruby-orig/mrbgems/mruby-compiler/core/codegen.c mrbgems/mruby-compiler/core/

libmruby.so: $(wildcard **.c **.h) build
	gcc -g -Iinclude -Isrc $(wildcard src/*.c build/host-debug/mrblib/*.c build/host-debug/mrbgems/*.c build/host-debug/mrbgems/*/*.c mrbgems/*/src/*.c) build/host-debug/mrbgems/mruby-compiler/core/y.tab.c mrbgems/mruby-compiler/core/codegen.c -Imrbgems/mruby-compiler/core -fPIC -shared -o libmruby.so -DMRB_ENABLE_DEBUG_HOOK

.PHONY: clean
clean:
	rm -f libmruby.so
	rm -rf build
	rm -rf mruby-orig
