#include <stdio.h>
#include <string.h>

#include "arduRC_templates.h"
#include "LCD_Geometry.h"
#include "LCD_Driver.h"
#include "WProgram.h"

void basicTemplate(char *screenTitle, char *information, char *prevScreen, char *nextScreen)
{
    LCDClear(WHITE);
    // Header
    //// Screen Title
    ////// Top Bar
    LCDSetRect(0, 0, COL_HEIGHT-1, 25, FILL, RED);

    ////// Screen Title - Centered over the Top Bar
    int centerX = COL_HEIGHT/2;
    int centerY = 25/4;
    LCDPutStr(screenTitle, centerX - strlen(screenTitle)/2*8+2, centerY, LARGE, WHITE, RED);

    //Information
    centerX = ROW_LENGTH/2;
    centerY = COL_HEIGHT/2;
    LCDPutStr(information, centerX - strlen(information)/2*8, centerY - 8, LARGE, WHITE, RED);


    // Footer
    //// Navigation Bar
    ////// Bottom Bar
    LCDSetRect(0, COL_HEIGHT-20-1, ROW_LENGTH-1, 20, FILL, RED);

    //////// Previous Screen String
    centerX = ROW_LENGTH/4;
    centerY = COL_HEIGHT - (20 - 20/4);
    LCDPutStr(prevScreen, centerX - strlen(prevScreen)/2*8+2, centerY, MEDIUM, WHITE, RED);

    //////// Divider
    LCDSetRect(ROW_LENGTH/2 - 5, COL_HEIGHT-20-1, 10, 20, FILL, BLACK);

    //////// Next Screen String
    centerX = ROW_LENGTH/4 + ROW_LENGTH/2;
    centerY = COL_HEIGHT - (20 - 20/4);
    LCDPutStr(nextScreen, centerX - strlen(nextScreen)/2*8+2, centerY, MEDIUM, WHITE, RED);

    //delay(500);
}

void infoTemplate(char *information)
{
    int centerX = ROW_LENGTH/2;
    int centerY = COL_HEIGHT/2;

    //Clear previous information
    LCDSetRect(0, centerY - 9, ROW_LENGTH-1, 2*9, FILL, WHITE);
    //Information
    LCDPutStr(information, centerX - strlen(information)/2*8, centerY - 8, LARGE, WHITE, RED);
    delay(200);
}
