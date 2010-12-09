#include "LCD_Driver.h"
#include "LCD_Pins.h"
#include "LCD_Geometry.h"

#define __DEBUG

void setup()
{
    Serial.begin(9600);
    Serial.println("Initialized Serial0!");

    Serial1.begin(9600);
    Serial1.println("Initialized Serial1!");

    // Initializes IO pins
    ioInit();

    // Init LCD
    LCDInit();
    LCDClear(WHITE);

    #ifdef __DEBUG

        //char someString[] = "another string!";
        //printString(someString, 10, 10);

        //SetPixel - OKAY
        LCDSetPixel(RED, ROW_LENGTH/2, COL_HEIGHT/2 - 10); // North
        LCDSetPixel(RED, ROW_LENGTH/2 + 10, COL_HEIGHT/2); // East
        LCDSetPixel(RED, ROW_LENGTH/2, COL_HEIGHT/2 + 10); // South
        LCDSetPixel(RED, ROW_LENGTH/2 - 10, COL_HEIGHT/2); // West
    
        //SetLine - OKAY
        LCDSetLine(ROW_LENGTH/2 - 15, COL_HEIGHT/2 - 15, ROW_LENGTH/2 + 15, COL_HEIGHT/2 + 15, BLACK);
        LCDSetLine(ROW_LENGTH/2 + 15, COL_HEIGHT/2 - 15, ROW_LENGTH/2 - 15, COL_HEIGHT/2 + 15, RED);
        
        //SetRect, NOFILL - OKAY
        LCDSetRect(ROW_LENGTH/2 - 20, COL_HEIGHT/2 - 20, 20*2, 20*2, NOFILL, ORANGE);
        
        //SetRect, FILL - OKAY
        LCDSetRect(ROW_LENGTH/2 - 5, COL_HEIGHT/2 - 35, 5*2, 5*2, FILL, GREEN);
        LCDSetRect(ROW_LENGTH/2 + 25, COL_HEIGHT/2 - 5, 5*2, 5*2, FILL, BLUE);
        LCDSetRect(ROW_LENGTH/2 - 5, COL_HEIGHT/2 + 25, 5*2, 5*2, FILL, YELLOW);
        LCDSetRect(ROW_LENGTH/2 - 35, COL_HEIGHT/2 - 5, 5*2, 5*2, FILL, RED);

        
        // PutChar - OKAY
        // * should be on the right
        LCDPutChar('*', ROW_LENGTH - 5*8, COL_HEIGHT - 16*2, LARGE, BLACK, WHITE);
        // # should be on the left
        LCDPutChar('#', 2 + 4*8 - 1*8, COL_HEIGHT - 16*2, LARGE, BLACK, WHITE);

        // PutStr - OKAY
        LCDPutStr("RIGHT", ROW_LENGTH - 5*8, COL_HEIGHT - 16, LARGE, BLACK, WHITE);
        LCDPutStr("LEFT", 2, COL_HEIGHT - 16, LARGE, BLACK, WHITE);
    #endif
}

void loop()
{

}

void ioInit()
{
    #ifdef _USE_ARDUINO_FOR_NOKIA_
        // IOInit the LCD control lines
        pinMode(CS_PIN,			OUTPUT);
        pinMode(DIO_PIN,		OUTPUT);
        pinMode(SCK_PIN,		OUTPUT);
        pinMode(LCD_RES_PIN,	OUTPUT);
    #endif

    //No need to define pins for xBee. It uses RX/TX
}

void printString(char* s, int coord_x, int coord_y)
{
  //int coord_x = ROW_LENGTH - ROW_LENGTH;
  //int coord_y = COL_HEIGHT-10;
  int Font_Size = LARGE;
  int FG = BLACK;
  int BG = WHITE;

  
  LCDClear(WHITE);
  LCDPutStr(s, coord_x, coord_y, Font_Size, FG, BG);
}

void pingPong()
{
    while(Serial1.available())
        {
            char inByte = Serial1.read();
            char* inByteAddr = &inByte;
            //printString(inByteAddr);
            delay(1000);
            Serial.print(inByte, BYTE);
            //Serial1.print(inByte, BYTE);
        }
}
