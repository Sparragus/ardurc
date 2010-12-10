/*
 *File: arduRC_models.h
 *Author: Richard B. Kaufman-Lopez <richardbkaufman@gmail.com>
 *
 *Description: Calculates the values needed and then sends it to the view.
 */

///////////////////////////////////////////////////////////////////////////////
// General Functions
// 
// For each STATE, there is a model.
///////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C" {
#endif

void mainModel();
void speedModel();
void altitudeModel();
void gpsModel();
void tempModel();

void debugModel();

#ifdef __cplusplus
}
#endif

