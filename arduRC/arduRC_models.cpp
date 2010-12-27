//#include <stdio.h>
#include <string.h>

#include "arduRC_models.h"
#include "arduRC_views.h"
#include "WProgram.h"


const char END_CHAR = ';';
char buff[128];
char data_byte;
int i;
int j;
char *data;


char screenTitle[128];
char information[128];
char prevScreen[128];
char nextScreen[128];

char* getSerialData(char endChar)
{
    i = 0;

    while (i<128 && Serial3.available())
    {
        data_byte = Serial3.read();

        if(data_byte==endChar)
        {
            buff[i] = 0x00;
            i++;
            break;
        }

        buff[i] = data_byte;
        i++;
    }
    strncpy(information, buff, i);
    //strncat(information, 0x00, 1);

    //Serial.print(information);
    return information;
}

void mainModel(bool updated)
{
	//Updated means to update whole screen. Therefore: updated = TRUE >> update whole screen
	
    if (!updated)
    {
        //data = getSerialData(END_CHAR);
        mainView(data);
    }
    else
    {
        strcpy(screenTitle, "MAIN SCREEN");
        strcpy(information, "ArduRC Team!");
        strcpy(prevScreen, "altitude");
        strcpy(nextScreen, "temp");

        mainViewUpdate(screenTitle, information, prevScreen, nextScreen);
    }
}

void speedModel(bool updated)
{
    //// Request Speed information
    //Serial3.flush();
    //Serial3.print('T');
	//delay(200);

    //if (!updated)
    //{
        //data = getSerialData(',');
        //speedView(data);
		
			
		//Serial.print("T DATA: ");
		//Serial.println(data);
    //}
    //else
    //{
        //strcpy(screenTitle, "SPEED SCREEN");
        //strcpy(information, "ArduRC Team!");
        //strcpy(prevScreen, "main");
        //strcpy(nextScreen, "temp");
        //speedViewUpdate(screenTitle, information, prevScreen, nextScreen);

    //}
}

char* altitudeParse(char *dataX)
{
    i = 0;
    j = 0;

    while(dataX[i] != ',' and i < 128)
    {
        i++;
    }

    i++;
    
    while(dataX[i] != ',' and i < 128 and j < 128)
    {
        buff[j] = dataX[i];
        
        i++;
        j++;
    }
    
    strncpy(information, buff, j);
    strcat(information, "cm");
    //strncat(information, 0x00, 1);

    //Serial.print(information);
    return information;

}

void altitudeModel(bool updated)
{
    // Request Altitude information
    Serial3.flush();
    Serial3.print('T');
    delay(200);

    if (!updated)
    {
        data = getSerialData('\n');
        data = altitudeParse(data);
        tempView(data);
		
		Serial.print("Altitude DATA: ");
		Serial.print(data);
        Serial.println(" cm");
    }
    else
    {
        strcpy(screenTitle, "ALTITUDE");
        strcpy(information, "42 meters");
        strcpy(prevScreen, "temp");
        strcpy(nextScreen, "main");
        altitudeViewUpdate(screenTitle, information, prevScreen, nextScreen);

    }
}



void gpsModel(bool updated)
{
    // Request Speed information
    Serial1.flush();
    Serial1.print('S');

    if (!updated)
    {
        data = getSerialData(END_CHAR);
        gpsView(data);
    }
    else
    {
        strcpy(screenTitle, "GPS");
        strcpy(information, "42\' 35\" 61 N");
        strcpy(prevScreen, "altitude");
        strcpy(nextScreen, "temp");
        gpsViewUpdate(screenTitle, information, prevScreen, nextScreen);

    }
}

void tempModel(bool updated)
{
    // Request Temp information
    Serial3.flush();
    Serial3.print('T');
    delay(200);

    if (!updated)
    {
        data = getSerialData(',');
        strcat(data, " F");
        tempView(data);
		
		Serial.print("T DATA: ");
		Serial.print(data);
        Serial.println(" F");
    }
    else
    {
        strcpy(screenTitle, "TEMPERATURE");
        strcpy(information, "42 C");
        strcpy(prevScreen, "main");
        strcpy(nextScreen, "altitude");
        tempViewUpdate(screenTitle, information, prevScreen, nextScreen);
    }
}



void debugModel(bool updated)
{
    // Request Speed information
    Serial1.flush();
    Serial1.print('S');

    if (!updated)
    {
        data = getSerialData(END_CHAR);
        debugView(data);
    }
    else
    {
        strcpy(screenTitle, "DEBUG SCREEN");
        strcpy(information, "ArduRC Team!");
        strcpy(prevScreen, "speed");
        strcpy(nextScreen, "main");
        debugViewUpdate(screenTitle, information, prevScreen, nextScreen);

    }
}



