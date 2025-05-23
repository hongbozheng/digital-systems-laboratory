//Fill in your low-level SPI functions here, as per your host platform

#define _MAX3421E_C_

#include "system.h"
#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "../usb_kb/project_config.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_pio_regs.h"
#include <sys/alt_stdio.h>
#include <unistd.h>

//variables and data structures
//External variables
extern BYTE usb_task_state;

/* Functions    */
void SPI_init(BYTE sync_mode, BYTE bus_mode, BYTE smp_phase) {
	//Don't need to initialize SPI port, already ready to go with BSP
}

//writes single byte to MAX3421E via SPI, simultanously reads status register and returns it
BYTE SPI_wr(BYTE data) {
	//This function is never used by the code, so you do not need to fill it in

//	int return_code = alt_avalon_spi_command(SPI_0_BASE, 0, 1, &data, 0, 0, 0);
//
//	if(return_code < 0)
//		alt_printf("Error\n");
//
//	return return_code;
}
//writes register to MAX3421E via SPI
void MAXreg_wr(BYTE reg, BYTE val) {
	//psuedocode:
	//select MAX3421E (may not be necessary if you are using SPI peripheral)
	//write reg + 2 via SPI
	//write val via SPI
	//read return code from SPI peripheral (see Intel documentation) 
	//if return code < 0 print an error
	//deselect MAX3421E (may not be necessary if you are using SPI peripheral)

	BYTE temp_array[2] = {reg + 2, val};

	int return_code = alt_avalon_spi_command(SPI_BASE, 0, 2, temp_array, 0, NULL, 0);

	if(return_code < 0)
		alt_printf("Error\n");
}
//multiple-byte write
//returns a pointer to a memory position after last written
BYTE* MAXbytes_wr(BYTE reg, BYTE nbytes, BYTE* data) {
	//psuedocode:
	//select MAX3421E (may not be necessary if you are using SPI peripheral)
	//write reg + 2 via SPI
	//write data[n] via SPI, where n goes from 0 to nbytes-1
	//read return code from SPI peripheral (see Intel documentation) 
	//if return code < 0  print an error
	//deselect MAX3421E (may not be necessary if you are using SPI peripheral)
	//return (data + nbytes);

	BYTE temp_array[nbytes +1];

	temp_array[0] = (reg+2);

	for(int i = 1; i < nbytes + 1; i++){
		temp_array[i] = data[i-1];
	}

	int return_code = alt_avalon_spi_command(SPI_BASE, 0, nbytes+1, temp_array, 0, NULL, 0);

	if(return_code < 0)
		alt_printf("Error\n");

	return (data+nbytes);
}

//reads register from MAX3421E via SPI
BYTE MAXreg_rd(BYTE reg) {
	//psuedocode:
	//select MAX3421E (may not be necessary if you are using SPI peripheral)
	//write reg via SPI
	//read val via SPI
	//read return code from SPI peripheral (see Intel documentation)
	//if return code < 0 print an error
	//deselect MAX3421E (may not be necessary if you are using SPI peripheral)
	//return val

	BYTE val;

	int return_code = alt_avalon_spi_command(SPI_BASE, 0, 1, &reg, 1, &val, 0);

	if(return_code < 0)
		alt_printf("Error\n");

	return(val);
}
//multiple-byte write
//returns a pointer to a memory position after last written
BYTE* MAXbytes_rd(BYTE reg, BYTE nbytes, BYTE* data) {
	//psuedocode:
	//select MAX3421E (may not be necessary if you are using SPI peripheral)
	//write reg via SPI
	//read data[n] from SPI, where n goes from 0 to nbytes-1
	//read return code from SPI peripheral (see Intel documentation)
	//if return code < 0 print an error
	//deselect MAX3421E (may not be necessary if you are using SPI peripheral)
	//return (data + nbytes);

	int return_code = alt_avalon_spi_command(SPI_BASE, 0, 1, &reg, nbytes, data, 0);

	if(return_code < 0)
		alt_printf("Error\n");

	return (data+nbytes);
}
/* reset MAX3421E using chip reset bit. SPI configuration is not affected   */
void MAX3421E_reset(void) {
	//hardware reset, then software reset
	IOWR_ALTERA_AVALON_PIO_DATA(USB_RST_BASE, 0);
	usleep(1000000);
	IOWR_ALTERA_AVALON_PIO_DATA(USB_RST_BASE, 1);
	BYTE tmp = 0;
	MAXreg_wr( rUSBCTL, bmCHIPRES);      //Chip reset. This stops the oscillator
	MAXreg_wr( rUSBCTL, 0x00);                          //Remove the reset
	while (!(MAXreg_rd( rUSBIRQ) & bmOSCOKIRQ)) { //wait until the PLL stabilizes
		tmp++;                                      //timeout after 256 attempts
		if (tmp == 0) {
			printf("reset timeout!");
		}
	}
}
/* turn USB power on/off                                                */
/* ON pin of VBUS switch (MAX4793 or similar) is connected to GPOUT7    */
/* OVERLOAD pin of Vbus switch is connected to GPIN7                    */
/* OVERLOAD state low. NO OVERLOAD or VBUS OFF state high.              */
BOOL Vbus_power(BOOL action) {
	// power on/off successful
	return (1);
}

/* probe bus to determine device presense and speed */
void MAX_busprobe(void) {
	BYTE bus_sample;

//  MAXreg_wr(rHCTL,bmSAMPLEBUS);
	bus_sample = MAXreg_rd( rHRSL);            //Get J,K status
	bus_sample &= ( bmJSTATUS | bmKSTATUS);      //zero the rest of the byte

	switch (bus_sample) {                   //start full-speed or low-speed host
	case ( bmJSTATUS):
		/*kludgy*/
		if (usb_task_state != USB_ATTACHED_SUBSTATE_WAIT_RESET_COMPLETE) { //bus reset causes connection detect interrupt
			if (!(MAXreg_rd( rMODE) & bmLOWSPEED)) {
				MAXreg_wr( rMODE, MODE_FS_HOST);         //start full-speed host
				printf("Starting in full speed\n");
			} else {
				MAXreg_wr( rMODE, MODE_LS_HOST);    //start low-speed host
				printf("Starting in low speed\n");
			}
			usb_task_state = ( USB_STATE_ATTACHED); //signal usb state machine to start attachment sequence
		}
		break;
	case ( bmKSTATUS):
		if (usb_task_state != USB_ATTACHED_SUBSTATE_WAIT_RESET_COMPLETE) { //bus reset causes connection detect interrupt
			if (!(MAXreg_rd( rMODE) & bmLOWSPEED)) {
				MAXreg_wr( rMODE, MODE_LS_HOST);   //start low-speed host
				printf("Starting in low speed\n");
			} else {
				MAXreg_wr( rMODE, MODE_FS_HOST);         //start full-speed host
				printf("Starting in full speed\n");
			}
			usb_task_state = ( USB_STATE_ATTACHED); //signal usb state machine to start attachment sequence
		}
		break;
	case ( bmSE1):              //illegal state
		usb_task_state = ( USB_DETACHED_SUBSTATE_ILLEGAL);
		break;
	case ( bmSE0):              //disconnected state
		if (!((usb_task_state & USB_STATE_MASK) == USB_STATE_DETACHED)) //if we came here from other than detached state
			usb_task_state = ( USB_DETACHED_SUBSTATE_INITIALIZE); //clear device data structures
		else {
			MAXreg_wr( rMODE, MODE_FS_HOST); //start full-speed host
			usb_task_state = ( USB_DETACHED_SUBSTATE_WAIT_FOR_DEVICE);
		}
		break;
	} //end switch( bus_sample )
}
/* MAX3421E initialization after power-on   */
void MAX3421E_init(void) {
	/* Configure full-duplex SPI, interrupt pulse   */
	MAXreg_wr( rPINCTL, (bmFDUPSPI + bmINTLEVEL + bmGPXB)); //Full-duplex SPI, level interrupt, GPX
	MAX3421E_reset();                                //stop/start the oscillator
	/* configure power switch   */
	Vbus_power( OFF);                                      //turn Vbus power off
	MAXreg_wr( rGPINIEN, bmGPINIEN7); //enable interrupt on GPIN7 (power switch overload flag)
	Vbus_power( ON);
	/* configure host operation */
	MAXreg_wr( rMODE, bmDPPULLDN | bmDMPULLDN | bmHOST | bmSEPIRQ); // set pull-downs, SOF, Host, Separate GPIN IRQ on GPX
	//MAXreg_wr( rHIEN, bmFRAMEIE|bmCONDETIE|bmBUSEVENTIE );                      // enable SOF, connection detection, bus event IRQs
	MAXreg_wr( rHIEN, bmCONDETIE);                        //connection detection
	/* HXFRDNIRQ is checked in Dispatch packet function */
	MAXreg_wr(rHCTL, bmSAMPLEBUS);        // update the JSTATUS and KSTATUS bits
	MAX_busprobe();                             //check if anything is connected
	MAXreg_wr( rHIRQ, bmCONDETIRQ); //clear connection detect interrupt                 
	MAXreg_wr( rCPUCTL, 0x01);                            //enable interrupt pin
}

/* MAX3421 state change task and interrupt handler */
void MAX3421E_Task(void) {
	if ( IORD_ALTERA_AVALON_PIO_DATA(USB_IRQ_BASE) == 0) {
		printf("MAX interrupt\n\r");
		MaxIntHandler();
	}
	if ( IORD_ALTERA_AVALON_PIO_DATA(USB_GPX_BASE) == 1) {
		printf("GPX interrupt\n\r");
		MaxGpxHandler();
	}
}

void MaxIntHandler(void) {
	BYTE HIRQ;
	BYTE HIRQ_sendback = 0x00;
	HIRQ = MAXreg_rd( rHIRQ);                  //determine interrupt source
	printf("IRQ: %x\n", HIRQ);
	if (HIRQ & bmFRAMEIRQ) {                   //->1ms SOF interrupt handler
		HIRQ_sendback |= bmFRAMEIRQ;
	}                   //end FRAMEIRQ handling

	if (HIRQ & bmCONDETIRQ) {
		MAX_busprobe();
		HIRQ_sendback |= bmCONDETIRQ;      //set sendback to 1 to clear register
	}
	if (HIRQ & bmSNDBAVIRQ) //if the send buffer is clear (previous transfer completed without issue)
	{
		MAXreg_wr(rSNDBC, 0x00);//clear the send buffer (not really necessary, but clears interrupt)
	}
	if (HIRQ & bmBUSEVENTIRQ) {           //bus event is either reset or suspend
		usb_task_state++;                       //advance USB task state machine
		HIRQ_sendback |= bmBUSEVENTIRQ;
	}
	/* End HIRQ interrupts handling, clear serviced IRQs    */
	MAXreg_wr( rHIRQ, HIRQ_sendback); //write '1' to CONDETIRQ to ack bus state change
}

void MaxGpxHandler(void) {
	BYTE GPINIRQ;
	GPINIRQ = MAXreg_rd( rGPINIRQ);            //read both IRQ registers
}
