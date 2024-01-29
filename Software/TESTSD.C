#pragma nonrec

#include <stdio.h>
#include <conio.h>
#include <dos.h>

unsigned port;
char b;
char save_mmu3;

#define port_isa 0x9FBD
#define port_system 0x1FFD
#define isa_addr_base 0xC000
#define sj_addr_base 0x250
#define emm_win_p3 0xE2
#define port_sj 0xC250

#define SJ_DET port_sj
#define SJ_STATUS1 port_sj+2
#define SJ_STATUS2 port_sj+3

  
/*
 #define BAUD_RATE 115200
 #define XIN_FREQ 14745600
 #define DIVISOR XIN_FREQ / (BAUD_RATE * 16)
*/
   
/**
 * Small delay
 */
delay() {
   unsigned ctr;
   for (ctr=0; ctr<2000; ctr++) {
   }
}

/**
 * Reset ISA device
 */
reset_isa() {
   outp(port_isa, 0xc0); // RESET=1 AEN=1
   delay();
   outp(port_isa,0); // RESET=0 AEN=0
   delay();
   delay();
}

/*
 * Open access to ISA ports as memory
 */
open_isa() {
   save_mmu3 = inp(emm_win_p3);
   outp(port_system, 0x11);
   outp(emm_win_p3, 0xd4);
   outp(port_isa, 0);
}                              
   
/*
 * Close access to ISA ports
 */
close_isa() {
   outp(port_system, 0x01);
   outp(emm_win_p3, save_mmu3);
}

char read_port(port)
unsigned port;
{  
   char rb;
   open_isa();
   rb = mget(port);
   close_isa();
   return rb;
}   


void write_port(port, b)
unsigned port;
char b;
{
   open_isa();
   mset(port, b);
   close_isa();
}

char detect;
char status1;
char status2;
unsigned ctr;
unsigned d;

main() {

   printf("\nReset ISA devices\n");
   reset_isa();
   printf("\nRead SegaJoy\n");
   for (ctr=0; ctr<=60; ctr++) {
      detect = read_port(SJ_DET);
      status1 = read_port(SJ_STATUS1);
      status2 = read_port(SJ_STATUS2);

      printf("DET="); hex8(detect);
      printf("; ST1="); hex8(status1);
      printf("; ST2="); hex8(status2);
      printf("\n");
      for (ctr=0; ctr<400; ctr++) {
         delay();
      }
   }     
                      
   for (d=0; d<400; d++) {
     delay();
   }                  

   printf("\nExiting\n");
}



