import serial
 
ser = serial.Serial()
ser.baudrate = 115200
ser.parity=serial.PARITY_NONE
ser.stopbits=serial.STOPBITS_ONE
ser.bytesize=serial.EIGHTBITS
ser.port = '/dev/ttyUSB0'
ser.open()
 
total = 0
 
printMe=''
while True:
	c = ser.read().decode('utf-8')
	if (c != '\n'):
		printMe+=c
	else:
		print(printMe)
		printMe = ''
		
ser.close()