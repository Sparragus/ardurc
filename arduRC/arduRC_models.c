#include "arduRC_models.h"

void mainModel()
{

}

void speedModel()
{
    // Do calculations to get speed

    speedView(/* Each of the speed varialbles that will be displayed */);
}

void altitudeModel()
{
    
}

void gpsModel()
{
    
}

void tempModel()
{
    
}

void debugModel()
{
    char screenTitle[] = "Screen Title";
    char information[] = "Information";
    char prevScreen[] = "prev";
    char nextScreen[] = "next";
    debugView(screenTitle, information, prevScreen, nextScreen);
}
