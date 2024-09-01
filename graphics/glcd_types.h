//*****************************************************************************
// Predefined data types for Graphic LCD library
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
//            GLCDBLOCKMODE_t enumeration type.
//            These are required by the modified glcd_putchar and glcd_block
//            functions.
//*****************************************************************************

#ifndef _GLCD_TYPES_INCLUDED_
#define _GLCD_TYPES_INCLUDED_

#include <stdbool.h>

#if _GLCD_MAXX_<=256
typedef unsigned char GLCDX_t;
#elif _GLCD_MAXX_<=65536
typedef unsigned short GLCDX_t;
#else
#error X resolution not supported by the Graphic LCD library 
#endif

#if _GLCD_MAXY_<=256
typedef unsigned char GLCDY_t;
#elif _GLCD_MAXY_<=65536
typedef unsigned short GLCDY_t;
#else
#error Y resolution not supported by the Graphic LCD library 
#endif

typedef short GLCDDX_t;
typedef short GLCDDY_t;

#if _GLCD_COLOR_BITS_<=8
typedef unsigned char GLCDCOL_t;
#elif _GLCD_COLOR_BITS_<=16
typedef unsigned short GLCDCOL_t;
#else
typedef unsigned long GLCDCOL_t;
#endif

// highest color value for a pixel in ON state
#define _GLCD_MAXCOLOR_ ((1UL<<_GLCD_COLOR_BITS_)-1UL)

// glcd_block write/read modes
typedef enum
        {
        GLCD_PUTCOPY,
        GLCD_PUTXOR,
        GLCD_PUTOR,
        GLCD_PUTNOT,
        GLCD_PUTAND,
        GLCD_GET, // used for reading a block of data from specified coordinates
        GLCD_PUTCHAR, // used internally by the glcd_putchar function
        GLCD_PUTFILL, // used internally by the rectangular area fill function
        GLCD_CLEARBLOCK, // used internally by the rectangular area clear function, 06072011_2
        GLCD_SETBLOCK, // used internally by the rectangular area set function, 06072011_2
        } GLCDBLOCKMODE_t;

// Text displaying parameters
typedef struct
        {
        flash unsigned char *font; // current font
        unsigned char horiz; // horizontal justification in pixels
        unsigned char vert; // vertical justification in pixels
        } GLCDTEXT_t;

// Line bit patterns
#define GLCD_LINE_SOLID 0xff
#define GLCD_LINE_DOT_SMALL 0x55
#define GLCD_LINE_DOT_LARGE 0x33
        
// Line style displaying parameters
typedef struct
        {
        unsigned char thick; // line thickness
        unsigned char pattern; // bit pattern
        } GLCDLINE_t;

// Fill pattern width in pixels
#define _GLCD_FILL_PATTERN_WIDTH_ 8

// Fill style
typedef struct
        {
        GLCDCOL_t color; // fill color
        // bit pattern for filling a rectangular area
        unsigned char pattern[_GLCD_FILL_PATTERN_WIDTH_]; 
        } GLCDFILL_t;

// Arc coordinates
typedef struct
        {
        GLCDX_t x; // arc x center coordinate
        GLCDY_t y; // arc y center coordinate
        GLCDX_t xstart; // arc start x coordinate
        GLCDY_t ystart; // arc start y coordinate
        GLCDX_t xend; // arc end x coordinate
        GLCDY_t yend; // arc end y coordinate
        } GLCDARCCOORDS_t;
                
// Smallest type that can hold the address of the FLASH or external memory
#if defined(_MODEL_MEDIUM_) || defined(_MODEL_LARGE_)
typedef unsigned long GLCDMEMADDR_t;
#else
typedef unsigned short GLCDMEMADDR_t;
#endif

// Graphic display state        
typedef struct
        {
        GLCDCOL_t fgcolor; // foreground color
        GLCDCOL_t bkcolor; // background color
        GLCDX_t cx; // current x horizontal coordinate
        GLCDY_t cy; // current y vertical coordinate
        GLCDTEXT_t text; // current text display settings
        GLCDLINE_t line; // current line display settings
        GLCDARCCOORDS_t arc; // coordinates of last displayed arc
        GLCDFILL_t fill; // current fill display settings
        // pointer to the function used for reading a byte from external memory
        unsigned char (*readxmem) (GLCDMEMADDR_t addr); 
        // pointer to the function used for writing a byte to external memory
        void (*writexmem) (GLCDMEMADDR_t addr, unsigned char data); 
        } GLCDSTATE_t;

// Memory types for block put & get functions
typedef enum
        {
        GLCD_MEM_RAM,
        GLCD_MEM_FLASH,
        GLCD_MEM_EEPROM,
        GLCD_MEM_EXT // external memory accessed using special functions
        } GLCDMEM_t;

// Polygon points coordinates
typedef struct
        {
        GLCDX_t x;
        GLCDY_t y;
        } GLCDPOINT_t;
                
#endif
