from __future__ import print_function
import serial, os
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import io



ser = serial.Serial('/dev/ttyS7', 500000)

w, h = 1, 1;
matrix = [[0 for x in range(w)] for y in range(h)]

while True:
    # Skip over return chars
    while not ord(ser.read()) == 0:
        pass
    for y in range(h):
        for x in range(w):
            readByte = ser.read()
            if ord(readByte)== 0:
                break
            else:
                print(ord(readByte))

# w, h = 1, 1;
# matrix = [[0 for x in range(w)] for y in range(h)]


# def generate_data():
# 	while not ord(ser.read()) == 0:
# 		pass
# 	for y in range(h):
# 		for x in range(w):
# 			readByte = ser.read()
# 			if  ord(readByte)==0:
# 				break
# 			else:
# 				matrix[y][x]=ord(readByte)
# 	print('\n'.join([''.join(['{:4}'.format(item) for item in row]) 
#       for row in matrix]))
# 	return matrix

# while True:
#     generate_data()

# 77