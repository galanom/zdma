CFLAGS=-std=gnu11 -ggdb -Wall -fdiagnostics-color=always -fmax-errors=4 -Werror \
    -Wno-declaration-after-statement -Wno-misleading-indentation \
    -Wno-unused-function -ftrack-macro-expansion=0

LIB=libzdma.so.1

all: build

build: ${LIB}

libzdma.o: libzdma.c
	$(CC) $(CFLAGS) -c -fpic libzdma.c

${LIB}: libzdma.o
	$(CC) $(LDFLAGS) -shared -o ${LIB} libzdma.o $(LDLIBS)

clean:
	rm -f libzdma.so libzdma.o
