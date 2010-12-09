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


        int sizeX = 42;
        int sizeY = 42;

        // SetPixel - OKAY
        LCDSetPixel(RED, 100, 10);
        
        // SetLine - OKAY
        LCDSetLine(10, 10, sizeX, sizeY, RED);
        
        // SetRect, NOFILL - OKAY
        LCDSetRect(10, 10 , sizeX, sizeY, NOFILL, RED);
        
        // SetRect, FILL - WRONG
        LCDSetRect(10, 10 , sizeX, sizeY, FILL, RED);

        // PutStr - WRONG
        LCDPutStr("RIGHT", 10, ENDCOL - 10, LARGE, BLACK, WHITE);
        LCDPutStr("LEFT", 10, 10, LARGE, BLACK, WHITE);
        
        // PutChar - WRONG
        LCDPutChar('#', 60, 10, LARGE, BLACK, WHITE);
        LCDPutChar('*', 60, 110, LARGE, BLACK, WHITE);
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
