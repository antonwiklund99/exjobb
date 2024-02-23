objects = UDP_client UDP_server TCP_client TCP_server
CC = gcc
CFLAGS = -Wpedantic -O3

all: $(objects)

$(objects): %: %.c
	$(CC) $(CFLAGS) -o $@ $<
	cp $@ ../buildroot/output/target/
	
clean: 
	rm -rf UDP_client UDP_server TCP_client TCP_server
