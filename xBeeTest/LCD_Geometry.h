#ifdef __cplusplus
extern "C" {
#endif
//********************************************************************
//
//				General Function Definitions
//
//********************************************************************
void LCDSetPixel(int color, unsigned char x, unsigned char y);
void LCDSetLine(int x0, int y0, int x1, int y1, int color);
void LCDSetRect(int x0, int y0, int x1, int y1, unsigned char fill, int color);
void LCDSetCircle(int x0, int y0, int radius, int color);

#ifdef __cplusplus
}
#endif

