#!/usr/bin/python

####
# Automated measurement script for attenuator
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
#     Sep. 19, 2015
####

import datetime
import time
import visa

voltInit = 770	#mV
voltStep = 5	#mV
voltStepAmp = 5 # mV
voltStop = 1500	+ voltStepAmp #mV

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
power.write(":sour1:volt "+"0")
power.write(":sens1:curr:prot 0.2")
power.write(":outp1 on")

power.write(":sour2:func:mode volt")
power.write(":sour2:volt "+"0.77")
power.write(":sens2:curr:prot 0.2")
power.write(":outp2 on")

vna.write("S21")
vna.write("FORM4")

count = 0;

for voltInit in range (770, 1140, voltStepAmp):
	voltStop = voltStop - voltStepAmp
	count = count + 1
	print("######## Voltage range: " + str(voltInit) + "V to " + str(voltStop) + "V ########\n")

	print("### Region 1 ###")
	for voltmm in range (voltInit, voltStop + voltStep, voltStep):
		volt = voltmm / 1000
		power.write(":sour1:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(5)	# 5s
		print("    -> Read Log Mag Data")
		vna.write("OUTPFORM")
		amp = vna.read_raw()
		amp = amp.decode("utf-8")
		amp = amp.replace('0.000000000000000E+00\n', '')
		amp = amp.replace(' ', '')
		amp = amp[:len(amp)-1]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(1)	# 5s
		print("    -> Read Phase Data")
		vna.write("OUTPFORM")
		phs = vna.read_raw()
		phs = phs.decode("utf-8")
		phs = phs.replace('0.000000000000000E+00\n', '')
		phs = phs.replace(' ', '')
		phs = phs[:len(phs)-1]

		famp = open(str(count) + ' amp Region1 ' + timestamp, 'a')
		famp.write(amp + "\n")
		famp.close()

		fphs = open(str(count) + ' phs Region1 ' + timestamp, 'a')
		fphs.write(phs + "\n")
		fphs.close()

	print("### Region 2 ###")
	for voltmm in range (voltInit, voltStop + voltStep, voltStep):
		volt = voltmm / 1000
		power.write(":sour2:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(5)	# 5s
		print("    -> Read Log Mag Data")
		vna.write("OUTPFORM")
		amp = vna.read_raw()
		amp = amp.decode("utf-8")
		amp = amp.replace('0.000000000000000E+00\n', '')
		amp = amp.replace(' ', '')
		amp = amp[:len(amp)-1]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(1)	# 5s
		print("    -> Read Phase Data")
		vna.write("OUTPFORM")
		phs = vna.read_raw()
		phs = phs.decode("utf-8")
		phs = phs.replace('0.000000000000000E+00\n', '')
		phs = phs.replace(' ', '')
		phs = phs[:len(phs)-1]

		famp = open(str(count) + ' amp Region2 ' + timestamp, 'a')
		famp.write(amp + "\n")
		famp.close()

		fphs = open(str(count) + ' phs Region2 ' + timestamp, 'a')
		fphs.write(phs + "\n")
		fphs.close()

	print("### Region 3 ###")
	for voltmm in range (voltStop, voltInit - voltStep, -voltStep):
		volt = voltmm / 1000
		power.write(":sour1:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(5)	# 5s
		print("    -> Read Log Mag Data")
		vna.write("OUTPFORM")
		amp = vna.read_raw()
		amp = amp.decode("utf-8")
		amp = amp.replace('0.000000000000000E+00\n', '')
		amp = amp.replace(' ', '')
		amp = amp[:len(amp)-1]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(1)	# 5s
		print("    -> Read Phase Data")
		vna.write("OUTPFORM")
		phs = vna.read_raw()
		phs = phs.decode("utf-8")
		phs = phs.replace('0.000000000000000E+00\n', '')
		phs = phs.replace(' ', '')
		phs = phs[:len(phs)-1]

		famp = open(str(count) + ' amp Region3 ' + timestamp, 'a')
		famp.write(amp + "\n")
		famp.close()

		fphs = open(str(count) + ' phs Region3 ' + timestamp, 'a')
		fphs.write(phs + "\n")
		fphs.close()

	print("### Region 4 ###")
	for voltmm in range (voltStop, voltInit - voltStep, -voltStep):
		volt = voltmm / 1000
		power.write(":sour2:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(5)	# 5s
		print("    -> Read Log Mag Data")
		vna.write("OUTPFORM")
		amp = vna.read_raw()
		amp = amp.decode("utf-8")
		amp = amp.replace('0.000000000000000E+00\n', '')
		amp = amp.replace(' ', '')
		amp = amp[:len(amp)-1]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(1)	# 5s
		print("    -> Read Phase Data")
		vna.write("OUTPFORM")
		phs = vna.read_raw()
		phs = phs.decode("utf-8")
		phs = phs.replace('0.000000000000000E+00\n', '')
		phs = phs.replace(' ', '')
		phs = phs[:len(phs)-1]

		famp = open(str(count) + ' amp Region4 ' + timestamp, 'a')
		famp.write(amp + "\n")
		famp.close()

		fphs = open(str(count) + ' phs Region4 ' + timestamp, 'a')
		fphs.write(phs + "\n")
		fphs.close()

power.write(":outp1 off")
power.write(":outp2 off")
vna.close()
power.close()
print("--Finish--")
