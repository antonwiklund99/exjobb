#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define BUFSIZE (64000)

void error(char *msg, int err) {
    perror(msg);
    exit(err);
}

int main(int argc, char **argv) {

    if (argc != 4) {
        printf("Usage: %s <server-ip> <port> <packets>\n", argv[0]);
        exit(0);
    }

    char *ip = argv[1];
    int port = atoi(argv[2]);
    int packets = atoi(argv[3]);

    int sockfd;
    int err;
    struct sockaddr_in addr;
    socklen_t addr_size;

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&addr, '\0', sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip);

    if ((err = connect(sockfd, (struct sockaddr *)&addr, sizeof(addr))) < 0)
        error("ERROR connecting", err);

    int i = 1;
    char msg[] = {'L', 'E', 'A', 'K'};
    int msg_idx = 0;
    while (i <= packets) {
        int size = rand() % BUFSIZE;
        char buffer[size];
        for (int j = 0; j < size; j++) {
            buffer[j] = msg[msg_idx];
            msg_idx = (msg_idx + 1) % 4;
        }
        err = write(sockfd, buffer, size);
        if (err < 0)
            error("ERROR when writting", err);
        printf("[+]Data send: packet %d with size %d\n", i, size);
        i++;
    }

    close(sockfd);

    bzero(msg, 4);

    return 0;
}
