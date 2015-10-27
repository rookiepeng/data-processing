#!/usr/bin/python

####
# Automated measurement script for vector controller
# Python 3
#
# Instruments:
#        1) Agilent 8722ES Vector Network Analyzer
#        2) Keysight B2962A Power Source
#
# Required driver:
#        1) National Instruments 488.2 driver
#
# Required Python Library:
#        1) PyVISA
#
# Saved data file:
#        1) "Region1 <timestamp>": VI(mV) VQ(mV) Amp(dB) Phase(Degree)
#        1) "Region2 <timestamp>": VI(mV) VQ(mV) Amp(dB) Phase(Degree)
#        1) "Region3 <timestamp>": VI(mV) VQ(mV) Amp(dB) Phase(Degree)
#        1) "Region4 <timestamp>": VI(mV) VQ(mV) Amp(dB) Phase(Degree)
#
#            \   Region4  /
#             \          /
#		  	   \        /
#			    \      /
#			     \    /
#		Region3   \  /   Region1
#                  \/    
#				   /\
#			      /  \
#			     /    \
#			    /      \
#			   /        \
#             /          \
#			 /  Region2   \
#
# Version 1
#
# By: Zhengyu Peng
#     zhengyu.peng@ttu.edu
#     Oct. 26, 2015
####

import datetime
import time
import visa

voltInit = 770	#mV
voltStep = 5	#mV
voltStop = 1500	#mV

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

powerNumber = input('Select the Power Supply Number --> ')
power = rm.open_resource(res[int(powerNumber)])
print(power.query("*IDN?"))

power.write(":sour1:func:mode volt")
power.write(":sour1:volt "+"0.77")
power.write(":sens1:curr:prot 0.08")
power.write(":outp1 on")

power.write(":sour2:func:mode volt")
power.write(":sour2:volt "+"0.77")
power.write(":sens2:curr:prot 0.08")
power.write(":outp2 on")

vna.write("S21")
vna.write("FORM4")
vna.write("MARKBUCK688")


for voltmm in range (voltInit, voltStop + voltStep, voltStep):
	volt = voltmm / 1000
	power.write(":sour1:volt " + str(volt))
	print("Current Voltage = " + str(volt) + " V")

	print("-> Change to Log Mag View")
	vna.write("LOGM")
	time.sleep(5)	# 5s
	print("-> Read Log Mag Data")
	vna.write("OUTPMARK1")
	amp = vna.read_raw()
	amp = amp.decode("utf-8")
	markAmp = amp[1:14]

	print("-> Change to Phase View")
	vna.write("PHAS")
	time.sleep(5)	# 5s
	print("-> Read Phase Data\n")
	vna.write("OUTPMARK1")
	phs = vna.read_raw()
	phs = phs.decode("utf-8")
	markPhs = phs[1:14]

	famp = open('Region1 ' + timestamp, 'a')
	famp.write(str(voltmm) + " " + str(770) + " " + markAmp + " " + markPhs + "\n" )
	famp.close()

for voltmm in range (voltInit, voltStop + voltStep, voltStep):
	volt = voltmm / 1000
	power.write(":sour2:volt " + str(volt))
	print("Current Voltage = " + str(volt) + " V")

	print("-> Change to Log Mag View")
	vna.write("LOGM")
	time.sleep(5)	# 5s
	print("-> Read Log Mag Data")
	vna.write("OUTPMARK1")
	amp = vna.read_raw()
	amp = amp.decode("utf-8")
	markAmp = amp[1:14]

	print("-> Change to Phase View")
	vna.write("PHAS")
	time.sleep(5)	# 5s
	print("-> Read Phase Data\n")
	vna.write("OUTPMARK1")
	phs = vna.read_raw()
	phs = phs.decode("utf-8")
	markPhs = phs[1:14]

	famp = open('Region2 ' + timestamp, 'a')
	famp.write(str(1500) + " " +str(voltmm) + " " + markAmp + " " + markPhs + "\n" )
	famp.close()

for voltmm in range (voltStop, voltInit - voltStep, -voltStep):
	volt = voltmm / 1000
	power.write(":sour1:volt " + str(volt))
	print("Current Voltage = " + str(volt) + " V")

	print("-> Change to Log Mag View")
	vna.write("LOGM")
	time.sleep(5)	# 5s
	print("-> Read Log Mag Data")
	vna.write("OUTPMARK1")
	amp = vna.read_raw()
	amp = amp.decode("utf-8")
	markAmp = amp[1:14]

	print("-> Change to Phase View")
	vna.write("PHAS")
	time.sleep(5)	# 5s
	print("-> Read Phase Data\n")
	vna.write("OUTPMARK1")
	phs = vna.read_raw()
	phs = phs.decode("utf-8")
	markPhs = phs[1:14]

	famp = open('Region3 ' + timestamp, 'a')
	famp.write(str(voltmm) + " " + str(1500) + " " + markAmp + " " + markPhs + "\n" )
	famp.close()

for voltmm in range (voltStop, voltInit - voltStep, -voltStep):
	volt = voltmm / 1000
	power.write(":sour2:volt " + str(volt))
	print("Current Voltage = " + str(volt) + " V")

	print("-> Change to Log Mag View")
	vna.write("LOGM")
	time.sleep(5)	# 5s
	print("-> Read Log Mag Data")
	vna.write("OUTPMARK1")
	amp = vna.read_raw()
	amp = amp.decode("utf-8")
	markAmp = amp[1:14]

	print("-> Change to Phase View")
	vna.write("PHAS")
	time.sleep(5)	# 5s
	print("-> Read Phase Data\n")
	vna.write("OUTPMARK1")
	phs = vna.read_raw()
	phs = phs.decode("utf-8")
	markPhs = phs[1:14]

	famp = open('Region4 ' + timestamp, 'a')
	famp.write(str(770) + " " + str(voltmm) + " " + markAmp + " " + markPhs + "\n" )
	famp.close()

power.write(":outp1 off")
power.write(":outp2 off")
vna.close()
power.close()
print("--Finish--")
