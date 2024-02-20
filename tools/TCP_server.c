#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define BUFSIZE (4)

void error(char *msg)
{
	perror(msg);
	exit(1);
}

int main(int argc, char **argv)
{
	int sockfd;					   /* socket */
	int newsockfd;				   /* accepted sockets */
	int portno;					   /* port to listen on */
	unsigned int clientlen;		   /* byte size of client's address */
	struct sockaddr_in serveraddr; /* server's addr */
	struct sockaddr_in clientaddr; /* client addr */
	struct hostent *hostp;		   /* client host info */
	char buf[BUFSIZE];			   /* message buf */
	char *hostaddrp;			   /* dotted decimal host addr string */
	int optval;					   /* flag value for setsockopt */
	int n;						   /* message byte size */

	if (argc != 2)
	{
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
	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR,
			   (const void *)&optval, sizeof(int));

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
	if (bind(sockfd, (struct sockaddr *)&serveraddr, sizeof(struct sockaddr)) < 0)
		error("ERROR on binding");

	/*
	 * main loop: wait for a tcp connection
	 */
	listen(sockfd, 1);
	clientlen = sizeof(clientaddr);
	printf("Listening on port %d...\n", portno);
	while (1)
	{
		unsigned int nr_bytes = 0;
		newsockfd = accept(sockfd, (struct sockaddr *) &clientaddr, &clientlen);
		if (newsockfd < 0)
			error("ERROR on accept");
		puts("Accepted new connection");
		
		// Read data
		while (1) {
			bzero(buf, BUFSIZE);
			n = read(newsockfd, buf, BUFSIZE);
			if (n < 0)
				error("ERROR reading from socket");
			// EOF (socket closed)
			if (n == 0) {
				puts("Socket closed");
				close(newsockfd);
				break;
			}
			printf("Server received %ld/%d\n", strlen(buf), n);
			// for (int i = 0; i < n; i++) {
			// 	unsigned char b = nr_bytes & 0xff;
			// 	unsigned char br = buf[i];
			// 	if (br != b)
			// 		printf("ERROR in Byte %u: buf[%i] = %u\n", b, i, br);
			// 	nr_bytes++;
			// }
		}

	}
}