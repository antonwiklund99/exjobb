#include <arpa/inet.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define BUFSIZE (64000)

void error(char *msg) {
    perror(msg);
    exit(1);
}

int main(int argc, char **argv) {
    int sockfd;                    /* socket */
    int newsockfd;                 /* accepted sockets */
    int portno;                    /* port to listen on */
    unsigned int clientlen;        /* byte size of client's address */
    struct sockaddr_in serveraddr; /* server's addr */
    struct sockaddr_in clientaddr; /* client addr */
    struct hostent *hostp;         /* client host info */
    char buf[BUFSIZE];             /* message buf */
    char *hostaddrp;               /* dotted decimal host addr string */
    int optval;                    /* flag value for setsockopt */
    int n;                         /* message byte size */

    if (argc != 2) {
        fprintf(stderr, "usage: %s <port>\n", argv[0]);
        exit(1);
    }
    portno = atoi(argv[1]);

    /*
     * socket: create the parent socket
     */
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
        error("ERROR opening socket");

    /* setsockopt: Handy debugging trick that lets
     * us rerun the server immediately after we kill it;
     * otherwise we have to wait about 20 secs.
     */
    optval = 1;
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, (const void *)&optval,
               sizeof(int));

    /*
     * build the server's Internet address
     */
    bzero((char *)&serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons((unsigned short)portno);

    /*
     * bind: associate the parent socket with a port
     */
    if (bind(sockfd, (struct sockaddr *)&serveraddr, sizeof(struct sockaddr)) <
        0)
        error("ERROR on binding");

    /*
     * main loop: wait for a tcp connection
     */
    listen(sockfd, 10);
    clientlen = sizeof(clientaddr);
    printf("Listening on port %d...\n", portno);

    int msg_index = 0;
    int errors = 0;
    while (1) {
		char *expected_msg = malloc(4*sizeof(char));
		expected_msg[0] = 'L'; 
		expected_msg[1] = 'E';
		expected_msg[2] = 'A';
		expected_msg[3] = 'K';
        newsockfd = accept(sockfd, (struct sockaddr *)&clientaddr, &clientlen);
        if (newsockfd < 0)
            error("ERROR on accept");
        puts("Accepted new connection");

        // Read data
        msg_index = 0;
        errors = 0;
        while (1) {
            bzero(buf, BUFSIZE);
            n = read(newsockfd, buf, BUFSIZE);
            if (n < 0)
                error("ERROR reading from socket");
            // EOF (socket closed)
            if (n == 0) {
                printf("Socket closed, errors = %d\n", errors);
                close(newsockfd);
                break;
            }
            for (int i = 0; i < n; i++) {
                if (buf[i] != expected_msg[msg_index]) {
                    // printf("error: buf[%d] = %c (%x), expected = %c\n", i,
                    //        buf[i], buf[i], expected_msg[msg_index]);
                    errors++;
                }
                msg_index = (msg_index + 1) % 4;
            }
            printf("Server received %ld/%d\n", strlen(buf), n);
        }

    	explicit_bzero(expected_msg, 4);
		free(expected_msg);
    }
}
