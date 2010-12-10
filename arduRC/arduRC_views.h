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

void mainView();
void speedView();
void altitudeView();
void gpsView();
void tempView();

void debugView(char *screenTitle, char *information, char *prevScreen, char *nextScreen);

#ifdef __cplusplus
}
#endif
