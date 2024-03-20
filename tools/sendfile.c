#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/sendfile.h>

#include <arpa/inet.h>
#include <linux/tcp.h>
#include <linux/socket.h>

#include <linux/tls.h>
#include <stdbool.h>

#define TLS_PAYLOAD_MAX_LEN 16384

#define TLS_1_2_VERSION		TLS_VERSION_NUMBER(TLS_1_2)
#define TLS_CIPHER_AES_GCM_128				51

static void ulp_sock_pair(int *fd, int *cfd, bool *notls)
{
	struct sockaddr_in addr;
	socklen_t len;
	int sfd, ret;

	*notls = false;
	len = sizeof(addr);

	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = htonl(INADDR_ANY);
	addr.sin_port = 0;

	*fd = socket(AF_INET, SOCK_STREAM, 0);
	sfd = socket(AF_INET, SOCK_STREAM, 0);

	ret = bind(sfd, (struct sockaddr *)&addr, sizeof(addr));

	ret = listen(sfd, 10);

	ret = getsockname(sfd, (struct sockaddr *)&addr, &len);

	ret = connect(*fd, (struct sockaddr *)&addr, sizeof(addr));

	*cfd = accept(sfd, (struct sockaddr *)&addr, &len);

	close(sfd);

	ret = setsockopt(*fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
	if (ret != 0) {
		*notls = true;
		printf("Failure setting TCP_ULP, testing without it\n");
		return;
	}

	ret = setsockopt(*cfd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
	if (ret != 0) {
		*notls = true;
		printf("Failure setting TCP_ULP, testing without it\n");
		return;
	}
}

static void setup_tls(int fd, int cfd) {
	int ret;
	/* Setting up tls encryption */
	struct tls12_crypto_info_aes_gcm_128 crypto_info;
	crypto_info.info.version = TLS_1_2_VERSION;
	crypto_info.info.cipher_type = TLS_CIPHER_AES_GCM_128;
	
	ret = setsockopt(fd, SOL_TLS, TLS_TX, &crypto_info, sizeof(struct tls12_crypto_info_aes_gcm_128));
	if (ret != 0) {
		printf("Failure setting AES GCM 128, testing without it\n");
	}

	ret = setsockopt(cfd, SOL_TLS, TLS_RX, &crypto_info, sizeof(struct tls12_crypto_info_aes_gcm_128));
	if (ret != 0) {
		printf("Failure setting AES GCM 128, testing without it\n");
	}
}

int sendfile_test(int fd, int cfd) {
	/* Do the tests */
	int filefd = open("/proc/self/exe", O_RDONLY);
	char const *test_str = "test_send";
	int to_send = strlen(test_str) + 1;
	char recv_buf[10];
	struct stat st;
	char *buf;

	fstat(filefd, &st);
	buf = (char *)malloc(st.st_size);

	if (send(fd, test_str, to_send, 0) < 0) {
		perror("cannot send string\n");
	}

	ssize_t string_size = recv(cfd, recv_buf, to_send, MSG_WAITALL);

    if (sendfile(fd, filefd, 0, st.st_size) < 0) {
		perror("cannot send file\n");
	}

	ssize_t file_size = recv(cfd, buf, st.st_size, MSG_WAITALL);

	printf("STRING:  Sent: %d, got: %zd\n", to_send, string_size);
	printf("FILE:    Sent: %ld, got: %zd\n", st.st_size, file_size);

	close(filefd);

	return 0;
}

static int tls_send_cmsg(int fd, unsigned char record_type,
			 void *data, size_t len, int flags)
{
	char cbuf[CMSG_SPACE(sizeof(char))];
	int cmsg_len = sizeof(char);
	struct cmsghdr *cmsg;
	struct msghdr msg;
	struct iovec vec;

	vec.iov_base = data;
	vec.iov_len = len;
	memset(&msg, 0, sizeof(struct msghdr));
	msg.msg_iov = &vec;
	msg.msg_iovlen = 1;
	msg.msg_control = cbuf;
	msg.msg_controllen = sizeof(cbuf);
	cmsg = CMSG_FIRSTHDR(&msg);
	cmsg->cmsg_level = SOL_TLS;
	/* test sending non-record types. */
	cmsg->cmsg_type = TLS_SET_RECORD_TYPE;
	cmsg->cmsg_len = CMSG_LEN(cmsg_len);
	*CMSG_DATA(cmsg) = record_type;
	msg.msg_controllen = cmsg->cmsg_len;

	return sendmsg(fd, &msg, flags);
}

int main(int argc, char **argv) {

	int fd, cfd;
	bool notls;

	/* Setting up socket */
	ulp_sock_pair(&fd, &cfd, &notls);
	setup_tls(fd, cfd);

	printf("Testing sendfile...\n");
	sendfile_test(fd, cfd);

	close(fd);
	close(cfd);

	return 0;
}
