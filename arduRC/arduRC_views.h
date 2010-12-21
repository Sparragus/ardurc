/*
 *File: arduRC_views.h
 *Author: Richard B. Kaufman-Lopez <richardbkaufman@gmail.com>
 *
 *Description: Uses a template, or creates its own, and then sends the graphics to
 *the LCD.
 */

///////////////////////////////////////////////////////////////////////////////
// General Functions
// 
// For each STATE, there is a model.
///////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C" {
#endif

void mainView(char *information);
void mainViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen);

void speedView(char *information);
void speedViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen);

void altitudeView(char *information);
void altitudeViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen);

void gpsView(char *information);
void gpsViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen);

void tempView(char *information);
void tempViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen);

void debugView(char *information);
void debugViewUpdate(char *screenTitle, char *information, char *prevScreen, char *nextScreen);

#ifdef __cplusplus
}
#endif
