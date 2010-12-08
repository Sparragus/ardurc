//************************************************************************
//
//				LCD_driver.c: Interface for Nokia LCD
//
//************************************************************************
//************************************************************************
//*	Edit History
//*		<MLS>	= Mark Sproul msproul -at- jove.rutgers.edu
//************************************************************************
//*	Apr  2,	2010	<MLS> I received my Color LCD Shield sku: LCD-09363 from sparkfun
//*	Apr  2,	2010	<MLS> The code was written for WinAVR, I modified it to compile under Arduino
//*	Apr  3,	2010	<MLS> Changed LCDSetPixel to make it "RIGHT" side up
//*	Apr  3,	2010	<MLS> Made LCDSetPixel public
//*	Apr  3,	2010	<MLS> Working on MEGA, pin defs in nokia_tester.h
//*	Apr  4,	2010	<MLS> Removed delays from LCDCommand & LCDCommand, increased speed by 75%
//************************************************************************

// *******************************************************************************************************
// lcd.c
//
// Nokia 6610 LCD Display Driver (PCF8833 Controller)
//
// Controller used for LCD Display is a Philips PCF8833 STN RGB-132x132x3 driver
// Note: Leadis LDS176 controller (GE-12) is 100% compatible with Philips PCF8833
//
//
// Nokia 6610 has a 132 x 132 pixel matrix - each pixel has 12 bits of color information.
//
//                                _____
//                                 | |
//             ___________________|___|___
//             | ========================|
// ^   (0,131) |-------------------------|(0,0)
// |           |                         |
// |           |                         |
// |           |                         |
// |           |                         |
// |           |                         |
// |       Rows|    Nokia 6610 Display   | Note: In general, you can't view Row 0 or Row 131
// |           |                         |       and Column 0 and Column 131.
// Y           |                         |
// |           |                         |
// |           |                         |
// |           |                         |
// |           |-------------------------|
//         (131,131)       Columns     (131,0)
//
//            <----------- X ------------->



#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>

#include "nokia_tester.h"
#include "LCD_driver.h"
#include "font.h"

#ifdef _USE_ARDUINO_FOR_NOKIA_
	#include	"WProgram.h"
#endif

//************************************************************************
//
//				"Private" Function Definitions
//
//************************************************************************


//************************************************************************
//
//				Global Variables for LCD driver
//
//************************************************************************
//static char x_offset = 0;
//static char y_offset = 0;

//************************************************************************
//Usage: LCDClear(black);
//Inputs: char color: 8-bit color to be sent to the screen.
//Outputs: None
//Description: This function will clear the screen with "color" by writing the
//				color to each location in the RAM of the LCD.
//************************************************************************
void LCDClear(int color)
{
unsigned int i;

	#ifdef EPSON
		LCDCommand(PASET);
		LCDData(0);
		LCDData(131);
	
		LCDCommand(CASET);
		LCDData(0);
		LCDData(131);

		LCDCommand(RAMWR);
	#endif
	#ifdef	PHILLIPS
		LCDCommand(PASETP);
		LCDData(0);
		LCDData(131);
	
		LCDCommand(CASETP);
		LCDData(0);
		LCDData(131);

		LCDCommand(RAMWRP);
	#endif
	
    // This loop goes from 0 to 131 because that's the amount of pixels
    // in a column or row. We want to color all 132*132 pixels. However,
    // because we are using 12 bit color mode, we need to divide by 2.
    // Remember that in 12 color bit mode, we can use three bytes to color 
    // two pixels. --rK
	for (i=0; i < ((131 * 131) / 2); i++)
	{
        // Calculates red, green --rK
		LCDData((color >> 4) & 0xFF); 

        // Calculates blue, red --rK
		LCDData(((color & 0x0F) << 4) | ((color >> 8) & 0x0F));

        // Calculates green, blue --rK
		LCDData(color & 0xFF);		// nop(EPSON)
	}
	
//	x_offset = 0;
//	y_offset = 0;
}


//************************************************************************
void	delay_us(int microSecs)
{
	delayMicroseconds(microSecs);
}

//************************************************************************
void	delay_ms(int millisecs)
{
//	delay(millisecs);
//	delayMicroseconds(millisecs * 1000);
}


//************************************************************************
//Usage: LCDCommand(RAMWR);
//Inputs: char data - character command to be sent to the LCD
//Outputs: None
//************************************************************************
void LCDCommand(unsigned char data)
{
    char jj;

	cbi(LCD_PORT_CS, CS);		// enable chip, p0.20 goes low
	//delay_us(1);
	cbi(LCD_PORT_DIO, DIO);		// output low on data out (9th bit low = command), p0.19
	//delay_us(1);

	cbi(LCD_PORT_SCK, SCK);		// send clock pulse
	delay_us(1);
	sbi(LCD_PORT_SCK, SCK);
	//delay_us(1);

	for (jj = 0; jj < 8; jj++)
	{
		if ((data & 0x80) == 0x80)
		{
			sbi(LCD_PORT_DIO, DIO);
		}
		else
		{
			cbi(LCD_PORT_DIO, DIO);
		}
		//delay_us(1);

		cbi(LCD_PORT_SCK, SCK);		// send clock pulse
	//+	delay_us(1);
		sbi(LCD_PORT_SCK, SCK);

		data <<= 1;
	}

	sbi(LCD_PORT_CS, CS);			// disable
}

//************************************************************************
//Usage: LCDData(RAMWR);
//Inputs: char data - character data to be sent to the LCD
//Outputs: None
//************************************************************************
void LCDData(unsigned char data)
{
char j;

	cbi(LCD_PORT_CS, CS);			// enable chip, p0.20 goes low
	//delay_us(1);
	sbi(LCD_PORT_DIO, DIO);			// output high on data out (9th bit high = data), p0.19
	//delay_us(1);
	
	cbi(LCD_PORT_SCK, SCK);			// send clock pulse
//+	delay_us(1);
	sbi(LCD_PORT_SCK, SCK);			// send clock pulse
	//delay_us(1);

	for (j = 0; j < 8; j++)
	{
		if ((data & 0x80) == 0x80)
		{
			sbi(LCD_PORT_DIO, DIO);
		}
		else
		{
			cbi(LCD_PORT_DIO, DIO);
		}
		//delay_us(1);
		
		cbi(LCD_PORT_SCK, SCK);		// send clock pulse
//+		delay_us(1);
		sbi(LCD_PORT_SCK, SCK);

		data <<= 1;
	}

	LCD_PORT_CS	|=	(1<<CS);		// disable
}

//************************************************************************
//Usage: LCDInit();
//Inputs: None
//Outputs: None
//Description:  Initializes the LCD regardless of if the controlller is an EPSON or PHILLIPS.
//************************************************************************
void LCDInit(void)
{
	delay_ms(200);
							
	cbi(LCD_PORT_SCK, SCK);			//output_low (SPI_CLK);//output_low (SPI_DO);
	cbi(LCD_PORT_DIO, DIO);
	delay_us(10);
	sbi(LCD_PORT_CS, CS);			//output_high (LCD_CS);
	delay_us(10);
	cbi(LCD_PORT_RES, LCD_RES);		//output_low (LCD_RESET);
	delay_ms(200);
	sbi(LCD_PORT_RES, LCD_RES);		//output_high (LCD_RESET);
	delay_ms(200);
	sbi(LCD_PORT_SCK, SCK);
	sbi(LCD_PORT_DIO, DIO);
	delay_us(10);
	
	LCDCommand(DISCTL);		// display control(EPSON)
	LCDData(0x0C);			// 12 = 1100 - CL dividing ratio [don't divide] switching period 8H (default)
	LCDData(0x20);	
	//LCDData(0x02);
	LCDData(0x00);
	
	LCDData(0x01);
	
	LCDCommand(COMSCN);		// common scanning direction(EPSON)
	LCDData(0x01);
	
	LCDCommand(OSCON);		// internal oscialltor ON(EPSON)
	
	LCDCommand(SLPOUT);		// sleep out(EPSON)
	LCDCommand(P_SLEEPOUT);	//sleep out(PHILLIPS)
	
	LCDCommand(PWRCTR);		// power ctrl(EPSON)
	LCDData(0x0F);			//everything on, no external reference resistors
	LCDCommand(P_BSTRON);	//Booset On(PHILLIPS)
	
	LCDCommand(DISINV);		// invert display mode(EPSON)
	LCDCommand(P_INVON);	// invert display mode(PHILLIPS)
	
	LCDCommand(DATCTL);		// data control(EPSON)
	LCDData(0x03);			// correct for normal sin7
	LCDData(0x00);			// normal RGB arrangement
	//LCDData(0x01);		// 8-bit Grayscale
	LCDData(0x02);			// 16-bit Grayscale Type A
	
	LCDCommand(P_MADCTL);	//Memory Access Control(PHILLIPS)
	LCDData(0xC8);
	
	LCDCommand(P_COLMOD);	// Set Color Mode(PHILLIPS)
	LCDData(0x02);	
	
	LCDCommand(VOLCTR);		// electronic volume, this is the contrast/brightness(EPSON)
	//LCDData(0x18);		// volume (contrast) setting - fine tuning, original
	LCDData(0x24);			// volume (contrast) setting - fine tuning, original
	LCDData(0x03);			// internal resistor ratio - coarse adjustment
	LCDCommand(P_SETCON);	        // Set Contrast(PHILLIPS)
	LCDData(0x30);	
	
	LCDCommand(NOP);		// nop(EPSON)
	LCDCommand(P_NOP);		// nop(PHILLIPS)
	
	delay_ms(200);

	LCDCommand(DISON);		// display on(EPSON)
	LCDCommand(P_DISPON);	// display on(PHILLIPS)

        
}


//************************************************************************
//Usage: LCDPrintLogo();
//Inputs: None
//Outputs: None
//Description: Prints the logo_spark array to the LCD.
//************************************************************************
/*

void LCDPrintLogo(void)
{
	int x = 4, y = 25, logo_ix = 0, z;
	char logo;
	
	for (logo_ix = 0; logo_ix < 1120; logo_ix++)
	{
		logo = logo_spark[logo_ix];
		for (z = 0; z < 8; z++)
		{
			if ((logo & 0x80) == 0x80)
			{
			//	LCDSetPixel(RED, y, x);
				LCDSetPixel(RED, x, y);
			}
			x++;
			if (x == 132)
			{
				x = 4;
				y++;
			}
			
			logo <<= 1;
		}
	}

}

*/

//************************************************************************
//Usage: LCDSetPixel(white, 0, 0);
//Inputs: unsigned char color - desired color of the pixel
//			unsigned char x - Page address of pixel to be colored
//			unsigned char y - column address of pixel to be colored
//Outputs: None
//Description: Sets the starting page(row) and column (x & y) coordinates in ram,
//				then writes the colour to display memory.	The ending x & y are left
//				maxed out so one can continue sending colour data bytes to the 'open'
//				RAMWR command to fill further memory.	issuing any red command
//				finishes RAMWR.
//**NOTE** Because this function is static, it is essentially a "private" function
//		and can only be used within this file!
//*	Apr  3,	2010	<MLS> Made LCDSetPixel public
//************************************************************************
void LCDSetPixel(int color, unsigned char x, unsigned char y)
{
int	myYYvalue;

//*	Apr  3,	2010	<MLS> This is to make it "RIGHT" side up
	
	myYYvalue	=	(COL_HEIGHT - 1) - y;

	#ifdef EPSON
		LCDCommand(PASET);	// page start/end ram
		LCDData(x);
		LCDData(ENDPAGE);
	
		LCDCommand(CASET);	// column start/end ram
		LCDData(myYYvalue);
		LCDData(ENDCOL);
	
		LCDCommand(RAMWR);	// write
		LCDData((color>>4)&0x00FF);
		LCDData(((color&0x0F)<<4)|(color>>8));
		LCDData(color&0x0FF);		// nop(EPSON)		
		//LCDData(color);
		//LCDData(NOP);
		//LCDData(NOP);
	#endif
	#ifdef	PHILLIPS
		LCDCommand(PASETP);	// page start/end ram
		LCDData(x);
		LCDData(ENDPAGE);
	
		LCDCommand(CASETP);	// column start/end ram
		LCDData(myYYvalue);
		LCDData(ENDCOL);
	
		LCDCommand(RAMWRP);	// write
		
		LCDData((unsigned char)((color>>4)&0x00FF));
		LCDData((unsigned char)(((color&0x0F)<<4)|0x00));
	#endif

}



// *****************************************************************************
// LCDPutChar.c
//
// Draws an ASCII character at the specified (x,y) address and color
//
//   Inputs: c = character to be displayed
//           x = row address (0 .. 131)
//           y = column address (0 .. 131)
//           size = font pitch (SMALL, MEDIUM, LARGE)
//           fcolor = 12-bit foreground color value rrrrggggbbbb
//           bcolor = 12-bit background color value rrrrggggbbbb
//
//
//   Returns: nothing
//
//
// Notes: Here's an example to display "E" at address (20,20)
//
// LCDPutChar('E', 20, 20, MEDIUM, WHITE, BLACK);
//
// (27,20)   (27,27)
// |               |
// |               |
// ^ V             V
// : _ # # # # # # # 0x7F
// : _ _ # # _ _ _ # 0x31
// : _ _ # # _ # _ _ 0x34
// x _ _ # # # # _ _ 0x3C
// : _ _ # # _ # _ _ 0x34
// : _ _ # # _ _ _ # 0x31
// : _ # # # # # # # 0x7F
// : _ _ _ _ _ _ _ _ 0x00
//
// ------y------->
// ^                 ^
// |                 |
// |                 |
// (20,20)        (20,27)
//
//
// The most efficient way to display a character is to make use of the "wrap-around" feature
// of the Philips PCF8833 LCD controller chip.
//
// Assume that we position the character at (20, 20) that's a (row, col) specification.
// With the row and column address set commands, you can specify an 8x8 box for the SMALL and MEDIUM
// characters or a 16x8 box for the LARGE characters.
//
// LCDCommand(PASET); // set the row drawing limits
// LCDData(20); //
// LCDData(27); // limit rows to (20, 27)
//
// LCDCommand(CASET); // set the column drawing limits
// LCDData(20); //
// LCDData(27); // limit columns to (20,27)
//
// When the algorithm completes col 27, the column address wraps back to 20
// At the same time, the row address increases by one (this is done by the controller)
//
// We walk through each row, two pixels at a time. The purpose is to create three
// data bytes representing these two pixels in the following format (as specified by Philips
// for RGB 4 : 4 : 4 format (see page 62 of PCF8833 controller manual).
//
// Data for pixel 0: RRRRGGGGBBBB
// Data for Pixel 1: RRRRGGGGBBBB
//
// LCDCommand(RAMWR); // start a memory write (96 data bytes to follow)
//
// LCDData(RRRRGGGG); // first pixel, red and green data
// LCDData(BBBBRRRR); // first pixel, blue data; second pixel, red data
// LCDData(GGGGBBBB); // second pixel, green and blue data
// :
// and so on until all pixels displayed!
// :
// LCDCommand(NOP); // this will terminate the RAMWR command
//
//
// Author: James P Lynch July 7, 2007
// *****************************************************************************



void LCDPutChar(char c, int x, int y, int size, int fColor, int bColor) {

// *********************************************************************************
// Font tables for Nokia 6610 LCD Display Driver (PCF8833 Controller)
//
// FONT6x8 - SMALL font (mostly 5x7)
// FONT8x8 - MEDIUM font (8x8 characters, a bit thicker)
// FONT8x16 - LARGE font (8x16 characters, thicker)
//
// Note: ASCII characters 0x00 through 0x1F are not included in these fonts.
// First row of each font contains the number of columns, the
// number of rows and the number of bytes per character.
//
// Author: Jim Parise, James P Lynch July 7, 2007
// *********************************************************************************

  int i,j;
  unsigned int  nCols;
  unsigned int  nRows;
  unsigned int  nBytes;
  unsigned char PixelRow;
  unsigned char Mask;
  unsigned int  Word0;
  unsigned int  Word1;
  unsigned char *pFont;
  unsigned char *pChar;
  unsigned char *FontTable[] = {(unsigned char *)FONT6x8,
                                (unsigned char *)FONT8x8,
                                (unsigned char *)FONT8x16};

  // get pointer to the beginning of the selected font table
  pFont = (unsigned char *)FontTable[size];

  /* get the nColumns, nRows and nBytes */
  //nCols = *pFont;
  nCols  = pgm_read_byte(&*pFont);         // Array Flash
  //nRows = *(pFont + 1);
  nRows  = pgm_read_byte(&*(pFont + 1));   // Array Flash
  //nBytes = *(pFont + 2);
  nBytes = pgm_read_byte(&*(pFont + 2));   // Array Flash

  /* get pointer to the last byte of the desired character */
  //pChar = pFont + (nBytes * (c - 0x1F)) + nBytes - 1;
  pChar = pFont + (nBytes * (c - 0x1F));
  // Row address set (command 0x2B)
  LCDCommand(PASET);
  LCDData(x);
  LCDData(x + nRows - 1);

  // Column address set (command 0x2A)
  LCDCommand(CASET);
  LCDData(y);
  LCDData(y + nCols - 1);

  // WRITE MEMORY
  LCDCommand(RAMWR);
  // loop on each row, working backwards from the bottom to the top
  for (i = nRows - 1; i >= 0; i--) 
  {
    /* copy pixel row from font table and then decrement row */
    //PixelRow = pgm_read_byte(&*pChar--);  // Array Flash
    //PixelRow = *pChar--;
    PixelRow = pgm_read_byte(&*pChar++);  // Array Flash

    // loop on each pixel in the row (left to right)
    // Note: we do two pixels each loop
    Mask = 0x80;
    for (j = 0; j < nCols; j += 2) 
	{
      // if pixel bit set, use foreground color; else use the background color
      // now get the pixel color for two successive pixels
      if ((PixelRow & Mask) == 0)
        Word0 = bColor;
      else
        Word0 = fColor;
      Mask = Mask >> 1;

      if ((PixelRow & Mask) == 0)
        Word1 = bColor;
      else
        Word1 = fColor;
      Mask = Mask >> 1;
      
      // use this information to output three data bytes
      // For some reason, it has to send blue first then green and red
      LCDData((Word0 << 4) | ((Word0 & 0xF0) >> 4));
      LCDData(((Word0 >> 4) & 0xF0) | (Word1 & 0x0F));
      LCDData((Word1 & 0xF0) | (Word1 >> 8));
    }
  }

  // terminate the Write Memory command
  LCDCommand(NOP);
}
// *************************************************************************************************
// LCDPutStr.c
//
// Draws a null-terminates character string at the specified (x,y) address, size and color
//
// Inputs: pString = pointer to character string to be displayed
// x = row address (0 .. 131)
// y = column address (0 .. 131)
// Size = font pitch (SMALL, MEDIUM, LARGE)
// fColor = 12-bit foreground color value rrrrggggbbbb
// bColor = 12-bit background color value rrrrggggbbbb
//
//
// Returns: nothing
//
// Notes: Here's an example to display "Hello World!" at address (20,20)
//
// LCDPutChar("Hello World!", 20, 20, LARGE, WHITE, BLACK);
//
//
// Author: James P Lynch July 7, 2007
// *************************************************************************************************
void LCDPutStr(char *pString, int x, int y, int Size, int fColor, int bColor) {
    // loop until null-terminator is seen
    while (*pString != 0x00) {
      // draw the character
//      LCDPutChar(*pString++, x, y, Size, fColor, bColor);
      LCDPutChar(*pString++, x, y, Size, fColor, bColor);

/*
      // advance the y position
      if (Size == SMALL)
          y = y + 6;
      else if (Size == MEDIUM)
          y = y + 8;
      else
          y = y + 8;

*/
//<MLS> changed the coordinate system to "RIGHT" side up. Needed to adjust code below so characters would not print backwards
      // advance the y position
      if (Size == SMALL)
          y = y - 6;
      else if (Size == MEDIUM)
          y = y - 8;
      else
          y = y - 8;


      // bail out if y exceeds 131
      if (y > 131) break;
      }
}


