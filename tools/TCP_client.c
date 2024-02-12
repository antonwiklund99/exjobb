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
    char buffer[BUFSIZE];
    socklen_t addr_size;
    
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&addr, '\0', sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip);

    if (connect(sockfd,(struct sockaddr*)&addr,sizeof(addr)) < 0)
        error("ERROR connecting");

    int i = 1;
    while (i <= packets) {
        memset(buffer, i, BUFSIZE);
        write(sockfd, buffer, BUFSIZE);
        printf("[+]Data send: packet %d\n", i);
        i += 1;
    }

    close(sockfd);
    
    return 0;
}