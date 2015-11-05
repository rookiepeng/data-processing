#!/usr/bin/python

####
# Automated measurement script for vector controller (Full voltage sweept)
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
#         "<Number>Region1 <timestamp>": VI(mV) VQ(mV) Amp(dB) Phase(Degree)
#         "<Number>Region2 <timestamp>": VI(mV) VQ(mV) Amp(dB) Phase(Degree)
#         "<Number>Region3 <timestamp>": VI(mV) VQ(mV) Amp(dB) Phase(Degree)
#         "<Number>Region4 <timestamp>": VI(mV) VQ(mV) Amp(dB) Phase(Degree)
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
#     Nov. 05, 2015
####

import datetime
import time
import visa

voltInit = 770	# mV
voltStep = 5	# mV
voltStepAmp = 5 # mV
voltStop = 1500 + voltStepAmp	#mV

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
power.write(":sens1:curr:prot 0.2")
power.write(":outp1 on")

power.write(":sour2:func:mode volt")
power.write(":sour2:volt "+"0.77")
power.write(":sens2:curr:prot 0.2")
power.write(":outp2 on")

vna.write("S21")	# Measure S21
vna.write("FORM4")	# ASCII Format
vna.write("MARK1")	# enable MARK 1
vna.write("MARKBUCK688")  # set the Mark to 688th point, which is 24.3 GHz with the range from 20 GHz to 30 GHz and 1601 points

count = 0;

for voltInit in range (770, 1140, voltStepAmp):
	voltStop = voltStop - voltStepAmp
	count = count + 1
	print("######## Voltage range: " + str(voltInit) + "V to " + str(voltStop) + "V ########\n")

	print("### Region 1 ###")
	for voltmm in range (voltInit, voltStop + voltStep, voltStep):
		volt = voltmm / 1000	# Change to Volt
		power.write(":sour1:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(5)	# 5s
		print("        -> Read Log Mag Data")
		vna.write("OUTPMARK1")
		amp = vna.read_raw()
		amp = amp.decode("utf-8")
		markAmp = amp[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(1)	# 1s
		print("        -> Read Phase Data")
		vna.write("OUTPMARK1")
		phs = vna.read_raw()
		phs = phs.decode("utf-8")
		markPhs = phs[1:14]

		famp = open(str(count) + 'Region1 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltInit) + " " + markAmp + " " + markPhs + "\n" )
		famp.close()

	print("### Region 2 ###")
	for voltmm in range (voltInit, voltStop + voltStep, voltStep):
		volt = voltmm / 1000
		power.write(":sour2:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(5)	# 5s
		print("        -> Read Log Mag Data")
		vna.write("OUTPMARK1")
		amp = vna.read_raw()
		amp = amp.decode("utf-8")
		markAmp = amp[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(1)	# 1s
		print("        -> Read Phase Data")
		vna.write("OUTPMARK1")
		phs = vna.read_raw()
		phs = phs.decode("utf-8")
		markPhs = phs[1:14]

		famp = open(str(count) + 'Region2 ' + timestamp, 'a')
		famp.write(str(voltStop) + " " +str(voltmm) + " " + markAmp + " " + markPhs + "\n" )
		famp.close()

	print("### Region 3 ###")
	for voltmm in range (voltStop, voltInit - voltStep, -voltStep):
		volt = voltmm / 1000
		power.write(":sour1:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(5)	# 5s
		print("        -> Read Log Mag Data")
		vna.write("OUTPMARK1")
		amp = vna.read_raw()
		amp = amp.decode("utf-8")
		markAmp = amp[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(1)	# 1s
		print("        -> Read Phase Data")
		vna.write("OUTPMARK1")
		phs = vna.read_raw()
		phs = phs.decode("utf-8")
		markPhs = phs[1:14]

		famp = open(str(count) + 'Region3 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltStop) + " " + markAmp + " " + markPhs + "\n" )
		famp.close()

	print("### Region 4 ###")
	for voltmm in range (voltStop, voltInit - voltStep, -voltStep):
		volt = voltmm / 1000
		power.write(":sour2:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(5)	# 5s
		print("        -> Read Log Mag Data")
		vna.write("OUTPMARK1")
		amp = vna.read_raw()
		amp = amp.decode("utf-8")
		markAmp = amp[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(1)	# 1s
		print("        -> Read Phase Data")
		vna.write("OUTPMARK1")
		phs = vna.read_raw()
		phs = phs.decode("utf-8")
		markPhs = phs[1:14]

		famp = open(str(count) + 'Region4 ' + timestamp, 'a')
		famp.write(str(voltInit) + " " + str(voltmm) + " " + markAmp + " " + markPhs + "\n" )
		famp.close()

power.write(":outp1 off")
power.write(":outp2 off")
vna.close()
power.close()
print("--Finish--")
