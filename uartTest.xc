//========================================================================
// Name        : UART Test
// Author      : Tom Carter <tom@tomcarter.org.uk>
// Description : A simple program to test communication over a serial link
//               between a PC and an XMOS XC-1A
//========================================================================

#include <xs1.h>
#include <platform.h>
#include <print.h>

#define BIT_RATE 115200
#define BIT_TIME XS1_TIMER_HZ / BIT_RATE

on stdcore[0]: in port RXD = PORT_UART_RX;

unsigned char getByte(void)
{
	unsigned time;
	unsigned bits = 0;
	unsigned char c;

	// check this is a new byte
	// DO NOT DELETE THIS!
	RXD when pinseq (1) :> int x;

   // listen for start bit
   RXD when pinseq (0) :> int x @ time;
   time += BIT_TIME + (BIT_TIME >> 1);

   // read body bits
   for (int i = 0; i < 8; i += 1)
   {
      RXD @ time :> >> bits;
      time += BIT_TIME;
   }

   // turn bits into char
   c = (unsigned char) (bits >> 24);

   return {c};
}

void receiveLoop()
{
	char input;

	while (1)
	{
		input = getByte();

		printstr("[Byte received] ");
		printcharln(input);

		if (input == 'x') break;
	}
}

int main(void)
{
	printstrln("UART Test ready");

	receiveLoop();

	printstrln("Terminating.");

	return (0);
}

