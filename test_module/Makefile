KDIR = ../build/linux-x86-basic/
obj-m += test_module.o

all:
	make -C $(KDIR) M=$(PWD) modules
clean:
	make -C $(KDIR) M=$(PWD) clean