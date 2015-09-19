#!/usr/bin/python

##
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
# Saved data file:
#        1) "amp": Amplitude data in dB
#                  V1[amp(f1), 0, amp(f2), 0, ... , amp(fn), 0]
#                  V2[amp(f1), 0, amp(f2), 0, ... , amp(fn), 0]
#                  ...
#                  Vm[amp(f1), 0, amp(f2), 0, ... , amp(fn), 0]
#        2) "phs": Phase data in degree
#                  V1[phs(f1), 0, phs(f2), 0, ... , phs(fn), 0]
#                  V2[phs(f1), 0, phs(f2), 0, ... , phs(fn), 0]
#                  ...
#                  Vm[phs(f1), 0, phs(f2), 0, ... , phs(fn), 0]
#
# Version 1
#
# By: Zhengyu Peng
#     zhengyu.peng@ttu.edu
#     Sep. 19, 2015
##

import time
import visa

voltInit = 0	#mV
voltStep = 10	#mV
voltStop = 1400	#mV

rm = visa.ResourceManager()
res = rm.list_resources()
for x in range(0, len(my)):
	print("{}. ".format(x) + res[x] + ", ", end="")

vnaNumber = input('Select the VNA Number --> ')
vna = rm.open_resource(res[vnaNumber])
print(vna.query("*IDN?"))

powerNumber = input('Select the Power Supply Number --> ')
power = rm.open_resource(res[powerNumber])
print(power.query("*IDN?"))

power.write(":sour1:func:mode volt")
power.write(":sour1:volt "+"0")
power.write(":sens1:curr:prot 0.2")
power.write(":outp on")

vna.write(“FORM4“)

for voltmm in range (voltInit, voltStop + voltStep, voltStep):
	volt = voltmm / 1000
	power.write(":sour:volt " + str(volt))
	print("Current Voltage = " + str(volt) + "V\n")

	vna.write("LOGM”)
	time.sleep(5)	# 5s
	vna.write("OUTPFORM")
	amp = vna.read_raw()
	amp = amp.decode("utf-8")
	amp = amp.replace('\n', ',')
	vna.write("PHAS")
	time.sleep(5)	# 5s
	vna.write("OUTPFORM")
	phs = vna.read_raw()
	phs = phs.decode("utf-8")
	phs = phs.replace('\n', ',')

	f=open('amp', 'a')
	f.write(amp + "\n")
	f.close()

	f=open('phs', 'a')
	f.write(phs + "\n")
	f.close()

power.write(":outp off")
vna.close()
power.close()
