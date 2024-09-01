//*****************************************************************************
// Library functions for graphic LCDs with the Toshiba T6963 controller
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
// 06072011_2 Added GLCD_CLEARBLOCK and GLCD_SETBLOCK modes to the 
//            glcd_block function.
//            These are required by the modified glcd_putchar function from
//            graphics.h
//*****************************************************************************

#ifndef _GLCD_T6963_INCLUDED_
#define _GLCD_T6963_INCLUDED_

#include <glcd_types.h>

// T6963 commands
#define T6963_SET_CURSOR_PTR 0x21 // Set cursor pointer
#define T6963_SET_OFFS_REG 0x22 // Set offset register
#define T6963_SET_ADDR_PTR 0x24 // Set address pointer

#define T6963_SET_TXT_HOME_ADDR 0x40 // Set text RAM starting address
#define T6963_SET_TXT_AREA 0x41 // Set the number of text columns
#define T6963_SET_GFX_HOME_ADDR 0x42 // Set graphics RAM starting address
#define T6963_SET_GFX_AREA 0x43 // Set the number of columns for graphic mode

#define T6963_SET_MODE_OR 0x80
#define T6963_SET_MODE_XOR 0x81
#define T6963_SET_MODE_AND 0x83
#define T6963_SET_MODE_TXT_ATTR 0x84 // Set text attributes
#define T6963_SET_MODE_INTCG 0x80 // Use internal character generator 
#define T6963_SET_MODE_EXTCG 0x88 // Use external character generator 

#define T6963_DISPLAY_OFF 0x90 // Display off
#define T6963_CURSORON_BLINKOFF 0x92 // Cusror on, blink off
#define T6963_CURSORON_BLINKON 0x93 // Cusror on, blink on
#define T6963_TXTON_GFXOFF 0x94 // Text on, graphics off
#define T6963_TXTOFF_GFXON 0x98 // Text off, graphics on
#define T6963_TXTON_GFXON 0x9C // Text on, graphics on

#define T6963_CURSOR_1LINE 0xA0 // Selects 1 line cursor
#define T6963_CURSOR_2LINE 0xA1 // Selects 2 lines cursor
#define T6963_CURSOR_3LINE 0xA2 // Selects 3 lines cursor
#define T6963_CURSOR_4LINE 0xA3 // Selects 4 lines cursor
#define T6963_CURSOR_5LINE 0xA4 // Selects 5 lines cursor
#define T6963_CURSOR_6LINE 0xA5 // Selects 6 lines cursor
#define T6963_CURSOR_7LINE 0xA6 // Selects 7 lines cursor
#define T6963_CURSOR_8LINE 0xA7 // Selects 8 lines cursor

#define T6963_DATA_AUTO_WR 0xB0 // Data auto write
#define T6963_DATA_AUTO_RD 0xB1 // Data auto read
#define T6963_AUTO_RESET 0xB2 // Use to exit from auto mode

#define T6963_DATA_WR_INC 0xC0 // Write data and increment ADP
#define T6963_DATA_RD_INC 0xC1 // Read data and increment ADP
#define T6963_DATA_WR 0xC4 // Write data without modifying ADP
#define T6963_DATA_RD 0xC5 // Read data without modifying ADP

#define T6963_SCREEN_PEEK 0xE0 // Transfers 1 byte of displayed data to the data stack
#define T6963_SCREEN_COPY 0xE8 // Copies a single raster line of data to the graphic area

// T6963 initialization parameters
#define T6963_PIXELS_COLUMN _GLCD_INTERNAL_FONT_WIDTH_ // # of pixels/graphic column

#if ((_GLCD_MAXX_%T6963_PIXELS_COLUMN)!=0)
#define T6963_BYTES_ROW (_GLCD_MAXX_/T6963_PIXELS_COLUMN+1)
#else
#define T6963_BYTES_ROW (_GLCD_MAXX_/T6963_PIXELS_COLUMN)
#endif

#define T6963_TXT_HOME 0 // start address of text RAM
#define T6963_TXT_AREA (_GLCD_MAXX_/_GLCD_INTERNAL_FONT_WIDTH_) // # of columns in text mode
#define T6963_TXT_SIZE (T6963_BYTES_ROW*(_GLCD_MAXY_/_GLCD_INTERNAL_FONT_HEIGHT_)) 
#define T6963_GFX_HOME (T6963_TXT_HOME+T6963_TXT_SIZE) // start address of graphics RAM
#define T6963_GFX_AREA (_GLCD_MAXX_/T6963_PIXELS_COLUMN) // # of columns in graphics mode
#define T6963_GFX_SIZE (T6963_BYTES_ROW*_GLCD_MAXY_) // size of graphics RAM area
#define T6963_OFFS_REG (((T6963_TXT_HOME+T6963_TXT_SIZE+T6963_GFX_SIZE)>>11)+1)
#define T6963_EXTCG_HOME ((T6963_OFFS_REG<<11)+0x80*_GLCD_INTERNAL_FONT_HEIGHT_) // starting RAM address of the external character generator

// structure that contains controller specific graphic LCD initialization data
typedef struct 
        {
        flash unsigned char *font; // default font after initialization
        // pointer to the function used for reading a byte from external memory
        unsigned char (*readxmem) (GLCDMEMADDR_t addr); 
        // pointer to the function used for writing a byte to external memory
        void (*writexmem) (GLCDMEMADDR_t addr, unsigned char data); 
        } GLCDINIT_t;

// Sets C /D=1 and reads the T6963 status byte.
unsigned char t6963_rdstatus(void);
// Waits for the T6963 controller to become ready for reading or writing data
// by polling the STA0 and STA1 flags.
// Also sets C /D=1.
void t6963_busy(void);
// Writes a command to the T6963 controller.
void t6963_wrcmd(unsigned char cmd);
// Writes data to the T6963 controller.
void t6963_wrdata(unsigned char data);
// Reads data from the T6963 controller.
unsigned char t6963_rddata(void);
        
// Initializes the graphic controller and clears the LCD.
bool glcd_init(GLCDINIT_t *init_data);
// Turns LCD on/off.
void glcd_display(bool on);
// Clears the LCD by setting it's color to the background color.
void glcd_clear(void);
// Clears the text area when the internal character generator is used.
void glcd_cleartext(void);
// Clears the graphics area by setting it's color to the background color.
void glcd_cleargraphics(void);
// Sets the color of the pixel at coordinates x, y.
void glcd_putpixel(GLCDX_t x, GLCDY_t y, GLCDCOL_t color);
// Returns the color of the pixel at coordinates x, y.
GLCDCOL_t glcd_getpixel(GLCDX_t x, GLCDY_t y);

// Displays an ASCII character at the col, row character positions using the
// Character Generator
void glcd_putcharcg(unsigned char col,unsigned char row,unsigned char c);
// Defines a character in the Character Generator external RAM.
// c>=0x80
void glcd_definechar(unsigned char c,flash unsigned char *data);

// Writes/reads a block of bytes as a bitmap image
// at/from specified coordinates.
void glcd_block(GLCDX_t left, GLCDY_t top, GLCDX_t width, GLCDY_t height,
     GLCDMEM_t memt, GLCDMEMADDR_t addr, GLCDBLOCKMODE_t mode);

#pragma library glcd_t6963.lib

#endif




