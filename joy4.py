#!/usr/bin/python
import struct,os

x=0
y=0
rx=0
ry=0
buttons=0
output=os.open("/dev/hidg3",os.O_RDWR)
input=open("/dev/input/js3","r")
os.write(output,struct.pack(">hhhhH",x,y,rx,ry,buttons))
while True:
	line = input.read(8)
	unpacked=struct.unpack("Ihbb",line)
	value=unpacked[1]
	type=unpacked[2]
	number=unpacked[3]
	if type == 1: #Button
		if value == 1:
			buttons=buttons + (1 << (number))
		else:
			buttons=buttons - (1 << (number))
	if type == 2: #Axis
		if number == 0:
			x = value
		if number == 1:
			y = value
		if number == 2:
			rx = value
		if number == 3:
			ry = value
	print("x: " + str(x) + " y: " + str(y) + " rx: " + str(rx) + " ry: " + str(ry) + " buttons: " + str(buttons))
	outputStr=struct.pack("<hhhhH",x,y,rx,ry,buttons)
	print(outputStr.encode("hex"))
	os.write(output,outputStr)
