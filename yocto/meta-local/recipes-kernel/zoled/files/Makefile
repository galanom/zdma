obj-m := zoled.o

ccflags-y := -std=gnu11 -Wall -fdiagnostics-color=always -fmax-errors=4 -Werror -Wno-declaration-after-statement -Wno-misleading-indentation -Wno-unused-function -ftrack-macro-expansion=0

SRC := $(shell pwd)

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC)

modules_install:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) modules_install

clean:
	rm -f *.o *~ core .depend .*.cmd *.ko *.mod.c
	rm -f Module.markers Module.symvers modules.order
	rm -rf .tmp_versions Modules.symvers
