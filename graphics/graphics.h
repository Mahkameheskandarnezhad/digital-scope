//*****************************************************************************
// Library functions for graphic LCDs
// (C) 2010-2011 Pavel Haiduc, HP InfoTech s.r.l., All rights reserved
//
// Compiler: CodeVisionAVR V2.05.3+
// Version: 1.01
//*****************************************************************************

//*****************************************************************************
// Revision history:
// 
// V1.00      Initial release.
// 
// V1.01
// 06072011_2 Modified the glcd_putchar function so that it fills the spaces
//            between the characters with the background color.
//            Added the GLCD_CLEARBLOCK and GLCD_SETBLOCK modes to the 
//            glcd_block function for this purpose.
//*****************************************************************************

#ifndef _GRAPHICS_INCLUDED_
#define _GRAPHICS_INCLUDED_

#include <glcd.h>

extern GLCDSTATE_t glcd_state;

// Initializes the graphic controller and clears the LCD.        
bool glcd_init(GLCDINIT_t *init_data);
// Turns LCD on/off.
void glcd_display(bool on);

// Sets the display's foreground color.
#define glcd_setcolor(foreground_color) {glcd_state.fgcolor=(foreground_color);}
// Sets the display's background color.
#define glcd_setbkcolor(background_color) {glcd_state.bkcolor=(background_color);}
// Returns the display's foreground color.
#define glcd_getcolor() glcd_state.fgcolor
// Returns the display's background color.
#define glcd_getbkcolor() glcd_state.bkcolor
// Returns the maximum supported color.
#define glcd_getmaxcolor() _GLCD_MAXCOLOR_
// Returns the maximum X horizontal coordinate value.
#define glcd_getmaxx() (_GLCD_MAXX_-1)
// Returns the maximum Y vertical coordinate value.
#define glcd_getmaxy() (_GLCD_MAXY_-1)

// Clears the LCD by setting it's color to the background color.
void glcd_clear(void);

#if _GLCD_INTERNAL_FONT_WIDTH_>0
// Clears the text area when the internal character generator is used.
void glcd_cleartext(void);
// Clears the graphics area by setting it's color to the background color.
void glcd_cleargraphics(void);
// Defines a character in the Character Generator external RAM, c>=0x80.
void glcd_definechar(unsigned char c,flash unsigned char *data);
#else
#define glcd_cleargraphics() glcd_clear()
#endif

// Sets the color of the pixel at coordinates x, y. 
void glcd_putpixel(GLCDX_t x, GLCDY_t y, GLCDCOL_t color);
// Sets the pixel at coordinates x, y to the foreground color.
void glcd_setpixel(GLCDX_t x, GLCDY_t y);
// Clears the pixel at coordinates x, y (sets to the background color).
void glcd_clrpixel(GLCDX_t x, GLCDY_t y);
// Returns the color of the pixel at coordinates x, y.
GLCDCOL_t glcd_getpixel(GLCDX_t x, GLCDY_t y);

// Moves the current plot coordinate position to the x, y coordinates.
void glcd_moveto(GLCDX_t x, GLCDY_t y);
// Moves the current plot coordinate position to a new relative position.
void glcd_moverel(GLCDDX_t dx, GLCDDY_t dy);

// Returns the value of the current position x coordinate
#define glcd_getx() glcd_state.cx
// Returns the value of the current position y coordinate
#define glcd_gety() glcd_state.cy

// Selects the current font used for displaying text.
#define glcd_setfont(font_name) {glcd_state.text.font=(flash unsigned char *) font_name;}
// Sets the horizontal and vertical text justification values.
void glcd_settextjustify(unsigned char horiz, unsigned char vert);

// Returns the width of a character for the current font,
// including the horizontal justification.
unsigned char glcd_charwidth(char c);
// Returns the text height for the current font,
// including the vertical justification.
unsigned char glcd_textheight(void);
// Returns the text width of a char string for the current font,
// including the horizontal justification.
GLCDX_t glcd_textwidth(char *str);
// Returns the text width of a char string located in FLASH for the current
// font, including the horizontal justification.
GLCDX_t glcd_textwidthf(flash char *str);
// Returns the text width of a char string located in EEPROM for the current
// font, including the horizontal justification.
GLCDX_t glcd_textwidthe(eeprom char *str);

// Displays an ASCII character at the current x, y position.
void glcd_putchar(char c);
// Displays an ASCII character at the specified x, y coordinates.
void glcd_putcharxy(GLCDX_t x, GLCDY_t y, char c);

// Displays a NULL terminated character string located in RAM
// at the current display position.
void glcd_outtext(char *str);
// Displays a NULL terminated character string located in FLASH
// at the current display position.
void glcd_outtextf(flash char *str);
// Displays a NULL terminated character string located in EEPROM
// at the current display position.
void glcd_outtexte(eeprom char *str);

// Displays a NULL terminated character string located in RAM at the
// specified x, y coordinates.
void glcd_outtextxy(GLCDX_t x, GLCDY_t y, char *str);
// Displays a NULL terminated character string located in FLASH at the
// specified x, y coordinates.
void glcd_outtextxyf(GLCDX_t x, GLCDY_t y, flash char *str);
// Displays a NULL terminated character string located in EEPROM at the
// specified x, y coordinates
void glcd_outtextxye(GLCDX_t x, GLCDY_t y, eeprom char *str);

// Writes/reads a block of bytes as a bitmap image
// at/from specified coordinates.
void glcd_block(GLCDX_t left, GLCDY_t top, GLCDX_t width, GLCDY_t height,
     GLCDMEM_t memt, GLCDMEMADDR_t addr, GLCDBLOCKMODE_t mode);

// Returns the memory size in bytes needed to store a rectangular image.
unsigned long glcd_imagesize(GLCDX_t width, GLCDY_t height);
// Displays an image located in RAM at specified coordinates.
unsigned long glcd_putimage(GLCDX_t left, GLCDY_t top, unsigned char *pimg,
     GLCDBLOCKMODE_t mode);
// Displays an image located in FLASH at specified coordinates.
unsigned long glcd_putimagef(GLCDX_t left, GLCDY_t top, flash unsigned char *pimg,
     GLCDBLOCKMODE_t mode);
// Displays an image located in EEPROM at specified coordinates.
unsigned long glcd_putimagee(GLCDX_t left, GLCDY_t top, eeprom unsigned char *pimg,
     GLCDBLOCKMODE_t mode);
// Displays an image located in external memory at specified coordinates.
unsigned long glcd_putimagex(GLCDX_t left, GLCDY_t top, GLCDMEMADDR_t addr,
     GLCDBLOCKMODE_t mode);
// Saves a rectangular display area to RAM.
unsigned long glcd_getimage(GLCDX_t left, GLCDY_t top, GLCDX_t width, GLCDY_t height,
     unsigned char *pimg);
// Saves a rectangular display area to EEPROM.
unsigned long glcd_getimagee(GLCDX_t left, GLCDY_t top, GLCDX_t width, GLCDY_t height,
     eeprom unsigned char *pimg);
// Saves a rectangular display area to external memory.
unsigned long glcd_getimagex(GLCDX_t left, GLCDY_t top, GLCDX_t width, GLCDY_t height,
     GLCDMEMADDR_t addr);

// Set line displaying style.
#define glcd_setlinestyle(thickness,bit_pattern) \
       {glcd_state.line.thick=(thickness), glcd_state.line.pattern=(bit_pattern);}
// Returns current line width setting.
#define glcd_getlinewidth() glcd_state.line.width
// Returns current line bit pattern setting.
#define glcd_getlinepattern() glcd_state.line.pattern

// Draws a line with the current color, thickness and bit pattern.
void glcd_line(GLCDX_t x0, GLCDY_t y0, GLCDX_t x1, GLCDY_t y1);
// Draws a line from the current plot coordinate position to a new position
// using the current color, thickness and bit pattern.
void glcd_lineto(GLCDX_t x, GLCDY_t y);
// Draws a line from the current plot coordinate position to a new relative position
// using the current color, thickness and bit pattern.
void glcd_linerel(GLCDDX_t dx, GLCDDY_t dy);

// Draws a rectangle using the current line thickness, bit pattern and drawing color.
void glcd_rectangle(GLCDX_t left, GLCDY_t top, GLCDX_t right, GLCDY_t bottom);
// Draws a rectangle using the current line thickness, bit pattern and drawing color.
void glcd_rectrel(GLCDX_t left, GLCDY_t top, GLCDX_t width, GLCDY_t height);
// Draws a rectangle with rounded corners using the current line thickness
// and drawing color.
void glcd_rectround(GLCDX_t left, GLCDY_t top, GLCDX_t width, GLCDY_t height,
     GLCDX_t radius);
// Draws a polygon using the current line thickness, bit pattern and drawing color.
void glcd_drawpoly(unsigned char npoints, flash GLCDPOINT_t *polypoints);

// Draws a circle at specified center coordinates using the current
// color and thickness.
void glcd_circle(GLCDX_t x, GLCDY_t y, GLCDX_t radius);
// Draws an arc of a circle at specified center coordinates using the current
// color and thickness.
// The angles are measured starting from the 3 o'clock counter-clockwise.
void glcd_arc(GLCDX_t x, GLCDY_t y, unsigned short start_angle,
     unsigned short end_angle, GLCDX_t radius);
// Fills in the GLCDARCCOORDS_t structure pointed to by arccoords
// with information about the last call to glcd_arc.
void glcd_getarccoords(GLCDARCCOORDS_t *arccoords);

// Sets an user defined 8x8 pixel fill pattern from RAM and the fill color.
void glcd_setfill(unsigned char *pattern, GLCDCOL_t color);
// Sets an user defined 8x8 pixel fill pattern from FLASH and the fill color.
void glcd_setfillf(flash unsigned char *pattern, GLCDCOL_t color);
// Sets an user defined 8x8 pixel fill pattern from EEPROM and the fill color.
void glcd_setfille(eeprom unsigned char *pattern, GLCDCOL_t color);
// Reads the current 8x8 pixel fill pattern to RAM and the fill color.
void glcd_getfill(unsigned char *pattern, GLCDCOL_t *color);
// Reads the current 8x8 pixel fill pattern to EEPROM and the fill color.
void glcd_getfille(eeprom unsigned char *pattern, GLCDCOL_t *color);

// Draws a filled-in rectangular bar, using absolute coordinates.
// The bar is filled using the current fill pattern and fill color.
// No outline is drawn.
void glcd_bar(GLCDX_t left, GLCDY_t top, GLCDX_t right, GLCDY_t bottom);
// Draws a filled-in rectangular bar., using relative coordinates.
// The bar is filled using the current fill pattern and fill color.
// No outline is drawn.
void glcd_barrel(GLCDX_t left, GLCDY_t top, GLCDX_t width, GLCDY_t height);
// Fills a closed polygon with the current fill color.
void glcd_floodfill(GLCDX_t x, GLCDY_t y, GLCDCOL_t border);
// Draws and fills a circle at specified center coordinates using the current
// fill color.
void glcd_fillcircle(GLCDX_t x, GLCDY_t y, GLCDX_t radius);
// Draws a pie slice at specified center coordinates using the
// current foreground color and line thickness.
// After that the pie slice is filled with the current fill color.
// The angles are measured starting from from 3 o'clock counter-clockwise.
void glcd_pieslice(GLCDX_t x, GLCDY_t y, unsigned short start_angle,
     unsigned short end_angle, GLCDX_t radius);

#pragma library graphics.lib

#endif
