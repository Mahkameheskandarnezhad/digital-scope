
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x4,0x4,0x4,0x4,0x4
	.DB  0x0,0x4,0xA,0xA,0xA,0x0,0x0,0x0
	.DB  0x0,0xA,0xA,0x1F,0xA,0x1F,0xA,0xA
	.DB  0x4,0x1E,0x5,0xE,0x14,0xF,0x4,0x3
	.DB  0x13,0x8,0x4,0x2,0x19,0x18,0x6,0x9
	.DB  0x5,0x2,0x15,0x9,0x16,0x6,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x8,0x4,0x2,0x2
	.DB  0x2,0x4,0x8,0x2,0x4,0x8,0x8,0x8
	.DB  0x4,0x2,0x0,0xA,0x4,0x1F,0x4,0xA
	.DB  0x0,0x0,0x4,0x4,0x1F,0x4,0x4,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x4,0x2,0x0
	.DB  0x0,0x0,0x1F,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x6,0x0,0x0,0x10,0x8
	.DB  0x4,0x2,0x1,0x0,0xE,0x11,0x19,0x15
	.DB  0x13,0x11,0xE,0x4,0x6,0x4,0x4,0x4
	.DB  0x4,0xE,0xE,0x11,0x10,0x8,0x4,0x2
	.DB  0x1F,0x1F,0x8,0x4,0x8,0x10,0x11,0xE
	.DB  0x8,0xC,0xA,0x9,0x1F,0x8,0x8,0x1F
	.DB  0x1,0xF,0x10,0x10,0x11,0xE,0xC,0x2
	.DB  0x1,0xF,0x11,0x11,0xE,0x1F,0x10,0x8
	.DB  0x4,0x2,0x2,0x2,0xE,0x11,0x11,0xE
	.DB  0x11,0x11,0xE,0xE,0x11,0x11,0x1E,0x10
	.DB  0x8,0x6,0x0,0x6,0x6,0x0,0x6,0x6
	.DB  0x0,0x0,0x6,0x6,0x0,0x6,0x4,0x2
	.DB  0x10,0x8,0x4,0x2,0x4,0x8,0x10,0x0
	.DB  0x0,0x1F,0x0,0x1F,0x0,0x0,0x1,0x2
	.DB  0x4,0x8,0x4,0x2,0x1,0xE,0x11,0x10
	.DB  0x8,0x4,0x0,0x4,0xE,0x11,0x10,0x16
	.DB  0x15,0x15,0xE,0xE,0x11,0x11,0x11,0x1F
	.DB  0x11,0x11,0xF,0x11,0x11,0xF,0x11,0x11
	.DB  0xF,0xE,0x11,0x1,0x1,0x1,0x11,0xE
	.DB  0x7,0x9,0x11,0x11,0x11,0x9,0x7,0x1F
	.DB  0x1,0x1,0xF,0x1,0x1,0x1F,0x1F,0x1
	.DB  0x1,0x7,0x1,0x1,0x1,0xE,0x11,0x1
	.DB  0x1,0x19,0x11,0xE,0x11,0x11,0x11,0x1F
	.DB  0x11,0x11,0x11,0xE,0x4,0x4,0x4,0x4
	.DB  0x4,0xE,0x1C,0x8,0x8,0x8,0x8,0x9
	.DB  0x6,0x11,0x9,0x5,0x3,0x5,0x9,0x11
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x1F,0x11
	.DB  0x1B,0x15,0x11,0x11,0x11,0x11,0x11,0x11
	.DB  0x13,0x15,0x19,0x11,0x11,0xE,0x11,0x11
	.DB  0x11,0x11,0x11,0xE,0xF,0x11,0x11,0xF
	.DB  0x1,0x1,0x1,0xE,0x11,0x11,0x11,0x15
	.DB  0x9,0x16,0xF,0x11,0x11,0xF,0x5,0x9
	.DB  0x11,0x1E,0x1,0x1,0xE,0x10,0x10,0xF
	.DB  0x1F,0x4,0x4,0x4,0x4,0x4,0x4,0x11
	.DB  0x11,0x11,0x11,0x11,0x11,0xE,0x11,0x11
	.DB  0x11,0x11,0x11,0xA,0x4,0x11,0x11,0x11
	.DB  0x15,0x15,0x1B,0x11,0x11,0x11,0xA,0x4
	.DB  0xA,0x11,0x11,0x11,0x11,0xA,0x4,0x4
	.DB  0x4,0x4,0x1F,0x10,0x8,0x4,0x2,0x1
	.DB  0x1F,0x1C,0x4,0x4,0x4,0x4,0x4,0x1C
	.DB  0x0,0x1,0x2,0x4,0x8,0x10,0x0,0x7
	.DB  0x4,0x4,0x4,0x4,0x4,0x7,0x4,0xA
	.DB  0x11,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1F,0x2,0x4,0x8,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xE,0x10,0x1E
	.DB  0x11,0x1E,0x1,0x1,0xD,0x13,0x11,0x11
	.DB  0xF,0x0,0x0,0xE,0x1,0x1,0x11,0xE
	.DB  0x10,0x10,0x16,0x19,0x11,0x11,0x1E,0x0
	.DB  0x0,0xE,0x11,0x1F,0x1,0xE,0xC,0x12
	.DB  0x2,0x7,0x2,0x2,0x2,0x0,0x0,0x1E
	.DB  0x11,0x1E,0x10,0xC,0x1,0x1,0xD,0x13
	.DB  0x11,0x11,0x11,0x4,0x0,0x6,0x4,0x4
	.DB  0x4,0xE,0x8,0x0,0xC,0x8,0x8,0x9
	.DB  0x6,0x2,0x2,0x12,0xA,0x6,0xA,0x12
	.DB  0x6,0x4,0x4,0x4,0x4,0x4,0xE,0x0
	.DB  0x0,0xB,0x15,0x15,0x11,0x11,0x0,0x0
	.DB  0xD,0x13,0x11,0x11,0x11,0x0,0x0,0xE
	.DB  0x11,0x11,0x11,0xE,0x0,0x0,0xF,0x11
	.DB  0xF,0x1,0x1,0x0,0x0,0x16,0x19,0x1E
	.DB  0x10,0x10,0x0,0x0,0xD,0x13,0x1,0x1
	.DB  0x1,0x0,0x0,0xE,0x1,0xE,0x10,0xF
	.DB  0x2,0x2,0x7,0x2,0x2,0x12,0xC,0x0
	.DB  0x0,0x11,0x11,0x11,0x19,0x16,0x0,0x0
	.DB  0x11,0x11,0x11,0xA,0x4,0x0,0x0,0x11
	.DB  0x11,0x15,0x15,0xA,0x0,0x0,0x11,0xA
	.DB  0x4,0xA,0x11,0x0,0x0,0x11,0x11,0x1E
	.DB  0x10,0xE,0x0,0x0,0x1F,0x8,0x4,0x2
	.DB  0x1F,0x8,0x4,0x4,0x2,0x4,0x4,0x8
	.DB  0x4,0x4,0x4,0x4,0x4,0x4,0x4,0x2
	.DB  0x4,0x4,0x8,0x4,0x4,0x2,0x2,0x15
	.DB  0x8,0x0,0x0,0x0,0x0,0x1F,0x11,0x11
	.DB  0x11,0x11,0x11,0x1F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

_0x0:
	.DB  0x56,0x4F,0x4C,0x54,0x41,0x47,0x45,0x20
	.DB  0x3D,0x0,0x32,0x2E,0x35,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _0x6
	.DW  _0x0*2

	.DW  0x04
	.DW  _0x6+10
	.DW  _0x0*2+10

	.DW  0x0A
	.DW  _0x6+14
	.DW  _0x0*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "graphics/glcd.h"
;#include "font/font5x7.c"
;/**********************************************************
;Font generated by the LCD Vision V1.00 font editor
;(C) Copyright 2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Font name: font5x7
;Fixed font width: 5 pixels
;Font height: 7 pixels
;First character: 0x20
;Last character: 0x7F
;**********************************************************/
;
;flash unsigned char font5x7[]=
;{
;0x05, /* Fixed font width */
;0x07, /* Font height */
;0x20, /* First character */
;0x60, /* Number of characters in font */
;
;#ifndef _GLCD_DATA_BYTEY_
;/* Font data for displays organized as
;horizontal rows of bytes */
;
;/* Code: 0x20, ASCII Character: ' ' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x21, ASCII Character: '!' */
;0x04, 0x04, 0x04, 0x04, 0x04, 0x00, 0x04,
;
;/* Code: 0x22, ASCII Character: '"' */
;0x0A, 0x0A, 0x0A, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x23, ASCII Character: '#' */
;0x0A, 0x0A, 0x1F, 0x0A, 0x1F, 0x0A, 0x0A,
;
;/* Code: 0x24, ASCII Character: '$' */
;0x04, 0x1E, 0x05, 0x0E, 0x14, 0x0F, 0x04,
;
;/* Code: 0x25, ASCII Character: '%' */
;0x03, 0x13, 0x08, 0x04, 0x02, 0x19, 0x18,
;
;/* Code: 0x26, ASCII Character: '&' */
;0x06, 0x09, 0x05, 0x02, 0x15, 0x09, 0x16,
;
;/* Code: 0x27, ASCII Character: ''' */
;0x06, 0x04, 0x02, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x28, ASCII Character: '(' */
;0x08, 0x04, 0x02, 0x02, 0x02, 0x04, 0x08,
;
;/* Code: 0x29, ASCII Character: ')' */
;0x02, 0x04, 0x08, 0x08, 0x08, 0x04, 0x02,
;
;/* Code: 0x2A, ASCII Character: '*' */
;0x00, 0x0A, 0x04, 0x1F, 0x04, 0x0A, 0x00,
;
;/* Code: 0x2B, ASCII Character: '+' */
;0x00, 0x04, 0x04, 0x1F, 0x04, 0x04, 0x00,
;
;/* Code: 0x2C, ASCII Character: ',' */
;0x00, 0x00, 0x00, 0x00, 0x06, 0x04, 0x02,
;
;/* Code: 0x2D, ASCII Character: '-' */
;0x00, 0x00, 0x00, 0x1F, 0x00, 0x00, 0x00,
;
;/* Code: 0x2E, ASCII Character: '.' */
;0x00, 0x00, 0x00, 0x00, 0x06, 0x06, 0x00,
;
;/* Code: 0x2F, ASCII Character: '/' */
;0x00, 0x10, 0x08, 0x04, 0x02, 0x01, 0x00,
;
;/* Code: 0x30, ASCII Character: '0' */
;0x0E, 0x11, 0x19, 0x15, 0x13, 0x11, 0x0E,
;
;/* Code: 0x31, ASCII Character: '1' */
;0x04, 0x06, 0x04, 0x04, 0x04, 0x04, 0x0E,
;
;/* Code: 0x32, ASCII Character: '2' */
;0x0E, 0x11, 0x10, 0x08, 0x04, 0x02, 0x1F,
;
;/* Code: 0x33, ASCII Character: '3' */
;0x1F, 0x08, 0x04, 0x08, 0x10, 0x11, 0x0E,
;
;/* Code: 0x34, ASCII Character: '4' */
;0x08, 0x0C, 0x0A, 0x09, 0x1F, 0x08, 0x08,
;
;/* Code: 0x35, ASCII Character: '5' */
;0x1F, 0x01, 0x0F, 0x10, 0x10, 0x11, 0x0E,
;
;/* Code: 0x36, ASCII Character: '6' */
;0x0C, 0x02, 0x01, 0x0F, 0x11, 0x11, 0x0E,
;
;/* Code: 0x37, ASCII Character: '7' */
;0x1F, 0x10, 0x08, 0x04, 0x02, 0x02, 0x02,
;
;/* Code: 0x38, ASCII Character: '8' */
;0x0E, 0x11, 0x11, 0x0E, 0x11, 0x11, 0x0E,
;
;/* Code: 0x39, ASCII Character: '9' */
;0x0E, 0x11, 0x11, 0x1E, 0x10, 0x08, 0x06,
;
;/* Code: 0x3A, ASCII Character: ':' */
;0x00, 0x06, 0x06, 0x00, 0x06, 0x06, 0x00,
;
;/* Code: 0x3B, ASCII Character: ';' */
;0x00, 0x06, 0x06, 0x00, 0x06, 0x04, 0x02,
;
;/* Code: 0x3C, ASCII Character: '<' */
;0x10, 0x08, 0x04, 0x02, 0x04, 0x08, 0x10,
;
;/* Code: 0x3D, ASCII Character: '=' */
;0x00, 0x00, 0x1F, 0x00, 0x1F, 0x00, 0x00,
;
;/* Code: 0x3E, ASCII Character: '>' */
;0x01, 0x02, 0x04, 0x08, 0x04, 0x02, 0x01,
;
;/* Code: 0x3F, ASCII Character: '?' */
;0x0E, 0x11, 0x10, 0x08, 0x04, 0x00, 0x04,
;
;/* Code: 0x40, ASCII Character: '@' */
;0x0E, 0x11, 0x10, 0x16, 0x15, 0x15, 0x0E,
;
;/* Code: 0x41, ASCII Character: 'A' */
;0x0E, 0x11, 0x11, 0x11, 0x1F, 0x11, 0x11,
;
;/* Code: 0x42, ASCII Character: 'B' */
;0x0F, 0x11, 0x11, 0x0F, 0x11, 0x11, 0x0F,
;
;/* Code: 0x43, ASCII Character: 'C' */
;0x0E, 0x11, 0x01, 0x01, 0x01, 0x11, 0x0E,
;
;/* Code: 0x44, ASCII Character: 'D' */
;0x07, 0x09, 0x11, 0x11, 0x11, 0x09, 0x07,
;
;/* Code: 0x45, ASCII Character: 'E' */
;0x1F, 0x01, 0x01, 0x0F, 0x01, 0x01, 0x1F,
;
;/* Code: 0x46, ASCII Character: 'F' */
;0x1F, 0x01, 0x01, 0x07, 0x01, 0x01, 0x01,
;
;/* Code: 0x47, ASCII Character: 'G' */
;0x0E, 0x11, 0x01, 0x01, 0x19, 0x11, 0x0E,
;
;/* Code: 0x48, ASCII Character: 'H' */
;0x11, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11,
;
;/* Code: 0x49, ASCII Character: 'I' */
;0x0E, 0x04, 0x04, 0x04, 0x04, 0x04, 0x0E,
;
;/* Code: 0x4A, ASCII Character: 'J' */
;0x1C, 0x08, 0x08, 0x08, 0x08, 0x09, 0x06,
;
;/* Code: 0x4B, ASCII Character: 'K' */
;0x11, 0x09, 0x05, 0x03, 0x05, 0x09, 0x11,
;
;/* Code: 0x4C, ASCII Character: 'L' */
;0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x1F,
;
;/* Code: 0x4D, ASCII Character: 'M' */
;0x11, 0x1B, 0x15, 0x11, 0x11, 0x11, 0x11,
;
;/* Code: 0x4E, ASCII Character: 'N' */
;0x11, 0x11, 0x13, 0x15, 0x19, 0x11, 0x11,
;
;/* Code: 0x4F, ASCII Character: 'O' */
;0x0E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E,
;
;/* Code: 0x50, ASCII Character: 'P' */
;0x0F, 0x11, 0x11, 0x0F, 0x01, 0x01, 0x01,
;
;/* Code: 0x51, ASCII Character: 'Q' */
;0x0E, 0x11, 0x11, 0x11, 0x15, 0x09, 0x16,
;
;/* Code: 0x52, ASCII Character: 'R' */
;0x0F, 0x11, 0x11, 0x0F, 0x05, 0x09, 0x11,
;
;/* Code: 0x53, ASCII Character: 'S' */
;0x1E, 0x01, 0x01, 0x0E, 0x10, 0x10, 0x0F,
;
;/* Code: 0x54, ASCII Character: 'T' */
;0x1F, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0x55, ASCII Character: 'U' */
;0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E,
;
;/* Code: 0x56, ASCII Character: 'V' */
;0x11, 0x11, 0x11, 0x11, 0x11, 0x0A, 0x04,
;
;/* Code: 0x57, ASCII Character: 'W' */
;0x11, 0x11, 0x11, 0x15, 0x15, 0x1B, 0x11,
;
;/* Code: 0x58, ASCII Character: 'X' */
;0x11, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x11,
;
;/* Code: 0x59, ASCII Character: 'Y' */
;0x11, 0x11, 0x0A, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0x5A, ASCII Character: 'Z' */
;0x1F, 0x10, 0x08, 0x04, 0x02, 0x01, 0x1F,
;
;/* Code: 0x5B, ASCII Character: '[' */
;0x1C, 0x04, 0x04, 0x04, 0x04, 0x04, 0x1C,
;
;/* Code: 0x5C, ASCII Character: '\' */
;0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x00,
;
;/* Code: 0x5D, ASCII Character: ']' */
;0x07, 0x04, 0x04, 0x04, 0x04, 0x04, 0x07,
;
;/* Code: 0x5E, ASCII Character: '^' */
;0x04, 0x0A, 0x11, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5F, ASCII Character: '_' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1F,
;
;/* Code: 0x60, ASCII Character: '`' */
;0x02, 0x04, 0x08, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x61, ASCII Character: 'a' */
;0x00, 0x00, 0x0E, 0x10, 0x1E, 0x11, 0x1E,
;
;/* Code: 0x62, ASCII Character: 'b' */
;0x01, 0x01, 0x0D, 0x13, 0x11, 0x11, 0x0F,
;
;/* Code: 0x63, ASCII Character: 'c' */
;0x00, 0x00, 0x0E, 0x01, 0x01, 0x11, 0x0E,
;
;/* Code: 0x64, ASCII Character: 'd' */
;0x10, 0x10, 0x16, 0x19, 0x11, 0x11, 0x1E,
;
;/* Code: 0x65, ASCII Character: 'e' */
;0x00, 0x00, 0x0E, 0x11, 0x1F, 0x01, 0x0E,
;
;/* Code: 0x66, ASCII Character: 'f' */
;0x0C, 0x12, 0x02, 0x07, 0x02, 0x02, 0x02,
;
;/* Code: 0x67, ASCII Character: 'g' */
;0x00, 0x00, 0x1E, 0x11, 0x1E, 0x10, 0x0C,
;
;/* Code: 0x68, ASCII Character: 'h' */
;0x01, 0x01, 0x0D, 0x13, 0x11, 0x11, 0x11,
;
;/* Code: 0x69, ASCII Character: 'i' */
;0x04, 0x00, 0x06, 0x04, 0x04, 0x04, 0x0E,
;
;/* Code: 0x6A, ASCII Character: 'j' */
;0x08, 0x00, 0x0C, 0x08, 0x08, 0x09, 0x06,
;
;/* Code: 0x6B, ASCII Character: 'k' */
;0x02, 0x02, 0x12, 0x0A, 0x06, 0x0A, 0x12,
;
;/* Code: 0x6C, ASCII Character: 'l' */
;0x06, 0x04, 0x04, 0x04, 0x04, 0x04, 0x0E,
;
;/* Code: 0x6D, ASCII Character: 'm' */
;0x00, 0x00, 0x0B, 0x15, 0x15, 0x11, 0x11,
;
;/* Code: 0x6E, ASCII Character: 'n' */
;0x00, 0x00, 0x0D, 0x13, 0x11, 0x11, 0x11,
;
;/* Code: 0x6F, ASCII Character: 'o' */
;0x00, 0x00, 0x0E, 0x11, 0x11, 0x11, 0x0E,
;
;/* Code: 0x70, ASCII Character: 'p' */
;0x00, 0x00, 0x0F, 0x11, 0x0F, 0x01, 0x01,
;
;/* Code: 0x71, ASCII Character: 'q' */
;0x00, 0x00, 0x16, 0x19, 0x1E, 0x10, 0x10,
;
;/* Code: 0x72, ASCII Character: 'r' */
;0x00, 0x00, 0x0D, 0x13, 0x01, 0x01, 0x01,
;
;/* Code: 0x73, ASCII Character: 's' */
;0x00, 0x00, 0x0E, 0x01, 0x0E, 0x10, 0x0F,
;
;/* Code: 0x74, ASCII Character: 't' */
;0x02, 0x02, 0x07, 0x02, 0x02, 0x12, 0x0C,
;
;/* Code: 0x75, ASCII Character: 'u' */
;0x00, 0x00, 0x11, 0x11, 0x11, 0x19, 0x16,
;
;/* Code: 0x76, ASCII Character: 'v' */
;0x00, 0x00, 0x11, 0x11, 0x11, 0x0A, 0x04,
;
;/* Code: 0x77, ASCII Character: 'w' */
;0x00, 0x00, 0x11, 0x11, 0x15, 0x15, 0x0A,
;
;/* Code: 0x78, ASCII Character: 'x' */
;0x00, 0x00, 0x11, 0x0A, 0x04, 0x0A, 0x11,
;
;/* Code: 0x79, ASCII Character: 'y' */
;0x00, 0x00, 0x11, 0x11, 0x1E, 0x10, 0x0E,
;
;/* Code: 0x7A, ASCII Character: 'z' */
;0x00, 0x00, 0x1F, 0x08, 0x04, 0x02, 0x1F,
;
;/* Code: 0x7B, ASCII Character: '{' */
;0x08, 0x04, 0x04, 0x02, 0x04, 0x04, 0x08,
;
;/* Code: 0x7C, ASCII Character: '|' */
;0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0x7D, ASCII Character: '}' */
;0x02, 0x04, 0x04, 0x08, 0x04, 0x04, 0x02,
;
;/* Code: 0x7E, ASCII Character: '~' */
;0x02, 0x15, 0x08, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7F, ASCII Character: '' */
;0x1F, 0x11, 0x11, 0x11, 0x11, 0x11, 0x1F,
;
;#else
;/* Font data for displays organized as
;vertical columns of bytes */
;
;/* Code: 0x20, ASCII Character: ' ' */
;0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x21, ASCII Character: '!' */
;0x00, 0x00, 0x5F, 0x00, 0x00,
;
;/* Code: 0x22, ASCII Character: '"' */
;0x00, 0x07, 0x00, 0x07, 0x00,
;
;/* Code: 0x23, ASCII Character: '#' */
;0x14, 0x7F, 0x14, 0x7F, 0x14,
;
;/* Code: 0x24, ASCII Character: '$' */
;0x24, 0x2A, 0x7F, 0x2A, 0x12,
;
;/* Code: 0x25, ASCII Character: '%' */
;0x23, 0x13, 0x08, 0x64, 0x62,
;
;/* Code: 0x26, ASCII Character: '&' */
;0x36, 0x49, 0x55, 0x22, 0x50,
;
;/* Code: 0x27, ASCII Character: ''' */
;0x00, 0x05, 0x03, 0x00, 0x00,
;
;/* Code: 0x28, ASCII Character: '(' */
;0x00, 0x1C, 0x22, 0x41, 0x00,
;
;/* Code: 0x29, ASCII Character: ')' */
;0x00, 0x41, 0x22, 0x1C, 0x00,
;
;/* Code: 0x2A, ASCII Character: '*' */
;0x08, 0x2A, 0x1C, 0x2A, 0x08,
;
;/* Code: 0x2B, ASCII Character: '+' */
;0x08, 0x08, 0x3E, 0x08, 0x08,
;
;/* Code: 0x2C, ASCII Character: ',' */
;0x00, 0x50, 0x30, 0x00, 0x00,
;
;/* Code: 0x2D, ASCII Character: '-' */
;0x08, 0x08, 0x08, 0x08, 0x08,
;
;/* Code: 0x2E, ASCII Character: '.' */
;0x00, 0x30, 0x30, 0x00, 0x00,
;
;/* Code: 0x2F, ASCII Character: '/' */
;0x20, 0x10, 0x08, 0x04, 0x02,
;
;/* Code: 0x30, ASCII Character: '0' */
;0x3E, 0x51, 0x49, 0x45, 0x3E,
;
;/* Code: 0x31, ASCII Character: '1' */
;0x00, 0x42, 0x7F, 0x40, 0x00,
;
;/* Code: 0x32, ASCII Character: '2' */
;0x42, 0x61, 0x51, 0x49, 0x46,
;
;/* Code: 0x33, ASCII Character: '3' */
;0x21, 0x41, 0x45, 0x4B, 0x31,
;
;/* Code: 0x34, ASCII Character: '4' */
;0x18, 0x14, 0x12, 0x7F, 0x10,
;
;/* Code: 0x35, ASCII Character: '5' */
;0x27, 0x45, 0x45, 0x45, 0x39,
;
;/* Code: 0x36, ASCII Character: '6' */
;0x3C, 0x4A, 0x49, 0x49, 0x30,
;
;/* Code: 0x37, ASCII Character: '7' */
;0x01, 0x71, 0x09, 0x05, 0x03,
;
;/* Code: 0x38, ASCII Character: '8' */
;0x36, 0x49, 0x49, 0x49, 0x36,
;
;/* Code: 0x39, ASCII Character: '9' */
;0x06, 0x49, 0x49, 0x29, 0x1E,
;
;/* Code: 0x3A, ASCII Character: ':' */
;0x00, 0x36, 0x36, 0x00, 0x00,
;
;/* Code: 0x3B, ASCII Character: ';' */
;0x00, 0x56, 0x36, 0x00, 0x00,
;
;/* Code: 0x3C, ASCII Character: '<' */
;0x00, 0x08, 0x14, 0x22, 0x41,
;
;/* Code: 0x3D, ASCII Character: '=' */
;0x14, 0x14, 0x14, 0x14, 0x14,
;
;/* Code: 0x3E, ASCII Character: '>' */
;0x41, 0x22, 0x14, 0x08, 0x00,
;
;/* Code: 0x3F, ASCII Character: '?' */
;0x02, 0x01, 0x51, 0x09, 0x06,
;
;/* Code: 0x40, ASCII Character: '@' */
;0x32, 0x49, 0x79, 0x41, 0x3E,
;
;/* Code: 0x41, ASCII Character: 'A' */
;0x7E, 0x11, 0x11, 0x11, 0x7E,
;
;/* Code: 0x42, ASCII Character: 'B' */
;0x7F, 0x49, 0x49, 0x49, 0x36,
;
;/* Code: 0x43, ASCII Character: 'C' */
;0x3E, 0x41, 0x41, 0x41, 0x22,
;
;/* Code: 0x44, ASCII Character: 'D' */
;0x7F, 0x41, 0x41, 0x22, 0x1C,
;
;/* Code: 0x45, ASCII Character: 'E' */
;0x7F, 0x49, 0x49, 0x49, 0x41,
;
;/* Code: 0x46, ASCII Character: 'F' */
;0x7F, 0x09, 0x09, 0x01, 0x01,
;
;/* Code: 0x47, ASCII Character: 'G' */
;0x3E, 0x41, 0x41, 0x51, 0x32,
;
;/* Code: 0x48, ASCII Character: 'H' */
;0x7F, 0x08, 0x08, 0x08, 0x7F,
;
;/* Code: 0x49, ASCII Character: 'I' */
;0x00, 0x41, 0x7F, 0x41, 0x00,
;
;/* Code: 0x4A, ASCII Character: 'J' */
;0x20, 0x40, 0x41, 0x3F, 0x01,
;
;/* Code: 0x4B, ASCII Character: 'K' */
;0x7F, 0x08, 0x14, 0x22, 0x41,
;
;/* Code: 0x4C, ASCII Character: 'L' */
;0x7F, 0x40, 0x40, 0x40, 0x40,
;
;/* Code: 0x4D, ASCII Character: 'M' */
;0x7F, 0x02, 0x04, 0x02, 0x7F,
;
;/* Code: 0x4E, ASCII Character: 'N' */
;0x7F, 0x04, 0x08, 0x10, 0x7F,
;
;/* Code: 0x4F, ASCII Character: 'O' */
;0x3E, 0x41, 0x41, 0x41, 0x3E,
;
;/* Code: 0x50, ASCII Character: 'P' */
;0x7F, 0x09, 0x09, 0x09, 0x06,
;
;/* Code: 0x51, ASCII Character: 'Q' */
;0x3E, 0x41, 0x51, 0x21, 0x5E,
;
;/* Code: 0x52, ASCII Character: 'R' */
;0x7F, 0x09, 0x19, 0x29, 0x46,
;
;/* Code: 0x53, ASCII Character: 'S' */
;0x46, 0x49, 0x49, 0x49, 0x31,
;
;/* Code: 0x54, ASCII Character: 'T' */
;0x01, 0x01, 0x7F, 0x01, 0x01,
;
;/* Code: 0x55, ASCII Character: 'U' */
;0x3F, 0x40, 0x40, 0x40, 0x3F,
;
;/* Code: 0x56, ASCII Character: 'V' */
;0x1F, 0x20, 0x40, 0x20, 0x1F,
;
;/* Code: 0x57, ASCII Character: 'W' */
;0x7F, 0x20, 0x18, 0x20, 0x7F,
;
;/* Code: 0x58, ASCII Character: 'X' */
;0x63, 0x14, 0x08, 0x14, 0x63,
;
;/* Code: 0x59, ASCII Character: 'Y' */
;0x03, 0x04, 0x78, 0x04, 0x03,
;
;/* Code: 0x5A, ASCII Character: 'Z' */
;0x61, 0x51, 0x49, 0x45, 0x43,
;
;/* Code: 0x5B, ASCII Character: '[' */
;0x00, 0x00, 0x7F, 0x41, 0x41,
;
;/* Code: 0x5C, ASCII Character: '\' */
;0x02, 0x04, 0x08, 0x10, 0x20,
;
;/* Code: 0x5D, ASCII Character: ']' */
;0x41, 0x41, 0x7F, 0x00, 0x00,
;
;/* Code: 0x5E, ASCII Character: '^' */
;0x04, 0x02, 0x01, 0x02, 0x04,
;
;/* Code: 0x5F, ASCII Character: '_' */
;0x40, 0x40, 0x40, 0x40, 0x40,
;
;/* Code: 0x60, ASCII Character: '`' */
;0x00, 0x01, 0x02, 0x04, 0x00,
;
;/* Code: 0x61, ASCII Character: 'a' */
;0x20, 0x54, 0x54, 0x54, 0x78,
;
;/* Code: 0x62, ASCII Character: 'b' */
;0x7F, 0x48, 0x44, 0x44, 0x38,
;
;/* Code: 0x63, ASCII Character: 'c' */
;0x38, 0x44, 0x44, 0x44, 0x20,
;
;/* Code: 0x64, ASCII Character: 'd' */
;0x38, 0x44, 0x44, 0x48, 0x7F,
;
;/* Code: 0x65, ASCII Character: 'e' */
;0x38, 0x54, 0x54, 0x54, 0x18,
;
;/* Code: 0x66, ASCII Character: 'f' */
;0x08, 0x7E, 0x09, 0x01, 0x02,
;
;/* Code: 0x67, ASCII Character: 'g' */
;0x08, 0x14, 0x54, 0x54, 0x3C,
;
;/* Code: 0x68, ASCII Character: 'h' */
;0x7F, 0x08, 0x04, 0x04, 0x78,
;
;/* Code: 0x69, ASCII Character: 'i' */
;0x00, 0x44, 0x7D, 0x40, 0x00,
;
;/* Code: 0x6A, ASCII Character: 'j' */
;0x20, 0x40, 0x44, 0x3D, 0x00,
;
;/* Code: 0x6B, ASCII Character: 'k' */
;0x00, 0x7F, 0x10, 0x28, 0x44,
;
;/* Code: 0x6C, ASCII Character: 'l' */
;0x00, 0x41, 0x7F, 0x40, 0x00,
;
;/* Code: 0x6D, ASCII Character: 'm' */
;0x7C, 0x04, 0x18, 0x04, 0x78,
;
;/* Code: 0x6E, ASCII Character: 'n' */
;0x7C, 0x08, 0x04, 0x04, 0x78,
;
;/* Code: 0x6F, ASCII Character: 'o' */
;0x38, 0x44, 0x44, 0x44, 0x38,
;
;/* Code: 0x70, ASCII Character: 'p' */
;0x7C, 0x14, 0x14, 0x14, 0x08,
;
;/* Code: 0x71, ASCII Character: 'q' */
;0x08, 0x14, 0x14, 0x18, 0x7C,
;
;/* Code: 0x72, ASCII Character: 'r' */
;0x7C, 0x08, 0x04, 0x04, 0x08,
;
;/* Code: 0x73, ASCII Character: 's' */
;0x48, 0x54, 0x54, 0x54, 0x20,
;
;/* Code: 0x74, ASCII Character: 't' */
;0x04, 0x3F, 0x44, 0x40, 0x20,
;
;/* Code: 0x75, ASCII Character: 'u' */
;0x3C, 0x40, 0x40, 0x20, 0x7C,
;
;/* Code: 0x76, ASCII Character: 'v' */
;0x1C, 0x20, 0x40, 0x20, 0x1C,
;
;/* Code: 0x77, ASCII Character: 'w' */
;0x3C, 0x40, 0x30, 0x40, 0x3C,
;
;/* Code: 0x78, ASCII Character: 'x' */
;0x44, 0x28, 0x10, 0x28, 0x44,
;
;/* Code: 0x79, ASCII Character: 'y' */
;0x0C, 0x50, 0x50, 0x50, 0x3C,
;
;/* Code: 0x7A, ASCII Character: 'z' */
;0x44, 0x64, 0x54, 0x4C, 0x44,
;
;/* Code: 0x7B, ASCII Character: '{' */
;0x00, 0x08, 0x36, 0x41, 0x00,
;
;/* Code: 0x7C, ASCII Character: '|' */
;0x00, 0x00, 0x7F, 0x00, 0x00,
;
;/* Code: 0x7D, ASCII Character: '}' */
;0x00, 0x41, 0x36, 0x08, 0x00,
;
;/* Code: 0x7E, ASCII Character: '~' */
;0x02, 0x01, 0x02, 0x04, 0x02,
;
;/* Code: 0x7F, ASCII Character: '' */
;0x7F, 0x41, 0x41, 0x41, 0x7F,
;
;#endif
;};
;#include <stdlib.h>
;#include <delay.h>
;#define ADC_VREF_TYPE 0x00
;
;
;////////////////////////////////////////////////////////////
;unsigned temp(unsigned char adc_input)
; 0000 000B {

	.CSEG
_temp:
; .FSTART _temp
; 0000 000C     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 000D     delay_us(10);// Delay needed for the stabilization of the ADC input voltage
	__DELAY_USB 27
; 0000 000E     ADCSRA|=0x40;// Start the AD conversion
	SBI  0x6,6
; 0000 000F     while ((ADCSRA & 0x10)==0);// Wait for the AD conversion to complete
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0010     ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0011     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20E0009
; 0000 0012 }
; .FEND
;
;
;void main(void)
; 0000 0016 {
_main:
; .FSTART _main
; 0000 0017 int i;
; 0000 0018     float T0;
; 0000 0019     float T1;
; 0000 001A     float zoom,up_down,up_down2,higth,length;
; 0000 001B     int x=0;
; 0000 001C 
; 0000 001D     GLCDINIT_t glcd_init_data;   // Graphic LCD initialization data
; 0000 001E     glcd_init_data.font=font5x7; // Specify the current font for displaying text
	SBIW R28,34
;	i -> R16,R17
;	T0 -> Y+30
;	T1 -> Y+26
;	zoom -> Y+22
;	up_down -> Y+18
;	up_down2 -> Y+14
;	higth -> Y+10
;	length -> Y+6
;	x -> R18,R19
;	glcd_init_data -> Y+0
	__GETWRN 18,19,0
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 001F     glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 0020 
; 0000 0021 
; 0000 0022     // ADC initialization
; 0000 0023     // ADC Clock frequency: 250.000 kHz
; 0000 0024     // ADC Voltage Reference: AREF pin
; 0000 0025     // ADC Auto Trigger Source: None
; 0000 0026     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 0027     ADCSRA=0x85;
	LDI  R30,LOW(133)
	OUT  0x6,R30
; 0000 0028      glcd_line(0,60,239,60);
	CALL SUBOPT_0x0
; 0000 0029 
; 0000 002A   glcd_line(111,0,111,150);
; 0000 002B 
; 0000 002C      glcd_line(0,0,0,150);
; 0000 002D      glcd_line(239,0,0,0);
; 0000 002E      glcd_line(0,239,239,150);
; 0000 002F      glcd_line(239,0,239,239);
; 0000 0030 
; 0000 0031 
; 0000 0032               //   glcd_line(7,55,7,65);
; 0000 0033 
; 0000 0034 
; 0000 0035 
; 0000 0036            glcd_outtextxy(150,110,"VOLTAGE =");
	LDI  R30,LOW(110)
	ST   -Y,R30
	__POINTW2MN _0x6,0
	CALL _glcd_outtextxy
; 0000 0037 
; 0000 0038 
; 0000 0039 
; 0000 003A 
; 0000 003B 
; 0000 003C 
; 0000 003D     while(1)
_0x7:
; 0000 003E     {
; 0000 003F         up_down=temp(1)*0.0370279659829597-1;
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1
	__PUTD1S 18
; 0000 0040         up_down2=temp(6)*0.0370279659829597-1; //up_down
	LDI  R26,LOW(6)
	CALL SUBOPT_0x1
	__PUTD1S 14
; 0000 0041         higth=temp(2)*0.0065279659829597;      //higth
	LDI  R26,LOW(2)
	CALL SUBOPT_0x2
	__GETD2N 0x3BD5E88C
	CALL __MULF12
	__PUTD1S 10
; 0000 0042         length=temp(3)*0.0205279659829597;     //length
	LDI  R26,LOW(3)
	CALL SUBOPT_0x2
	__GETD2N 0x3CA82A44
	CALL __MULF12
	__PUTD1S 6
; 0000 0043         zoom=temp(4)*0.12218963831867;          //ZOOM IN--ZOOM OUT
	LDI  R26,LOW(4)
	CALL SUBOPT_0x2
	__GETD2N 0x3DFA3E90
	CALL __MULF12
	__PUTD1S 22
; 0000 0044           i=temp(0);
	LDI  R26,LOW(0)
	RCALL _temp
	MOVW R16,R30
; 0000 0045            i=(i/1023)*5  ;
	MOVW R26,R16
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	CALL __DIVW21
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __MULW12
	MOVW R16,R30
; 0000 0046            if(i>1){
	__CPWRN 16,17,2
	BRLT _0xA
; 0000 0047 
; 0000 0048               glcd_outtextxy(210,110,"2.5");            }
	LDI  R30,LOW(210)
	ST   -Y,R30
	LDI  R30,LOW(110)
	ST   -Y,R30
	__POINTW2MN _0x6,10
	CALL _glcd_outtextxy
; 0000 0049 
; 0000 004A         T0=temp(0);
_0xA:
	LDI  R26,LOW(0)
	CALL SUBOPT_0x2
	__PUTD1S 30
; 0000 004B         T1=temp(5);
	LDI  R26,LOW(5)
	CALL SUBOPT_0x2
	__PUTD1S 26
; 0000 004C         T0=(higth*T0*0.004887585532746823)*5+up_down*4;
	__GETD1S 30
	CALL SUBOPT_0x3
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 18
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	__PUTD1S 30
; 0000 004D             T1=(higth*T1*0.004887585532746823)*5+up_down2*4;
	__GETD1S 26
	CALL SUBOPT_0x3
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 14
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	__PUTD1S 26
; 0000 004E 
; 0000 004F 
; 0000 0050         delay_ms(zoom);
	__GETD1S 22
	CALL __CFD1U
	MOVW R26,R30
	CALL _delay_ms
; 0000 0051         glcd_setpixel(length*x,150-T0); //ÇÖÇÝå ˜ÑÏä äÞØå ÏÑãÎÊÕÇÊ ÏáÎæÇå
	CALL SUBOPT_0x5
	__GETD2S 31
	CALL SUBOPT_0x6
; 0000 0052          glcd_setpixel(length*x,150-T1); //ÇÖÇÝå ˜ÑÏä äÞØå ÏÑãÎÊÕÇÊ ÏáÎæÇå
	CALL SUBOPT_0x5
	__GETD2S 27
	CALL SUBOPT_0x6
; 0000 0053         x++;
	__ADDWRN 18,19,1
; 0000 0054 
; 0000 0055         if(x*length>=240){x=0;
	__GETD1S 6
	MOVW R26,R18
	CALL __CWD2
	CALL __CDF2
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43700000
	CALL __CMPF12
	BRLO _0xB
	__GETWRN 18,19,0
; 0000 0056         glcd_clear();
	CALL _glcd_clear
; 0000 0057            glcd_line(0,60,239,60);
	CALL SUBOPT_0x0
; 0000 0058            glcd_line(111,0,111,150);
; 0000 0059               glcd_line(0,0,0,150);
; 0000 005A      glcd_line(239,0,0,0);
; 0000 005B      glcd_line(0,239,239,150);
; 0000 005C      glcd_line(239,0,239,239);
; 0000 005D        glcd_outtextxy(150,110,"VOLTAGE =");
	LDI  R30,LOW(110)
	ST   -Y,R30
	__POINTW2MN _0x6,14
	CALL _glcd_outtextxy
; 0000 005E         }
; 0000 005F     }
_0xB:
	RJMP _0x7
; 0000 0060 
; 0000 0061 
; 0000 0062 }
_0xC:
	RJMP _0xC
; .FEND

	.DSEG
_0x6:
	.BYTE 0x18
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_t6963_wrbus_G100:
; .FSTART _t6963_wrbus_G100
	ST   -Y,R26
	CBI  0x12,1
	CBI  0x12,3
	LDI  R30,LOW(255)
	OUT  0x14,R30
	LD   R30,Y
	OUT  0x15,R30
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
	SBI  0x12,3
    nop
    nop
	SBI  0x12,1
	RJMP _0x20E0009
; .FEND
_t6963_rdbus_G100:
; .FSTART _t6963_rdbus_G100
	ST   -Y,R17
	CBI  0x12,1
	CBI  0x12,2
	LDI  R30,LOW(0)
	OUT  0x14,R30
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
	IN   R17,19
	SBI  0x12,2
	SBI  0x12,1
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_t6963_busy:
; .FSTART _t6963_busy
	SBI  0x12,0
_0x2000003:
	RCALL _t6963_rdbus_G100
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x3)
	BRNE _0x2000003
	RET
; .FEND
_t6963_wrdata:
; .FSTART _t6963_wrdata
	ST   -Y,R26
	RCALL _t6963_busy
	CBI  0x12,0
	LD   R26,Y
	CALL _t6963_wrbus_G100
	RJMP _0x20E0009
; .FEND
_t6963_rddata:
; .FSTART _t6963_rddata
	RCALL _t6963_busy
	CBI  0x12,0
	RCALL _t6963_rdbus_G100
	RET
; .FEND
_t6963_wrcmd:
; .FSTART _t6963_wrcmd
	ST   -Y,R26
	RCALL _t6963_busy
	LD   R26,Y
	CALL _t6963_wrbus_G100
	RJMP _0x20E0009
; .FEND
_t6963_setaddrptr_G100:
; .FSTART _t6963_setaddrptr_G100
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	RCALL _t6963_wrdata
	LDD  R26,Y+1
	RCALL _t6963_wrdata
	LDI  R26,LOW(36)
	RCALL _t6963_wrcmd
	JMP  _0x20E0003
; .FEND
_t6963_rdbyte_G100:
; .FSTART _t6963_rdbyte_G100
	ST   -Y,R26
	LD   R26,Y
	LDI  R30,LOW(30)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-480)
	SBCI R31,HIGH(-480)
	MOVW R26,R30
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _t6963_setaddrptr_G100
	LDI  R26,LOW(197)
	RCALL _t6963_wrcmd
	RCALL _t6963_rddata
	JMP  _0x20E0003
; .FEND
_t6963_wrbyte_G100:
; .FSTART _t6963_wrbyte_G100
	ST   -Y,R26
	LD   R26,Y
	RCALL _t6963_wrdata
	LDI  R26,LOW(196)
	RJMP _0x20E0008
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	SBI  0x11,1
	SBI  0x12,1
	SBI  0x11,2
	SBI  0x12,2
	SBI  0x11,3
	SBI  0x12,3
	SBI  0x11,0
	SBI  0x11,4
	CBI  0x12,4
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x12,4
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(0)
	CALL SUBOPT_0x7
	LDI  R26,LOW(64)
	RCALL _t6963_wrcmd
	LDI  R26,LOW(30)
	CALL SUBOPT_0x7
	LDI  R26,LOW(65)
	RCALL _t6963_wrcmd
	LDI  R26,LOW(224)
	RCALL _t6963_wrdata
	LDI  R26,LOW(1)
	RCALL _t6963_wrdata
	LDI  R26,LOW(66)
	RCALL _t6963_wrcmd
	LDI  R26,LOW(30)
	CALL SUBOPT_0x7
	LDI  R26,LOW(67)
	RCALL _t6963_wrcmd
	LDI  R26,LOW(3)
	CALL SUBOPT_0x7
	LDI  R26,LOW(34)
	RCALL _t6963_wrcmd
	LDI  R26,LOW(128)
	RCALL _t6963_wrcmd
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BREQ _0x2000006
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x200008A
_0x2000006:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x200008A:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	JMP  _0x20E0003
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000008
	LDI  R30,LOW(156)
	RJMP _0x2000009
_0x2000008:
	LDI  R30,LOW(144)
_0x2000009:
	MOV  R26,R30
_0x20E0008:
	RCALL _t6963_wrcmd
_0x20E0009:
	ADIW R28,1
	RET
; .FEND
_glcd_cleartext:
; .FSTART _glcd_cleartext
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _t6963_setaddrptr_G100
	__GETWRN 16,17,480
_0x200000B:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x200000D
	LDI  R26,LOW(0)
	RCALL _t6963_wrdata
	LDI  R26,LOW(192)
	RCALL _t6963_wrcmd
	RJMP _0x200000B
_0x200000D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
_glcd_cleargraphics:
; .FSTART _glcd_cleargraphics
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x200000E
	LDI  R19,LOW(255)
_0x200000E:
	LDI  R26,LOW(480)
	LDI  R27,HIGH(480)
	RCALL _t6963_setaddrptr_G100
	__GETWRN 16,17,3840
_0x200000F:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2000011
	MOV  R26,R19
	RCALL _t6963_wrdata
	LDI  R26,LOW(192)
	RCALL _t6963_wrcmd
	RJMP _0x200000F
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	JMP  _0x20E0001
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	RCALL _glcd_cleartext
	RCALL _glcd_cleargraphics
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0xF0)
	BRSH _0x2000013
	LDD  R26,Y+3
	CPI  R26,LOW(0x80)
	BRLO _0x2000012
_0x2000013:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20E0004
_0x2000012:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _t6963_rdbyte_G100
	MOV  R17,R30
	LDD  R30,Y+4
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(7)
	CALL __SWAPB12
	SUB  R30,R26
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x2000015
	OR   R17,R16
	RJMP _0x2000016
_0x2000015:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000016:
	MOV  R26,R17
	RCALL _t6963_wrbyte_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20E0004
; .FEND
_t6963_wrmasked_G100:
; .FSTART _t6963_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	CALL SUBOPT_0x8
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2000021
	CPI  R30,LOW(0x8)
	BRNE _0x2000022
_0x2000021:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2000023
_0x2000022:
	CPI  R30,LOW(0x3)
	BRNE _0x2000025
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000026
_0x2000025:
	CPI  R30,0
	BRNE _0x2000027
_0x2000026:
	RJMP _0x2000028
_0x2000027:
	CPI  R30,LOW(0x9)
	BRNE _0x2000029
_0x2000028:
	RJMP _0x200002A
_0x2000029:
	CPI  R30,LOW(0xA)
	BRNE _0x200002B
_0x200002A:
_0x2000023:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x200002C
_0x200002B:
	CPI  R30,LOW(0x2)
	BRNE _0x200002D
_0x200002C:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x200001F
_0x200002D:
	CPI  R30,LOW(0x1)
	BRNE _0x200002E
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x200001F
_0x200002E:
	CPI  R30,LOW(0x4)
	BRNE _0x200001F
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x200001F:
	MOV  R26,R17
	CALL _glcd_revbits
	MOV  R26,R30
	RCALL _t6963_wrbyte_G100
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,7
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CPI  R26,LOW(0xF0)
	BRSH _0x2000031
	LDD  R26,Y+19
	CPI  R26,LOW(0x80)
	BRSH _0x2000031
	LDD  R26,Y+18
	CPI  R26,LOW(0x0)
	BREQ _0x2000031
	LDD  R26,Y+17
	CPI  R26,LOW(0x0)
	BRNE _0x2000030
_0x2000031:
	RJMP _0x20E0005
_0x2000030:
	LDD  R30,Y+18
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R18,R30
	__PUTBSR 18,8
	LDD  R30,Y+18
	ANDI R30,LOW(0x7)
	STD  Y+11,R30
	CPI  R30,0
	BREQ _0x2000033
	LDD  R30,Y+8
	SUBI R30,-LOW(1)
	STD  Y+8,R30
_0x2000033:
	LDD  R16,Y+18
	LDD  R26,Y+20
	CLR  R27
	LDD  R30,Y+18
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0xF1)
	LDI  R30,HIGH(0xF1)
	CPC  R27,R30
	BRLO _0x2000034
	LDD  R26,Y+20
	LDI  R30,LOW(240)
	SUB  R30,R26
	STD  Y+18,R30
_0x2000034:
	LDD  R30,Y+17
	STD  Y+10,R30
	LDD  R26,Y+19
	CLR  R27
	LDD  R30,Y+17
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2000035
	LDD  R26,Y+19
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+17,R30
_0x2000035:
	LDD  R30,Y+13
	CPI  R30,LOW(0x6)
	BREQ PC+2
	RJMP _0x2000039
	LDD  R30,Y+16
	CPI  R30,LOW(0x1)
	BRNE _0x200003D
	RJMP _0x20E0005
_0x200003D:
	CPI  R30,LOW(0x3)
	BRNE _0x2000040
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x200003F
	RJMP _0x20E0005
_0x200003F:
_0x2000040:
	LDD  R30,Y+11
	CPI  R30,0
	BRNE _0x2000042
	LDD  R26,Y+18
	CP   R16,R26
	BREQ _0x2000041
_0x2000042:
	MOV  R30,R18
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R31,0
	CALL SUBOPT_0x9
	LDD  R17,Y+17
_0x2000044:
	CPI  R17,0
	BREQ _0x2000046
	MOV  R19,R18
_0x2000047:
	PUSH R19
	SUBI R19,-1
	LDD  R30,Y+8
	POP  R26
	CP   R26,R30
	BRSH _0x2000049
	CALL SUBOPT_0xA
	RJMP _0x2000047
_0x2000049:
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x9
	SUBI R17,LOW(1)
	RJMP _0x2000044
_0x2000046:
_0x2000041:
	LDD  R18,Y+17
	LDD  R30,Y+10
	CP   R30,R18
	BREQ _0x200004A
	MOV  R26,R18
	CLR  R27
	LDD  R30,Y+8
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x9
_0x200004B:
	PUSH R18
	SUBI R18,-1
	LDD  R30,Y+10
	POP  R26
	CP   R26,R30
	BRSH _0x200004D
	LDI  R19,LOW(0)
_0x200004E:
	PUSH R19
	SUBI R19,-1
	LDD  R30,Y+8
	POP  R26
	CP   R26,R30
	BRSH _0x2000050
	CALL SUBOPT_0xA
	RJMP _0x200004E
_0x2000050:
	RJMP _0x200004B
_0x200004D:
_0x200004A:
	RJMP _0x2000038
_0x2000039:
	CPI  R30,LOW(0x9)
	BRNE _0x2000051
	LDI  R30,LOW(0)
	RJMP _0x200008B
_0x2000051:
	CPI  R30,LOW(0xA)
	BRNE _0x2000038
	LDI  R30,LOW(255)
_0x200008B:
	STD  Y+10,R30
	ST   -Y,R30
	LDD  R26,Y+14
	CALL _glcd_mappixcolor1bit
	STD  Y+10,R30
_0x2000038:
	LDD  R30,Y+20
	ANDI R30,LOW(0x7)
	MOV  R19,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	MOV  R21,R18
	LDD  R26,Y+18
	CP   R18,R26
	BRLO _0x2000055
	LDD  R21,Y+18
	RJMP _0x2000056
_0x2000055:
	CPI  R19,0
	BREQ _0x2000057
	MOV  R20,R19
	LDD  R26,Y+18
	CPI  R26,LOW(0x9)
	BRSH _0x2000058
	LDD  R30,Y+18
	SUB  R30,R18
	MOV  R20,R30
_0x2000058:
	MOV  R30,R20
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
_0x2000057:
_0x2000056:
	ST   -Y,R19
	MOV  R26,R21
	CALL _glcd_getmask
	MOV  R21,R30
	LDD  R26,Y+11
	CP   R18,R26
	BRSH _0x2000059
	LDD  R30,Y+11
	SUB  R30,R18
	STD  Y+11,R30
_0x2000059:
	LDD  R30,Y+11
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R0,Z
	STD  Y+12,R0
_0x200005A:
	LDD  R30,Y+17
	SUBI R30,LOW(1)
	STD  Y+17,R30
	SUBI R30,-LOW(1)
	BRNE PC+2
	RJMP _0x200005C
	LDI  R17,LOW(0)
	LDD  R16,Y+20
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	CPI  R19,0
	BRNE PC+2
	RJMP _0x200005D
	__PUTBSR 20,11
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x200005E
_0x200005F:
	LDD  R30,Y+18
	CP   R17,R30
	BRLO PC+2
	RJMP _0x2000061
	ST   -Y,R16
	LDD  R26,Y+20
	CALL SUBOPT_0x8
	AND  R30,R21
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	STD  Y+9,R30
	CALL SUBOPT_0xB
	MOV  R1,R30
	MOV  R30,R19
	MOV  R26,R21
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	LDD  R26,Y+9
	OR   R30,R26
	STD  Y+9,R30
	LDD  R26,Y+18
	CP   R18,R26
	BRSH _0x2000063
	MOV  R30,R16
	LSR  R30
	LSR  R30
	LSR  R30
	CPI  R30,LOW(0x1D)
	BRLO _0x2000062
_0x2000063:
	CALL SUBOPT_0xC
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+12
	CALL _glcd_writemem
	RJMP _0x2000061
_0x2000062:
	LDD  R26,Y+18
	SUB  R26,R17
	CPI  R26,LOW(0x8)
	BRSH _0x2000065
	LDD  R30,Y+12
	STD  Y+11,R30
_0x2000065:
	SUBI R16,-LOW(8)
	ST   -Y,R16
	LDD  R26,Y+20
	CALL SUBOPT_0x8
	LDD  R26,Y+11
	AND  R30,R26
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	STD  Y+10,R30
	MOV  R30,R18
	LDD  R26,Y+11
	CALL __LSLB12
	COM  R30
	LDD  R26,Y+9
	AND  R30,R26
	LDD  R26,Y+10
	OR   R30,R26
	STD  Y+10,R30
	CALL SUBOPT_0xC
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+13
	CALL _glcd_writemem
	SUBI R17,-LOW(8)
	RJMP _0x200005F
_0x2000061:
	RJMP _0x2000066
_0x200005E:
_0x2000067:
	LDD  R30,Y+18
	CP   R17,R30
	BRSH _0x2000069
	LDD  R30,Y+13
	CPI  R30,LOW(0x9)
	BREQ _0x200006E
	CPI  R30,LOW(0xA)
	BRNE _0x2000070
_0x200006E:
	RJMP _0x200006C
_0x2000070:
	CALL SUBOPT_0xC
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	CALL _glcd_readmem
	STD  Y+10,R30
_0x200006C:
	ST   -Y,R16
	LDD  R30,Y+20
	ST   -Y,R30
	MOV  R30,R19
	LDD  R26,Y+12
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R21
	LDD  R26,Y+17
	RCALL _t6963_wrmasked_G100
	LDD  R26,Y+18
	CP   R18,R26
	BRSH _0x2000069
	MOV  R30,R16
	LSR  R30
	LSR  R30
	LSR  R30
	CPI  R30,LOW(0x1D)
	BRSH _0x2000069
	SUB  R26,R17
	CPI  R26,LOW(0x8)
	BRSH _0x2000073
	LDD  R30,Y+12
	STD  Y+11,R30
_0x2000073:
	SUBI R16,-LOW(8)
	ST   -Y,R16
	LDD  R30,Y+20
	ST   -Y,R30
	MOV  R30,R18
	LDD  R26,Y+12
	CALL __LSRB12
	CALL SUBOPT_0xD
	SUBI R17,-LOW(8)
	RJMP _0x2000067
_0x2000069:
_0x2000066:
	RJMP _0x2000074
_0x200005D:
	__PUTBSR 21,11
_0x2000075:
	LDD  R30,Y+18
	CP   R17,R30
	BRSH _0x2000077
	LDD  R26,Y+18
	SUB  R26,R17
	CPI  R26,LOW(0x8)
	BRSH _0x2000078
	LDD  R30,Y+12
	STD  Y+11,R30
_0x2000078:
	LDD  R30,Y+13
	CPI  R30,LOW(0x9)
	BREQ _0x200007D
	CPI  R30,LOW(0xA)
	BRNE _0x200007F
_0x200007D:
	RJMP _0x200007B
_0x200007F:
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BRNE _0x2000081
	LDD  R26,Y+11
	CPI  R26,LOW(0xFF)
	BREQ _0x2000080
_0x2000081:
	CALL SUBOPT_0xB
	STD  Y+10,R30
_0x2000080:
_0x200007B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BRNE _0x2000083
	CALL SUBOPT_0xC
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R16
	LDD  R26,Y+23
	CALL SUBOPT_0x8
	LDD  R26,Y+14
	AND  R30,R26
	MOV  R0,R30
	LDD  R30,Y+14
	COM  R30
	LDD  R26,Y+13
	AND  R30,R26
	OR   R30,R0
	MOV  R26,R30
	CALL _glcd_writemem
	RJMP _0x2000084
_0x2000083:
	ST   -Y,R16
	LDD  R30,Y+20
	ST   -Y,R30
	LDD  R30,Y+12
	CALL SUBOPT_0xD
_0x2000084:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SUBI R16,-LOW(8)
	SUBI R17,-LOW(8)
	RJMP _0x2000075
_0x2000077:
_0x2000074:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+8
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200005A
_0x200005C:
	RJMP _0x20E0005
; .FEND
_glcd_putcharcg:
; .FSTART _glcd_putcharcg
	ST   -Y,R26
	LDD  R26,Y+1
	LDI  R30,LOW(30)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _t6963_setaddrptr_G100
	LD   R26,Y
	CPI  R26,LOW(0x80)
	BRSH _0x2000085
	LD   R30,Y
	SUBI R30,LOW(32)
	ST   Y,R30
_0x2000085:
	LD   R26,Y
	RCALL _t6963_wrdata
	LDI  R26,LOW(196)
	RCALL _t6963_wrcmd
	JMP  _0x20E0002
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0xE
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x20E0003
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xF0)
	LDI  R30,HIGH(0xF0)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(239)
	LDI  R31,HIGH(239)
	JMP  _0x20E0003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x20E0003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0xE
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x20E0003
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2020006
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	JMP  _0x20E0003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x20E0003
; .FEND
_glcd_setpixel:
; .FSTART _glcd_setpixel
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	JMP  _0x20E0003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0xF
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20E0007
_0x202000B:
	CALL SUBOPT_0x10
	STD  Y+7,R0
	CALL SUBOPT_0x10
	STD  Y+6,R0
	CALL SUBOPT_0x10
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20E0007
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20E0007
_0x202000D:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000E
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+7
	ANDI R30,LOW(0x7)
	BREQ _0x202000F
	SUBI R20,-LOW(1)
_0x202000F:
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+6
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x20E0007
_0x202000E:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	LPM  R30,Z
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R30,Z
	ANDI R30,LOW(0x7)
	BREQ _0x2020013
	SUBI R20,-LOW(1)
_0x2020013:
	LDD  R26,Y+6
	CLR  R27
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x20E0007:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x11
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x12
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0xF
	SBIW R30,0
	BRNE PC+2
	RJMP _0x2020020
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020021
	RJMP _0x2020022
_0x2020021:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020023
	RJMP _0x20E0006
_0x2020023:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,241
	BRLO _0x2020024
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020024:
	CALL SUBOPT_0x13
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x11
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	CALL SUBOPT_0x14
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x15
	CALL SUBOPT_0x14
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x11
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x15
	RCALL _glcd_block
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020025
_0x2020022:
	RCALL _glcd_new_line_G101
	RJMP _0x20E0006
_0x2020025:
	RJMP _0x2020026
_0x2020020:
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BREQ _0x2020028
	__GETB1MN _glcd_state,2
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	__GETB1MN _glcd_state,3
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R18,R30
	ST   -Y,R19
	ST   -Y,R18
	LDD  R26,Y+9
	RCALL _glcd_putcharcg
	MOV  R30,R19
	LSL  R30
	LSL  R30
	LSL  R30
	__PUTB1MN _glcd_state,2
	MOV  R30,R18
	LSL  R30
	LSL  R30
	LSL  R30
	__PUTB1MN _glcd_state,3
	CALL SUBOPT_0x13
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x14
	LDI  R31,0
	ADIW R30,8
	MOVW R16,R30
	__CPWRN 16,17,240
	BRLO _0x2020029
_0x2020028:
	__GETWRN 16,17,0
	__GETB1MN _glcd_state,3
	LDI  R31,0
	ADIW R30,8
	MOVW R26,R30
	CALL SUBOPT_0x12
_0x2020029:
_0x2020026:
	__PUTBMRN _glcd_state,2,16
_0x20E0006:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x202002A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202002C
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x202002A
_0x202002C:
	LDD  R17,Y+0
	RJMP _0x20E0004
; .FEND
_glcd_putpixelm_G101:
; .FSTART _glcd_putpixelm_G101
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x2020043
	LDS  R30,_glcd_state
	RJMP _0x2020044
_0x2020043:
	__GETB1MN _glcd_state,1
_0x2020044:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2020046
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2020046:
	LD   R30,Y
	RJMP _0x20E0002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	CALL SUBOPT_0x12
	RJMP _0x20E0003
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2020047
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2020048
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	RJMP _0x20E0005
_0x2020048:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2020049
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x202004A
_0x2020049:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x202004A:
_0x202004C:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x202004E:
	CALL SUBOPT_0x16
	BRSH _0x2020050
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+7,R30
	RJMP _0x202004E
_0x2020050:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x202004C
	RJMP _0x2020051
_0x2020047:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x2020052
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x2020053
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x2020120
_0x2020053:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x2020120:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2020056:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020058:
	CALL SUBOPT_0x16
	BRSH _0x202005A
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x17
	STD  Y+7,R30
	RJMP _0x2020058
_0x202005A:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2020056
	RJMP _0x202005B
_0x2020052:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x202005C:
	CALL SUBOPT_0x16
	BRLO PC+2
	RJMP _0x202005E
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x202005F
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x202005F:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x2020060
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2020060:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x2020061
_0x2020063:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x18
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2020065
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x19
_0x2020065:
	ST   -Y,R17
	CALL SUBOPT_0x17
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x2020063
	RJMP _0x2020066
_0x2020061:
_0x2020068:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x202006A
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x19
_0x202006A:
	ST   -Y,R17
	CALL SUBOPT_0x17
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2020068
_0x2020066:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x202005C
_0x202005E:
_0x202005B:
_0x2020051:
_0x20E0005:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x20E0004:
	ADIW R28,5
	RET
; .FEND

	.CSEG

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x20E0003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20A0007
	CPI  R30,LOW(0xA)
	BRNE _0x20A0008
_0x20A0007:
	LDS  R17,_glcd_state
	RJMP _0x20A0009
_0x20A0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20A000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20A0009
_0x20A000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20A0005
	__GETBRMN 17,_glcd_state,16
_0x20A0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20A000E
	CPI  R17,0
	BREQ _0x20A000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x20E0002
_0x20A000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x20E0002
_0x20A000E:
	CPI  R17,0
	BRNE _0x20A0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x20E0002
_0x20A0011:
_0x20A0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x20E0002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20A0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x20E0002
_0x20A0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20A0016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x20E0002
_0x20A0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20A0018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x20E0002
_0x20A0018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x20E0002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20A001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20A001B
_0x20A001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20A001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x20A001B
_0x20A001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20A001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20A001B:
_0x20E0001:
	ADIW R28,4
	RET
; .FEND
_glcd_revbits:
; .FSTART _glcd_revbits
	ST   -Y,R26
    ld  r26,y+
    bst r26,0
    bld r30,7

    bst r26,1
    bld r30,6

    bst r26,2
    bld r30,5

    bst r26,3
    bld r30,4

    bst r26,4
    bld r30,3

    bst r26,5
    bld r30,2

    bst r26,6
    bld r30,1

    bst r26,7
    bld r30,0
    ret
; .FEND

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R30,LOW(239)
	ST   -Y,R30
	LDI  R26,LOW(60)
	CALL _glcd_line
	LDI  R30,LOW(111)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(111)
	ST   -Y,R30
	LDI  R26,LOW(150)
	CALL _glcd_line
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(150)
	CALL _glcd_line
	LDI  R30,LOW(239)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _glcd_line
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(239)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(150)
	CALL _glcd_line
	LDI  R30,LOW(239)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(239)
	ST   -Y,R30
	LDI  R26,LOW(239)
	CALL _glcd_line
	LDI  R30,LOW(150)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1:
	CALL _temp
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x3D17AAA3
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F800000
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	CALL _temp
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	__GETD2S 10
	CALL __MULF12
	__GETD2N 0x3BA0280A
	CALL __MULF12
	__GETD2N 0x40A00000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__GETD1N 0x40800000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	MOVW R30,R18
	__GETD2S 6
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	CALL __CFD1U
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	__GETD1N 0x43160000
	CALL __SUBF12
	CALL __CFD1U
	MOV  R26,R30
	JMP  _glcd_setpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	CALL _t6963_wrdata
	LDI  R26,LOW(0)
	JMP  _t6963_wrdata

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	CALL _t6963_rdbyte_G100
	MOV  R26,R30
	JMP  _glcd_revbits

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xA:
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R26,Y+17
	JMP  _t6963_wrmasked_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CALL _glcd_block
	__GETB1MN _glcd_state,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
