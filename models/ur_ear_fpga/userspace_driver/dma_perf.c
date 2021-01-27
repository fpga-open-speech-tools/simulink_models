#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <errno.h>
#include <stdint.h>



#include <netinet/tcp.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>


#include "minimal-ws-server.c"

#define DEVICE_MEMORY  "/sys/class/fe_ur_ear_fpga_sim/fe_ur_ear_fpga_sim0/spike_count"

struct wait_arg_struct {
  int * continueWait;
  int * ready;
};

extern int interrupted;
int active;

void* persistentReadRAM();
void* wait(void * arguments);
int readRAM(int addr, char buf[], int len);
void initializeRAM();
int socket_connect(char *host, in_port_t port);
void * connect_to_deployment_manager();

static char f[16];
// static int mem_fd, addr_fd;

int main(int argc, const char **argv) {
  pthread_t thread_id, dm_connection_thread;
  const int readLen = 16;
  char e[readLen];
  
  //initializeRAM();
  signal(SIGINT, sigint_handler);


  //readRAM(1, e, readLen);

  pthread_create(&thread_id, NULL, &persistentReadRAM, NULL);
  //pthread_create(&dm_connection_thread, NULL, &connect_to_deployment_manager, NULL);

  attach_message_receive_callback(&send_message_all_clients);
  start_socket(argc, argv);

  while(interrupted == 0);

  return 0;
}

void* persistentReadRAM(){
  pthread_t thread_id;
  struct timeval time2;
  struct timeval t0;
  int * status, *readNow;
  unsigned int i = 0, n = 0;
  // float timeTemp;
  int val, len;

  struct wait_arg_struct wait_args;
  const int readLen = 16;
  char e[readLen];

  status = &interrupted;
  wait_args.continueWait = status;
  wait_args.ready = readNow;

  pthread_create(&thread_id, NULL, &wait, (void *) &wait_args);
  // gettimeofday(&t0, NULL);
  // timeTemp = 1E-6 * t0.tv_usec + t0.tv_sec;
  do{
    if(*readNow) {
      *readNow = 0;
      len = readRAM(n++, f, readLen);
      
      // printf("Th3 buffer is %s\n",  f);
      
      if(active) {
        // // 
        // printf("The buffer is %s\n",  f);
        send_message_all_clients(f, len);
        
      }
      if(i++ == 1000){
        
        // gettimeofday(&t0, NULL);
        // printf("Did %u calls in %.5g seconds\n", 1000, t0.tv_sec + 1E-6 * t0.tv_usec - timeTemp);
        // time2.tv_sec = t0.tv_sec;
        // time2.tv_usec = t0.tv_usec;
        //time2 = t0;
        i  = 0;
        //gettimeofday(&t0, NULL);
      }
      if(n == 256){
        n = 0;
      }
    }
    usleep(50);
  } while(*status == 0);



  return NULL;
}

void* wait(void * arguments) {
  int *continueWait, *ready;
  unsigned int i;
  struct wait_arg_struct *args = (struct wait_arg_struct *) arguments;
  continueWait = args->continueWait;
  ready = args->ready;

  do {
    usleep(1000 * 1000);
    *ready = 1;
  } while(*continueWait == 0);

  return NULL;
}

int readRAM(int addr, char buf[], int len) {
  struct timeval t0, t1;
  unsigned int i;
  int size;
  char addr_c[8];
  int mem_fd, addr_fd;

  #ifdef DEVICE_ADDRESS
  sprintf(addr_c, "%d", addr);
  // if( !addr_fd && (addr_fd = open( "/sys/class/fe_dma/fe_dma0/address", ( O_WRONLY) ) == -1 )) {
  if( ((addr_fd = open( DEVICE_ADDRESS, ( O_WRONLY) )) == -1) ) {
      printf( "ERROR: could not open \""DEVICE_ADDRESS"\"...\n" );
      return -1;
    }
  //printf("Opened the device!\n");

  #endif

  // if( !fd && (fd = open( "/sys/class/fe_dma/fe_dma0/memory", ( O_RDONLY) )  == -1 )) {
  if( ((mem_fd = open( DEVICE_MEMORY, ( O_RDONLY) ))  == -1) ) {
      printf( "ERROR: could not open \""DEVICE_MEMORY"\"...\n" );
      return -1;
    }
  #ifdef DEVICE_ADDRESS
  //printf("Opened the device!\n");
  write(addr_fd, addr_c, 8);
  close(addr_fd);
  #endif
  
  size = read(mem_fd, buf, len);
  if(size < len) {
    buf[size] = '\0';
  }
  else {
    buf[len - 1] = '\0';
  }
   close(mem_fd);

  return size;
}

void initializeRAM() {
  unsigned int i;
  int fd, addr_fd;
  
  if( ( fd = open( "/sys/class/fe_dma/fe_dma0/memory", ( O_WRONLY) ) ) == -1 ) {
      printf( "ERROR: could not open to write \"/sys/class/fe_dma/fe_dma0/memory\"...\n" );
      return;
    }
  printf("Opened the device!\n");

  char d[1536];
  for(i = 0; i < 512; i++){
    sprintf(d, "%u %u", i, i);
    write(fd, &d, 1536);
  }

  close(fd);
  return;
}

// void * connect_to_deployment_manager(){
//   int socket;
//   char host[16] = "127.0.0.1";
//   char *connectString = "POST /data-source?port=7681&&name=spike_rate /\r\n /\r\n";
//   printf("Waiting\n");
//   while(!active){
//     if(interrupted){
//       return NULL;
//     }
//   }

//   printf("Attempting to socket connect\n");

//   socket = socket_connect(host, 3355);
//   write(socket, connectString, strlen(connectString));
//   shutdown(socket, SHUT_RDWR);
//   close(socket);
//   return NULL;
// }

// int socket_connect(char *host, in_port_t port){
// 	struct hostent *hp;
// 	struct sockaddr_in addr;
// 	int on = 1, sock;     

// 	if((hp = gethostbyname(host)) == NULL){
// 		herror("gethostbyname");
// 		exit(1);
// 	}
// 	bcopy(hp->h_addr, &addr.sin_addr, hp->h_length);
// 	addr.sin_port = htons(port);
// 	addr.sin_family = AF_INET;
// 	sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
// 	setsockopt(sock, IPPROTO_TCP, TCP_NODELAY, (const char *)&on, sizeof(int));

// 	if(sock == -1){
// 		perror("setsockopt");
// 		exit(1);
// 	}
	
// 	if(connect(sock, (struct sockaddr *)&addr, sizeof(struct sockaddr_in)) == -1){
// 		perror("connect");
// 		exit(1);

// 	}
// 	return sock;
// }


// int main(int argc, char **argv) {
//   struct timeval t0, t1;
//   unsigned int i;
//   int fd, addr_fd;
//   unsigned int values[512];
//   char addr_c[8];

//   sprintf(addr_c, "%u", 0);

//   // attach_message_receive_callback(&send_message_all_clients);
//   // start_socket(argc, argv);
  
//   if( ( fd = open( "/sys/class/fe_dma/fe_dma0/memory", ( O_WRONLY) ) ) == -1 ) {
//       printf( "ERROR: could not open to write \"/sys/class/fe_dma/fe_dma0/memory\"...\n" );
//       return( 1 );
//     }
//   printf("Opened the device!\n");

//   char d[1536];
//   for(i = 0; i < 512; i++){
//     sprintf(d, "%u %u", i, i);
//     write(fd, &d, 1536);
//   }

//   close(fd);

//   if( ( addr_fd = open( "/sys/class/fe_dma/fe_dma0/address", ( O_WRONLY) ) ) == -1 ) {
//       printf( "ERROR: could not open \"/sys/class/fe_dma/fe_dma0/address\"...\n" );
//       return( 1 );
//     }
//   printf("Opened the device!\n");

//   write(addr_fd, addr_c, 8);
  
//   close(addr_fd);

//   if( ( fd = open( "/sys/class/fe_dma/fe_dma0/memory", ( O_RDONLY) ) ) == -1 ) {
//       printf( "ERROR: could not open \"/sys/class/fe_dma/fe_dma0/memory\"...\n" );
//       return( 1 );
//     }
//   printf("Opened the device!\n");

//   gettimeofday(&t0, NULL);

//   // for(i = 0; i < 256; i++){
//   //     sprintf(addr_c[i], "%u", i);
//   //   }


//   for(int j = 0; j < 10; j++){
//       //write(addr_fd, addr_c, 8);
//       read(fd, &d, 1536);
//       printf("%s \n", d);
//       //for(int q = 0; q < 16; q++)
//       //  values[i + q] = atoi(d);
      
//       //sscanf(d, "%u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u", &values[i], &values[i +1], &values[i+2], &values[i+3], &values[i+4], &values[i+5], &values[i+6], &values[i+7], &values[i+8], &values[i+9], &values[i+10], &values[i+11], &values[i+12], &values[i+13], &values[i+14], &values[i+15]);
//   }
//   gettimeofday(&t1, NULL);
//   close(fd);

//   printf("%s \n", d);

//   // for(i = 0; i < 256; i++){
//   //   //sprintf(d, "%u %u", i, i);
//   //   printf(" %u, ", values[i]);
//   //   if (i % 10 == 0){
//   //     printf("\n");
//   //   }
//   // }

//   printf("Did %u calls in %.5g seconds\n", 1000, t1.tv_sec - t0.tv_sec + 1E-6 * (t1.tv_usec - t0.tv_usec));
  

//   return 0;
// }