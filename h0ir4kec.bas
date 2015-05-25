B0 = 1
B1 = 32
B2 = 1
B3 = B1
B6 = 0

rem | B0 will be the byte to be written. B1 is the data to be written
rem | Ports: A.2 to LED1, A.3 to LED2, A.0 to W/R (0 WRITE, 1 READ), A.1 to CS, B5 to SER (Data), B6 to SRCLK (Clock), B7 to SCLK (Latch), C0 to C7 to 6116 DATA bus

rem | Setting CS on the 6116 HIGH, chip control on shift register low
HIGH A.1
LOW B.5
LOW B.6
LOW B.7

rem | Let's turn the two LEDs high
HIGH A.2
HIGH A.3

rem | Writes address in B0 to the shift register, enables latch
GOSUB SHIFTWRITE
HIGH B.7
rem | Writes data to C0 to C7
GOSUB DATAWRITE
rem | The memory chip can now be enabled
LOW A.0
LOW A.1
HIGH A.1
rem | the data is now written to the memory chip
rem | Now to read data from the chip
GOSUB DATAREAD
if B6 = B1 THEN
	LOW A.2
	HIGH A.3
else
	HIGH A.2
	LOW A.3
endif
rem | The program is finished


rem | This will write B0 to the shift register, leaving the latch disabled
SHIFTWRITE:
for B4 = 1 to 8
	B5 = B2&B3
	if B5 = 1 then
		HIGH B.5
		HIGH B.6
		LOW B.6
		LOW B.5
	else
		LOW B.5
		HIGH B.6
		LOW B.6
	endif
	B3 = B3>>1
next B4

return

rem | This will write B1 to C0-C7
DATAWRITE:
B5 = B2&B1
if B5 = 1 then HIGH C.0 endif
B1 = B1>>1
B5 = B2&B1
if B5 = 1 then HIGH C.1 endif
B1 = B1>>1
B5 = B2&B1
if B5 = 1 then HIGH C.2 endif
B1 = B1>>1
B5 = B2&B1
if B5 = 1 then HIGH C.3 endif
B1 = B1>>1
B5 = B2&B1
if B5 = 1 then HIGH C.4 endif
B1 = B1>>1
B5 = B2&B1
if B5 = 1 then HIGH C.5 endif
B1 = B1>>1
B5 = B2&B1
if B5 = 1 then HIGH C.6 endif
B1 = B1>>1
B5 = B2&B1
if B5 = 1 then HIGH C.7 endif
B1 = B1>>1
return

rem | This will write C0 to C7 to B6
DATAREAD:
INPUT C.0
INPUT C.1
INPUT C.2
INPUT C.3
INPUT C.4
INPUT C.5
INPUT C.6
INPUT C.7
rem | Actual code goes here
if pin C.0 then 
	B6 = B6 | 1
endif
if pin C.1 then 
	B6 = B6 | 2
endif
if pin C.2 then 
	B6 = B6 | 4
endif
if pin C.3 then 
	B6 = B6 | 8
endif
if pin C.4 then 
	B6 = B6 | 16
endif
if pin C.5 then 
	B6 = B6 | 32
endif
if pin C.6 then 
	B6 = B6 | 64
endif
if pin C.7 then 
	B6 = B6 | 128
endif
OUTPUT C.0
OUTPUT C.1
OUTPUT C.2
OUTPUT C.3
OUTPUT C.4
OUTPUT C.5
OUTPUT C.6
OUTPUT C.7
return





	
	
	
	


