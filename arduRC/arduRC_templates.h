/*
 *File: arduRC_templates.h
 *Author: Richard B. Kaufman-Lopez <richardbkaufman@gmail.com>
 *
 *Description: Templates for use with the views
 */

///////////////////////////////////////////////////////////////////////////////
// General Functions
// 
// For each STATE, there is a model.
///////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C" {
#endif
        //int stringSize(char* string);
        void basicTemplate(char *screenTitle, char *information, char *prevScreen, char *nextScreen);

#ifdef __cplusplus
}
#endif

