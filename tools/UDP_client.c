#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define BUFSIZE 1024
 
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
    char buffer[BUFSIZE];
    socklen_t addr_size;
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    memset(&addr, '\0', sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip);

    int i = 1;
    while (i <= packets) {
        bzero(buffer, BUFSIZE);
        for (int k = 0; k < 45; k+=1) {
            buffer[k] = 'a';
        }
        sendto(sockfd, buffer, BUFSIZE, 0, (struct sockaddr*)&addr, sizeof(addr));
        printf("[+]Data send: packet %d\n", i);
        i += 1;
    }
    
    return 0;
}