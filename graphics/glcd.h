//*****************************************************************************
// Library functions for graphic LCDs
// (C) 2010-2011 Pavel Haiduc, HP InfoTech s.r.l., All rights reserved
//
// Compiler: CodeVisionAVR V2.05.2+
//*****************************************************************************

#ifndef _GLCD_INCLUDED_
#define _GLCD_INCLUDED_

#if defined _GLCD_CTRL_KS0108_
#include <glcd_ks0108.h>
#elif defined _GLCD_CTRL_SED1520_
#include <glcd_sed1520.h> 
#elif defined _GLCD_CTRL_SED1335_
#include <glcd_sed1335.h>
#elif defined _GLCD_CTRL_S1D13700_
#include <glcd_s1d13700.h>
#elif defined _GLCD_CTRL_T6963_
#include <glcd_t6963.h>
#elif defined _GLCD_CTRL_PCD8544_
#include <glcd_pcd8544.h>
#else
#error No graphic controller specified in the project configuration
#endif

#include <graphics.h>
#include <glcd_types.h>

#ifndef NULL
#define NULL 0
#endif

#endif
