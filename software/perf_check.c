#include <arpa/inet.h>
#include <linux/if_packet.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <net/if.h>
#include <netinet/ether.h>

#define MY_DEST_MAC0	0x00
#define MY_DEST_MAC1	0x01
#define MY_DEST_MAC2	0x02
#define MY_DEST_MAC3	0x03
#define MY_DEST_MAC4	0x04
#define MY_DEST_MAC5	0x05

#define APP_HEADER      0x3434

#define BUF_SIZ		9600

uint64_t timestamp() {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec * (uint64_t)1000000 + tv.tv_usec;
}

int main(int argc, char *argv[])
{
	int sockfd;
	struct ifreq if_idx;
	struct ifreq if_mac;
	int tx_len = 0;
	char sendbuf[BUF_SIZ];
	struct ether_header *eh = (struct ether_header *) sendbuf;
	struct sockaddr_ll socket_address;
	char ifName[IFNAMSIZ];
	
	if (argc > 1){
            strcpy(ifName, argv[1]);
        }else{
            printf("usage: %s if-dev-name [queries] [loops]\n", argv[0]);
            return 0;
        }

        int num = 16;
        if (argc > 2)
            num = atoi(argv[2]);
        num = num > 128 ? 128 : num;
        
        int loop_count = 1000;
        if (argc > 3)
            loop_count = atoi(argv[3]);

        printf("#.queries=%d, #.loops=%d\n", num, loop_count);

	if ((sockfd = socket(AF_PACKET, SOCK_RAW, IPPROTO_RAW)) == -1) {
	    perror("socket");
	}

	memset(&if_idx, 0, sizeof(struct ifreq));
	strncpy(if_idx.ifr_name, ifName, IFNAMSIZ-1);
	if (ioctl(sockfd, SIOCGIFINDEX, &if_idx) < 0)
	    perror("SIOCGIFINDEX");
	memset(&if_mac, 0, sizeof(struct ifreq));
	strncpy(if_mac.ifr_name, ifName, IFNAMSIZ-1);
	if (ioctl(sockfd, SIOCGIFHWADDR, &if_mac) < 0)
	    perror("SIOCGIFHWADDR");

	memset(sendbuf, 0, BUF_SIZ);
	eh->ether_shost[0] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[0];
	eh->ether_shost[1] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[1];
	eh->ether_shost[2] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[2];
	eh->ether_shost[3] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[3];
	eh->ether_shost[4] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[4];
	eh->ether_shost[5] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[5];
	eh->ether_dhost[0] = MY_DEST_MAC0;
	eh->ether_dhost[1] = MY_DEST_MAC1;
	eh->ether_dhost[2] = MY_DEST_MAC2;
	eh->ether_dhost[3] = MY_DEST_MAC3;
	eh->ether_dhost[4] = MY_DEST_MAC4;
	eh->ether_dhost[5] = MY_DEST_MAC5;
	/* Ethertype field */
	eh->ether_type = htons(APP_HEADER);
	tx_len += sizeof(struct ether_header);

	/* Packet data */
        for(int i = 0; i < num; i++){
            // command
            sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = num & 0xFF; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00;
            
            //key
            sendbuf[tx_len++] = 0x02; sendbuf[tx_len++] = 0x02; sendbuf[tx_len++] = 0x03; sendbuf[tx_len++] = 0x04;
            sendbuf[tx_len++] = 0x05; sendbuf[tx_len++] = 0x06; sendbuf[tx_len++] = 0x07; sendbuf[tx_len++] = 0x08;
            sendbuf[tx_len++] = 0x09; sendbuf[tx_len++] = 0x0a; sendbuf[tx_len++] = 0x0b; sendbuf[tx_len++] = 0x0c;
            sendbuf[tx_len++] = 0x0d; sendbuf[tx_len++] = 0x0e; sendbuf[tx_len++] = 0x0f; sendbuf[tx_len++] = 0x10;
            sendbuf[tx_len++] = 0x11; sendbuf[tx_len++] = 0x12; sendbuf[tx_len++] = 0x13; sendbuf[tx_len++] = 0x14;
            sendbuf[tx_len++] = 0x15; sendbuf[tx_len++] = 0x16; sendbuf[tx_len++] = 0x17; sendbuf[tx_len++] = 0x18;
            sendbuf[tx_len++] = 0x19; sendbuf[tx_len++] = 0x1a; sendbuf[tx_len++] = 0x1b; sendbuf[tx_len++] = 0x1c;
            sendbuf[tx_len++] = 0x1d; sendbuf[tx_len++] = 0x1e; sendbuf[tx_len++] = 0x1f; sendbuf[tx_len++] = 0x20;
            sendbuf[tx_len++] = i; sendbuf[tx_len++] = i; sendbuf[tx_len++] = i; sendbuf[tx_len++] = i;
            
            //value
            sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x10; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00;
            //addr
            sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00;
            //mask
            sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00;
            sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00;
            //pri
            sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00;
            //search
            sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x00; sendbuf[tx_len++] = 0x08;
        }
        
	/* Index of the network device */
	socket_address.sll_ifindex = if_idx.ifr_ifindex;
	/* Address length*/
	socket_address.sll_halen = ETH_ALEN;
	/* Destination MAC */
	socket_address.sll_addr[0] = MY_DEST_MAC0;
	socket_address.sll_addr[1] = MY_DEST_MAC1;
	socket_address.sll_addr[2] = MY_DEST_MAC2;
	socket_address.sll_addr[3] = MY_DEST_MAC3;
	socket_address.sll_addr[4] = MY_DEST_MAC4;
	socket_address.sll_addr[5] = MY_DEST_MAC5;

        // start to check the performance
        uint64_t start = timestamp();
        int k;
        for(k = 0; k < loop_count; k++){
            if (sendto(sockfd, sendbuf, tx_len, 0, (struct sockaddr*)&socket_address, sizeof(struct sockaddr_ll)) < 0)
                printf("Send failed\n");
        }
        
        uint64_t end = timestamp();

        uint64_t elapsed = end - start;
        printf("elapsed time: = %ld us\n", (end - start));
        double rate = ((double)(num * loop_count)) / ((double)elapsed);
        printf("query-throughput=%g M search/sec.\n", rate);

	return 0;
}
