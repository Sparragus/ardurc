/*
 *File: arduRC_controller.c
 *Author: Richard B. Kaufman-Lopez <richardbkaufman@gmail.com>
 *
 *Description: Handles different states of the arduRC.
 */
#include "arduRC_controller.h"
#include "arduRC_states.h"
#include "arduRC_models.h"

///////////////////////////////////////////////////////////////////////////////
// General Functions
//
// There should be one function for every state in the system
///////////////////////////////////////////////////////////////////////////////

void controller(int state, bool updated)
{
    switch (state) {
      case MAIN:
        mainModel(updated);
        break;

      case SPEED:
        speedModel(updated);
        break;

      case ALTITUDE:
        altitudeModel(updated);
        break;

      case GPS:
        gpsModel(updated);
        break;

      case TEMP:
        tempModel(updated);
        break;

      case DEBUG:
        debugModel(updated);
        break;

      default: 
        debugModel(updated);
        break;
    }
}
