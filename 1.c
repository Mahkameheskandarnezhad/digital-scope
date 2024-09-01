#include <mega32.h>
#include "graphics/glcd.h"
#include "font/font5x7.c" 
#include <stdlib.h>
#include <delay.h>
#define ADC_VREF_TYPE 0x00


////////////////////////////////////////////////////////////
unsigned temp(unsigned char adc_input)
{
    ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
    delay_us(10);// Delay needed for the stabilization of the ADC input voltage
    ADCSRA|=0x40;// Start the AD conversion
    while ((ADCSRA & 0x10)==0);// Wait for the AD conversion to complete
    ADCSRA|=0x10;
    return ADCW;
}


void main(void)
{
int i;
    float T0;   
    float T1;
    float zoom,up_down,up_down2,higth,length;
    int x=0;
    
    GLCDINIT_t glcd_init_data;   // Graphic LCD initialization data
    glcd_init_data.font=font5x7; // Specify the current font for displaying text
    glcd_init(&glcd_init_data);
        
    
    // ADC initialization
    // ADC Clock frequency: 250.000 kHz
    // ADC Voltage Reference: AREF pin
    // ADC Auto Trigger Source: None
    ADMUX=ADC_VREF_TYPE & 0xff;
    ADCSRA=0x85;
     glcd_line(0,60,239,60);
     
  glcd_line(111,0,111,150);     
  
     glcd_line(0,0,0,150);      
     glcd_line(239,0,0,0);  
     glcd_line(0,239,239,150);      
     glcd_line(239,0,239,239);       
              
     
              //   glcd_line(7,55,7,65);   
              
                      
         
           glcd_outtextxy(150,110,"VOLTAGE ="); 

          

     
     
    
    while(1)
    {
        up_down=temp(1)*0.0370279659829597-1; 
        up_down2=temp(6)*0.0370279659829597-1; //up_down  
        higth=temp(2)*0.0065279659829597;      //higth
        length=temp(3)*0.0205279659829597;     //length 
        zoom=temp(4)*0.12218963831867;          //ZOOM IN--ZOOM OUT
          i=temp(0);
           i=(i/1023)*5  ;  
           if(i>1){
        
              glcd_outtextxy(210,110,"2.5");            }     
        
        T0=temp(0);     
        T1=temp(5);
        T0=(higth*T0*0.004887585532746823)*5+up_down*4;      
            T1=(higth*T1*0.004887585532746823)*5+up_down2*4;   
         
          
        delay_ms(zoom); 
        glcd_setpixel(length*x,150-T0); //ÇÖÇÝå ˜ÑÏä äÞØå ÏÑãÎÊÕÇÊ ÏáÎæÇå           
         glcd_setpixel(length*x,150-T1); //ÇÖÇÝå ˜ÑÏä äÞØå ÏÑãÎÊÕÇÊ ÏáÎæÇå 
        x++;
        
        if(x*length>=240){x=0;
        glcd_clear();  
           glcd_line(0,60,239,60);  
           glcd_line(111,0,111,150);
              glcd_line(0,0,0,150);      
     glcd_line(239,0,0,0);  
     glcd_line(0,239,239,150);      
     glcd_line(239,0,239,239); 
       glcd_outtextxy(150,110,"VOLTAGE ="); 
        }
    }
    
       
}
