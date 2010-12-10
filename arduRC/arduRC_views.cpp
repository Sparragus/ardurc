#include <stdio.h>

#include "arduRC_views.h"
#include "arduRC_templates.h"

void mainView(char *screenTitle, char *information, char *prevScreen, char *nextScreen)
{
    basicTemplate(screenTitle, information, prevScreen, nextScreen);
}

void speedView(char *screenTitle, char *information, char *prevScreen, char *nextScreen)
{
    basicTemplate(screenTitle, information, prevScreen, nextScreen);
}
void altitudeView()
{

}

void gpsView()
{

}

void tempView()
{

}

void debugView(char *screenTitle, char *information, char *prevScreen, char *nextScreen)
{
    basicTemplate(screenTitle, information, prevScreen, nextScreen);
}

/* 
 * Templates
 */

