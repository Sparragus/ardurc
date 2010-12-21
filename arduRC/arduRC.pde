#hello (:

#include "LCD_Driver.h"
#include "LCD_Pins.h"
#include "LCD_Geometry.h"

#include "arduRC_states.h"
#include "arduRC_controller.h"

#define __DEBUG 

#define BUTTON_LEFT 21
#define BUTTON_RIGHT 20

const int LEFT = 0;
const int RIGHT = 1;

#ifdef __DEBUG
    int states[] = {MAIN, SPEED, DEBUG};
#else
    int states[] = {MAIN, SPEED, ALTITUDE, GPS, TEMP, DEBUG};
#endif

int statesLen = sizeof(states)/sizeof(int);
int currentState = states[0];
int oldState = currentState; 
int currentStatePos = 0;

void setup()
{
    Serial.begin(9600);
    Serial.println("Initialized Serial0!");

    Serial1.begin(115200);
    Serial1.println("Initialized Serial1!");

    // Initializes IO pins
    ioInit();

    // Init LCD
    LCDInit();
    LCDClear(WHITE);

#ifdef __DEBUG
    //char someString[] = "another string!";
    //printString(someString, 10, 10);

    Serial.println("Screen test: Started!");

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

    Serial.println("Screen test: Finished!");
    delay(500);

    //Serial.println("MVC test: Started!");
    //currentState = DEBUG;
    //controller(currentState);
    //Serial.println("MVC test: Finished!");


#endif
}

void loop()
{
    if (stateChanged())
    {
        controller(currentState, true);
    }
    else
    {
        controller(currentState, false);
    }
}

void batteryStatus()
{
// Code goes here!!!
}

void signalStatus()
{
// Code goes here!!!
}

bool stateChanged()
{
    if (oldState == currentState)
    {
        return false;
    }
    oldState = currentState;
    return true;
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

    //Ports for ISR for Buttons
    //Pins 2-3, 18-21
    pinMode(BUTTON_LEFT, INPUT);
    digitalWrite(BUTTON_LEFT, HIGH);
    attachInterrupt(2, buttonLeft, FALLING);
    pinMode(BUTTON_RIGHT, INPUT);
    digitalWrite(BUTTON_RIGHT, HIGH);
    attachInterrupt(3, buttonRight, FALLING);
}

void stateManager(int dir)
{
    if(dir == LEFT)
    {
        if(currentState == states[0])
        {
            currentStatePos = statesLen - 1;
            currentState = states[currentStatePos];

        }
        else
        {
            currentStatePos--;
            currentState = states[currentStatePos];
        }
    }
    else if(dir == RIGHT)
    {
        if(currentState == states[statesLen - 1])
        {
            currentStatePos = 0;
            currentState = states[currentStatePos];
        }
        else
        {
            currentStatePos++;
            currentState = states[currentStatePos];
        }
    }
}

void buttonLeft()
{
    static unsigned long last_millis = 0;
    unsigned long m = millis();
    if (m - last_millis < 200)
    {

    }
    else{
        last_millis = m;
        stateManager(LEFT);
    }
}

void buttonRight()
{
    static unsigned long last_millis = 0;
    unsigned long m = millis();
    if (m - last_millis < 200)
    {

    }
    else{
        last_millis = m;
        stateManager(RIGHT);
    }
}
