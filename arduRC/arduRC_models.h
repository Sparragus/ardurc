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

void mainModel(bool updated);
void speedModel(bool updated);
void altitudeModel(bool updated);
void gpsModel(bool updated);
void tempModel(bool updated);

void debugModel(bool updated);

#ifdef __cplusplus
}
#endif

