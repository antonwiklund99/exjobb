#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define BUFSIZE 64000

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
    struct sockaddr_in addr;
    char *buffer = malloc(BUFSIZE);
    socklen_t addr_size;

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    memset(&addr, '\0', sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip);

	char *msg = malloc(4*sizeof(char));
    msg[0] = 'L'; 
	msg[1] = 'E';
	msg[2] = 'A';
	msg[3] = 'K';
    int msg_idx = 0;

    int i = 1;
    while (i <= packets) {
        for (int k = 0; k < BUFSIZE; k++) {
			buffer[k] = msg[msg_idx%4];
			msg_idx = (msg_idx + 1) % 4;
		}

        int err = sendto(sockfd, buffer, BUFSIZE, 0, (struct sockaddr *)&addr,
               sizeof(addr));

		if (err < 0) 
			error("Error when sending data, exiting...\n", err);

        printf("[+]Data send: packet %d\n", i);
        i += 1;
    }

	close(sockfd);
	explicit_bzero(buffer, BUFSIZE);
    explicit_bzero(msg, 4);
	free(msg);

    return 0;
}
