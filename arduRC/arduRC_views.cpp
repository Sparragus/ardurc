#include <stdio.h>

#include "arduRC_views.h"
#include "arduRC_templates.h"

void mainView(char *information)
{
    infoTemplate(information);
}

void mainViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen)
{
    basicTemplate(screenTitle, information, prevScreen, nextScreen);
}

void speedView(char *information)
{
    infoTemplate(information);
}


void speedViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen)
{
    basicTemplate(screenTitle, information, prevScreen, nextScreen);
}

void altitudeView(char *information)
{
    infoTemplate(information);
}


void altitudeViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen)
{
    basicTemplate(screenTitle, information, prevScreen, nextScreen);
}

void gpsView(char *information)
{
    infoTemplate(information);
}


void gpsViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen)
{
    basicTemplate(screenTitle, information, prevScreen, nextScreen);
}

void tempView(char *information)
{
    infoTemplate(information);
}


void tempViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen)
{
    basicTemplate(screenTitle, information, prevScreen, nextScreen);
}

void debugView(char *information)
{
    infoTemplate(information);
}

void debugViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen)
{
    basicTemplate(screenTitle, information, prevScreen, nextScreen);
}

