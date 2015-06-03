B0 = 1
B1 = 32
B2 = 1
B6 = 0
B9 = 0

setfreq em64

rem | B0 will be the byte to be written. B1 is the data to be written. B2 is the byte 00000001b for comparison purposes. B3 is copy of a variable for bitshifting. B6 is where data read from C0 to C7 is stored. B7 is where the byte read from serial is stored. B4 is a general use FOR incrementer B8 is where the byte to be written to serial is stored. B5 is a temporary variable used when decoding a byte into its bits
rem | Ports: A.2 to LED1, A.3 to LED2, A.0 to W/R (0 WRITE, 1 READ), A.1 to CS, B5 to SER (Data), B6 to SRCLK (Clock), B7 to SCLK (Latch), C0 to C7 to 6116 DATA bus
rem | Ports for C64 Serial bus: B0 to SRQ, B1 to ATN, B2 to CLK, B3 to DATA, B4 to RESET
rem | When working with the serial bus, use OUTPUT when you are supposed to control the line, or INPUT when the line is supposed to be left floating
rem | Your device ID should be 1

rem | Setting CS on the 6116 HIGH, chip control on shift register low
HIGH A.1
LOW B.5
LOW B.6
LOW B.7
rem | setting value for B.2
do
loop
input B.2
	do
	loop while pinB.1 = 1
		HIGH B.3
	do
	loop while pinB.2 = 1
		LOW B.3
TIMER 65535
IF TIMER = 3200000
THEN
	IF pinB.2 = 1
	THEN
	B9 = 1
GOSUB SERDATAREAD
rem | setting dataline high for handshake
HIGH B.3
loop while B9 = 0
rem | reading a byte in from C64 w/ handshake
HIGH B.5
HIGH B.6
LOW B.6
rem | allowing 200 milliseconds for talker to pull clockline to true
PAUSE 200
IF B.2 = LOW
	A.2 HIGH
	A.3 LOW
	return
rem | if talker does not pull clockline to true, means an error has occured in transmission. LEDS will light to indicate error to user.
IF B.2 = HIGH
rem | if talker pulls clockline to true, means transmission was successful.
	GOSUB SERDATAREAD
	input B.2
	do
	loop while pinB.1 = 1
		HIGH B.3
	do
	loop while pinB.2 = 1
		LOW B.3
rem | sets clock, data lines to low
LOW B.2
LOW B.3
rem | waits a millisecond or one thousand microseconds for clock line to be pulled to high
PAUSE 1000
rem | input from listener
input B.2
IF B.2 = HIGH
	GOSUB SERDATAWRITE
rem | if clock line is pulled high, means transmission was successful
ELSE
	HIGH A.2
	HIGH A.3
	return
rem | if clock line is not pulled high, means something went wrong. LEDS are powered to show user that an error has occured.

rem | This will store whatever is read from the serial bus into variable B7
SERDATAREAD:
INPUT B.3
INPUT B.2
for B4 = 1 to 8
	do
	loop while pinB.2=1
		do
			if B4 = 1 then
				B7=B7|1 
			endif
			if B4 = 2 then
				B7=B7|2 
			endif
			if B4 = 3 then 
				B7=B7|4 
			endif
			if B4 = 4 then 
				B7=B7|8
			endif
			if B4 = 5 then 
				B7=B7|16 
			endif
			if B4 = 6 then 
				B7=B7|32 
			endif
			if B4 = 7 then 
				B7=B7|64
			endif
			if B4 = 8 then 
				B7=B7|128 
			endif
		loop while pinB.2=0
			
next B4
return
rem | This will write B8 to the serial bus
SERDATAWRITE:
OUTPUT B.3
OUTPUT B.2
B3 = B8
for B4 = 1 to 8
	B5 = B2&B3
	if B5 = 1 then
		HIGH B.3
		HIGH B.2
		LOW B.2
		LOW B.3
	else
		LOW B.3
		HIGH B.2
		LOW B.2
	endif
	B3 = B3>>1
next B4
INPUT B.3
INPUT B.2
return

rem | This will write B0 to the shift register, leaving the latch disabled
SHIFTWRITE:
B3 = B1
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
B3 = B1
B5 = B2&B3
if B5 = 1 then HIGH C.0 endif
B3 = B3>>1
B5 = B2&B3
if B5 = 1 then HIGH C.1 endif
B3 = B3>>1
B5 = B2&B3
if B5 = 1 then HIGH C.2 endif
B3 = B3>>1
B5 = B2&B3
if B5 = 1 then HIGH C.3 endif
B3 = B3>>1
B5 = B2&B3
if B5 = 1 then HIGH C.4 endif
B3 = B3>>1
B5 = B2&B3
if B5 = 1 then HIGH C.5 endif
B3 = B3>>1
B5 = B2&B3
if B5 = 1 then HIGH C.6 endif
B3 = B3>>1
B5 = B2&B3
if B5 = 1 then HIGH C.7 endif
B3 = B3>>1
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
HIGH A.0
LOW A.1
if pinC.0=1 then 
	B6 = B6 | 1
endif
if pinC.1=1 then 
	B6 = B6 | 2
endif
if pinC.2=1 then 
	B6 = B6 | 4
endif
if pinC.3=1 then 
	B6 = B6 | 8
endif
if pinC.4=1 then 
	B6 = B6 | 16
endif
if pinC.5=1 then 
	B6 = B6 | 32
endif
if pinC.6=1 then 
	B6 = B6 | 64
endif
if pinC.7=1 then 
	B6 = B6 | 128
endif
HIGH A.1
OUTPUT C.0
OUTPUT C.1
OUTPUT C.2
OUTPUT C.3
OUTPUT C.4
OUTPUT C.5
OUTPUT C.6
OUTPUT C.7
return





	
	
	
	

