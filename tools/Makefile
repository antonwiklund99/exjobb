objects = UDP_client UDP_server TCP_client TCP_server sslecho
CC = gcc
CFLAGS = -Wpedantic
LDLIBS = -lssl -lcrypto 

all: $(objects)
	cp *.pem ../buildroot/output/target/

$(objects): %: %.c
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS)
	cp $@ ../buildroot/output/target/
	
clean: 
	rm -rf UDP_client UDP_server TCP_client TCP_server sslecho
