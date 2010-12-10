/*
 *File: arduRC_controller.c
 *Author: Richard B. Kaufman-Lopez <richardbkaufman@gmail.com>
 *
 *Description: Handles different states of the arduRC.
 */
#include "arduRC_states.h"
#include "arduRC_models.h"

///////////////////////////////////////////////////////////////////////////////
// General Functions
//
// There should be one function for every state in the system
///////////////////////////////////////////////////////////////////////////////

void controller(int state)
{
    switch (state) {
      case MAIN:
        // statements
        break;

      case SPEED:
        speedModel();
        break;

      case ALTITUDE:
        // statements
        break;

      case GPS:
        // statements
        break;

      case TEMP:
        // statements
        break;

      case DEBUG:
        debugModel();
        break;

      default: 
        // statements
        break;
    }
}
