CC ?= gcc
AR ?= ar
PWD := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OUT := $(PWD)build
OUT_STATIC := $(OUT)/static
OUT_SHARED := $(OUT)/shared

all: hashmap hashmap_static hashmap_shared

hashmap: hashmap.c
	mkdir -p $(OUT_STATIC) $(OUT_SHARED)
	$(CC) -c -fPIC -o $(OUT)/$@.o $<

hashmap_static: 
	$(AR) -rcs $(OUT_STATIC)/lib$@.a $(OUT)/hashmap.o

hashmap_shared: 
	$(CC) $(OUT)/hashmap.o -shared -o $(OUT_SHARED)/lib$@.so

test: all
	$(CC) test/*.c -I$(PWD) -L$(OUT_STATIC) -Wl,-rpath=$(OUT_STATIC) -o $(OUT)/static_test -lhashmap_static
	$(OUT)/static_test
	$(CC) test/*.c -I$(PWD) -L$(OUT_SHARED) -Wl,-rpath=$(OUT_SHARED) -o $(OUT)/shared_test -lhashmap_shared
	$(OUT)/shared_test

clean:
	rm -f *.o *.a *.so	
	rm -rf $(OUT)
