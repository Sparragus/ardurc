// 
// Nokia LCD Shield Arduino Clock Demo  v.9 (6/13/10)
// Using DS1904 iButton real time clock on one-wire bus
// 
// Analog clock source by Jeff Miller
//     Author: Jeff Miller   http://arduinofun.blogspot.com/
//     
//     Copyright 2010 Released under GPLv3 http://www.gnu.org/copyleft/gpl.html
//   
//     This program is free software: you can redistribute it and/or modify
//     it under the terms of the GNU General Public License as published by
//     the Free Software Foundation, either version 3 of the License, or
//     (at your option) any later version.
//    
//     This program is distributed in the hope that it will be useful,
//     but WITHOUT ANY WARRANTY; without even the implied warranty of
//     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//     GNU General Public License for more details: <http://www.gnu.org/licenses/>    
//
// Using Nokia 6100 sample driver code from Sparkfun (Mark Sproul) and ported graphics primitives
// (line, rectangle, circle) and ASCII charachter code from Nokia LCD Tutorial by James P Lynch
// J. Lynch ASCII pointer code ported to Arduino from Gravitech
//


//************************************************************************
//					Nokia Shield
//************************************************************************
//*	Edit History
//*		<MLS>	= Mark Sproul msproul -at- jove.rutgers.edu
//************************************************************************
//*	Apr  2,	2010	<MLS> I received my Color LCD Shield sku: LCD-09363 from sparkfun
//*	Apr  2,	2010	<MLS> The code was written for WinAVR, I modified it to compile under Arduino
//*	Apr  3,	2010	<MLS> Changed LCDSetPixel to make it "RIGHT" side up
//************************************************************************

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>

#include "WProgram.h"



//************************************************************************
//					External Component Libs
//************************************************************************
#include "LCD_driver.h"
#include "nokia_tester.h"

// Define pins


// #define	_ENABLE_DEBUG_

//************************************************************************
//					Main Code
//************************************************************************
void	setup()
{
	Serial.begin(9600);

    // Use RX1/TX1
    Serial1.begin(9600);
    Serial1.println("Initializing");
    
    // Set up ports and pins I/O
	ioinit();
	
    //Initialize the LCD
    LCDInit();
	
}


//************************************************************************
//					Loop
//************************************************************************
void	loop()
{
    while(Serial1.available())
    {
        int inByte = Serial1.read();
        Serial.print(inByte, BYTE);
        Serial1.print(inByte, BYTE);
        delay(1000);
    }
}


//************************************************************************
void ioinit(void)
{
#ifdef _USE_ARDUINO_FOR_NOKIA_

	// do the LCD control lines
	pinMode(CS_PIN,			OUTPUT);
	pinMode(DIO_PIN,		OUTPUT);
	pinMode(SCK_PIN,		OUTPUT);
	pinMode(LCD_RES_PIN,	OUTPUT);

    // Define pins for xBee
    // Not needed. They use RX/TX
#endif
}


void LCD_Print_String(char *some_string)
{
  int coord_x = ROW_LENGTH - ROW_LENGTH;
  int coord_y = COL_HEIGHT-10;
  int Font_Size = LARGE;
  int FG = BLACK;
  int BG = WHITE;
  
  LCDClear(WHITE);
  LCDPutStr(some_string, coord_x, coord_y, Font_Size, FG, BG);
}


int	gWidth	=	ROW_LENGTH;
int	gHeight	=	COL_HEIGHT;

//*******************************************************************************
void	setPixel(int col, int row, RGBColor *rgbColor)
{
int color12bit;

	color12bit	=	(rgbColor->red << 4) & 0x0f00;
	color12bit	+=	(rgbColor->green) & 0x00f0;
	color12bit	+=	(rgbColor->blue >> 4) & 0x000f;
	
	LCDSetPixel(color12bit, col, row);
//	LCDSetPixel(color12bit, row, col);
}

//*******************************************************************************






//*******************************************************************************
void	DisplayRawRGB(uint8_t *rgbData, int xLoc, int yLoc)
{
int			imageWidth, imageHeight;
int			byte1, byte2;
long		dataIndex;
int			ii, jj;
RGBColor	myColor;
int			myXX, myYY;


	dataIndex	=	0;
	byte1		=	pgm_read_byte(rgbData + dataIndex++);
	byte2		=	pgm_read_byte(rgbData + dataIndex++);
	imageWidth	=	(byte1 << 8) + byte2;
	byte1		=	pgm_read_byte(rgbData + dataIndex++);
	byte2		=	pgm_read_byte(rgbData + dataIndex++);
	imageHeight	=	(byte1 << 8) + byte2;

	//*	if x,y are negitive, then center
	myXX	=	xLoc;
	myYY	=	yLoc;
	if (myXX < 0)
	{
		myXX	=	(gWidth - imageWidth) / 2;
	}
	if (myYY < 0)
	{
		myYY	=	(gHeight - imageHeight) / 2;
	}
	if (imageWidth < 100)
	{
		myXX	=	0;
		myYY	=	0;
	}
	for (jj=0; jj<imageHeight; jj++)
	{
		for (ii=0; ii<imageWidth; ii++)
		{
			myColor.green	=	pgm_read_byte(rgbData + dataIndex++);
			myColor.red		=	pgm_read_byte(rgbData + dataIndex++);
			myColor.blue	=	pgm_read_byte(rgbData + dataIndex++);
		
			if (imageWidth < 100)
			{
			short	doubleX, doubleY;
			
				doubleX	=	myXX + (2 * ii);
				doubleY	=	myYY + (2 * jj);
				setPixel(doubleX,		doubleY, &myColor);
				setPixel(doubleX + 1,	doubleY, &myColor);
			
				setPixel(doubleX,		doubleY + 1, &myColor);
				setPixel(doubleX + 1,	doubleY + 1, &myColor);

			}
			else
		
			{
				setPixel((myXX + ii), (myYY + jj), &myColor);
			}
		}
	}
}

