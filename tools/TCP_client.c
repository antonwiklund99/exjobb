#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define BUFSIZE (64000)

void error(char *msg)
{
	perror(msg);
	exit(1);
}

int main(int argc, char **argv){

    if (argc != 4) {
        printf("Usage: %s <server-ip> <port> <packets>\n", argv[0]);
        exit(0);
    }
    
    char *ip = argv[1];
    int port = atoi(argv[2]);
    int packets = atoi(argv[3]);
    
    int sockfd;
    struct sockaddr_in addr;
    socklen_t addr_size;
    
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&addr, '\0', sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip);

    if (connect(sockfd,(struct sockaddr*)&addr,sizeof(addr)) < 0)
        error("ERROR connecting");

    int i = 1;
    unsigned int nr_bytes = 0;
    while (i <= packets) {
        int size = rand() % BUFSIZE;
        char buffer[size];
        for (int j = 0; j < size; j+=4) {
            buffer[j] = 'L';
            buffer[j+1] = 'E';
            buffer[j+2] = 'A';
            buffer[j+3] = 'K';
            // unsigned char b = nr_bytes & 0xff;
            // buffer[j] = b;
            // //printf("nr_bytes=%u parsed=%u\n", nr_bytes, b);
            // nr_bytes++;
        }
        write(sockfd, buffer, size);
        printf("[+]Data send: packet %d with size %d\n", i, size);
        i++;
    }

    close(sockfd);
    
    return 0;
}
