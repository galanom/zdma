CFLAGS=-std=gnu11 -ggdb -Wall -fdiagnostics-color=always -fmax-errors=4 -Werror \
    -Wno-declaration-after-statement -Wno-misleading-indentation \
    -Wno-unused-function -ftrack-macro-expansion=0 -fopenmp

APP = libzdma
APP_OBJS = libzdma.o

all: build

build: $(APP)

$(APP): $(APP_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(APP_OBJS) $(LDLIBS) -fopenmp

clean:
	rm -f $(APP) $(APP_OBJS)
