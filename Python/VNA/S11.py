#!/usr/bin/python

####
# Automated measurement script for attenuator
# Python 3
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
#
# Version 1
#
# By: Zhengyu Peng
#     zhengyu.peng@ttu.edu
#     Sep. 19, 2015
####

import datetime
import time
import visa

now = now=datetime.datetime.now()
timestamp = now.strftime("%Y%m%d %H%M%S")

rm = visa.ResourceManager()
res = rm.list_resources()
for x in range(0, len(res)):
	print("{}. ".format(x) + res[x] + ", ", end="")
print("\n")

vnaNumber = input('Select the VNA Number --> ')
vna = rm.open_resource(res[int(vnaNumber)])
print(vna.query("*IDN?"))

vna.write("S11")
vna.write("FORM4")

print("-> Change to Log Mag View")
vna.write("LOGM")
time.sleep(5)	# 5s
print("-> Read Log Mag Data")
vna.write("OUTPFORM")
amp = vna.read_raw()
amp = amp.decode("utf-8")
amp = amp.replace('0.000000000000000E+00\n', '')
amp = amp.replace(' ', '')
amp = amp[:len(amp)-1]

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

famp = open('amp ' + timestamp, 'a')
famp.write(amp + "\n")
famp.close()

fphs = open('phs ' + timestamp, 'a')
fphs.write(phs + "\n")
fphs.close()

vna.close()
print("--Finish--")
