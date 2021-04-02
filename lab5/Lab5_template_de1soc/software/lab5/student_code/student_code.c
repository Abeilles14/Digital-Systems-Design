/*
 * student_code.c
 *
 *  Created on: Mar 7, 2017
 *      Author: user
 */

#include <system.h>
#include <io.h>
#include "sys/alt_irq.h"
#include "student_code.h"
#include "altera_avalon_pio_regs.h"

#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
void handle_lfsr_interrupts(void* context)
#else
void handle_lfsr_interrupts(void* context, alt_u32 id)
#endif
{
	#ifdef LFSR_VAL_BASE
	#ifdef LFSR_CLK_INTERRUPT_GEN_BASE
	#ifdef DDS_INCREMENT_BASE
	
	// int lfsr_bit;
	// int phase_inc_1hz = 86;		//F_out = M*F_clk/2^n
	// int phase_inc_5hz = 430;

	// //read LFSR value and check bit 0
	// lfsr_bit = IORD_ALTERA_AVALON_PIO_DATA(LFSR_VAL_BASE);
	// if (lfsr_bit) {
	// 	//if LFSR 1, write 5hz to DDS
	// 	IOWR_ALTERA_AVALON_PIO_DATA(DDS_INCREMENT_BASE, phase_inc_5hz);
	// } else {
	// 	//if LFSR 0, write 1hz to DDS
	// 	IOWR_ALTERA_AVALON_PIO_DATA(DDS_INCREMENT_BASE, phase_inc_1hz);
	// }

	// //reset edge capture to prepare for next clk edge
	// /* Cast context to edge_capture's type. It is important that this
	// be declared volatile to avoid unwanted compiler optimization. */
	// volatile int* edge_capture_ptr = (volatile int*) context;

	// /*
	// * Read the edge capture register on the button PIO.
	// * Store value.
	// */
	// *edge_capture_ptr =
	// IORD_ALTERA_AVALON_PIO_EDGE_CAP(LFSR_CLK_INTERRUPT_GEN_BASE);
	// /* Write to the edge capture register to reset it. */
	// IOWR_ALTERA_AVALON_PIO_EDGE_CAP(LFSR_CLK_INTERRUPT_GEN_BASE, 0);
	// /* Read the PIO to delay ISR exit. This is done to prevent a
	// spurious interrupt in systems with high processor -> pio
	// latency and fast interrupts. */
	// IORD_ALTERA_AVALON_PIO_EDGE_CAP(LFSR_CLK_INTERRUPT_GEN_BASE);

	#endif
	#endif
	#endif
}

/* Initialize the button_pio. */

void init_lfsr_interrupt()
{
	#ifdef LFSR_VAL_BASE
	#ifdef LFSR_CLK_INTERRUPT_GEN_BASE
	#ifdef DDS_INCREMENT_BASE
	
	/* Enable interrupts */
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(LFSR_CLK_INTERRUPT_GEN_BASE, 0x1);
	/* Reset the edge capture register. */
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(LFSR_CLK_INTERRUPT_GEN_BASE, 0x0);
	/* Register the interrupt handler. */
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
	alt_ic_isr_register(LFSR_CLK_INTERRUPT_GEN_IRQ_INTERRUPT_CONTROLLER_ID, LFSR_CLK_INTERRUPT_GEN_IRQ, handle_lfsr_interrupts, 0x0, 0x0);
#else
	alt_irq_register( LFSR_CLK_INTERRUPT_GEN_IRQ, NULL,	handle_button_interrupts);
#endif
	
	#endif
	#endif
	#endif
}

