#!/usr/bin/python

####
# Antenna Pattern Measurement
# Python 3.x
#
# Instruments:
#        1) Agilent 8722ES Vector Network Analyzer
#
# Required driver:
#        1) National Instruments 488.2 driver
#
# Required Python Library:
#        1) PyVISA
#
# Saved data file:
#        1) "amp <timestamp>": Amplitude data in dB
#                              V1[amp(f1),amp(f2),...,amp(fn)]
#                              V2[amp(f1),amp(f2),...,amp(fn)]
#                              ...
#                              Vm[amp(f1),amp(f2),...,amp(fn)]
#        2) "phs <timestamp>": Phase data in degree
#                              V1[phs(f1),phs(f2),...,phs(fn)]
#                              V2[phs(f1),phs(f2),...,phs(fn)]
#                              ...
#                              Vm[phs(f1),phs(f2),...,phs(fn)]
#
# Version 1
#
# By: Zhengyu Peng
#     zhengyu.peng@ttu.edu
#     Feb. 25, 2016
####

import datetime
import time
import visa

now = now=datetime.datetime.now()
timestamp = now.strftime("%Y%m%d %H%M%S")

rm = visa.ResourceManager()
res = rm.list_resources()
for x in range(0, len(res)):    # list all the GPIB devices
	print("{}. ".format(x) + res[x] + ", ", end="")
print("\n")

vnaNumber = input('Select the VNA Number --> ') # select the device in use
vna = rm.open_resource(res[int(vnaNumber)])
print(vna.query("*IDN?"))

vna.write("S21")    # select S21
vna.write("FORM4")  # select readout format

angleStart = int(input('Angle start from (Degree) --> '))   #
angleStop = int(input('Angle stop to (Degree) --> '))
angleStep = int(input('Angle rotating step (Degree) --> '))

megName='Meg ' + angleStart + '_' + angleStop + '_' + angleStep + '_' + timestamp
phsName='Phs ' + angleStart + '_' + angleStop + '_' + angleStep + '_' + timestamp

for voltInit in angle (angleStart, angleStop, angleStep):

    measure = input('Press enter to measure ' + str(angle) + ' --> ')
    
    print("-> Change to Log Mag View")
    vna.write("LOGM")
    time.sleep(5)	# 5s
    print("-> Read Log Mag Data")
    vna.write("OUTPFORM")
    meg = vna.read_raw()
    meg = meg.decode("utf-8")
    meg = meg.replace('0.000000000000000E+00\n', '')
    meg = meg.replace(' ', '')
    meg = meg[:len(meg)-1]

    print("-> Change to Phase View")
    vna.write("PHAS")
    time.sleep(1)	# 5s
    print("-> Read Phase Data\n")
    vna.write("OUTPFORM")
    phs = vna.read_raw()
    phs = phs.decode("utf-8")
    phs = phs.replace('0.000000000000000E+00\n', '')
    phs = phs.replace(' ', '')
    phs = phs[:len(phs)-1]

    famp = open(megName, 'a')
    famp.write(meg + "\n")
    famp.close()

    fphs = open(phsName, 'a')
    fphs.write(phs + "\n")
    fphs.close()

#power.write(":outp off")
vna.close()
#power.close()
print("--Finish--")
