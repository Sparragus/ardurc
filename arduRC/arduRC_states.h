/*
 *File: arduRC_statesh
 *Author: Richard B. Kaufman-Lopez <richardbkaufman@gmail.com>
 *
 *Description: All the states the system can have.
 */

///////////////////////////////////////////////////////////////////////////////
// State definitions.
//
// These states help navigate across the system.
///////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C" {
#endif

#define MAIN 0
#define SPEED 1
#define ALTITUDE 2
#define GPS 3
#define TEMP 4

#define DEBUG 99

#ifdef __cplusplus
}
#endif

