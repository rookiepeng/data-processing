#!/usr/bin/python

####
# Automated measurement script for vector controller (Full voltage sweept)
# Python 3.X
#
# Instruments:
#        1) Agilent 8722ES Vector Network Analyzer
#        2) Keysight B2962A Power Source
#        3) Tektronix PS2520G Power Source
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
# Version 3
#
# By: Zhengyu Peng
#     zhengyu.peng@ttu.edu
#     Sep. 14, 2016
####

import datetime
import time
import visa
import os

########### Configuration ###########
voltInit = 350	# mV
voltStep = 5	# mV
voltStepAmp = 5 # mV
voltStop = 800 + voltStepAmp	#mV

Mark=["MARKBUCK528","MARKBUCK544","MARKBUCK560","MARKBUCK576","MARKBUCK592","MARKBUCK608","MARKBUCK624"]
########### /Configuration ###########

MarkNum=len(Mark)
markAmp=["" for i in range(0,MarkNum)]
markPhs=["" for i in range(0,MarkNum)]

now = datetime.datetime.now()
timestamp = now.strftime("%Y%m%d %H%M%S")

rm = visa.ResourceManager()
res = rm.list_resources()
for x in range(0, len(res)):
	print("{}. ".format(x) + res[x] + ", ", end="")
print("\n")

#vnaNumber = input('Select the VNA Number --> ')
vna = rm.open_resource(res[int(2)])
print(vna.query("*IDN?"))

#powerNumber = input('Select the Power Supply Number --> ')
power = rm.open_resource(res[int(4)])
print(power.query("*IDN?"))

#powerNumber = input('Select the Power Supply Number --> ')
powerTek = rm.open_resource(res[int(1)])
print(powerTek.query("*IDN?"))

power.write(":sour1:func:mode volt")
power.write(":sour1:volt "+str(voltInit/1000))
power.write(":sens1:curr:prot 0.2")
power.write(":outp1 on")

power.write(":sour2:func:mode volt")
power.write(":sour2:volt "+str(voltInit/1000))
power.write(":sens2:curr:prot 0.2")
power.write(":outp2 on")

powerTek.write("INSTrument:NSELect 2")	# port 2
powerTek.write("SOURce:VOLTage 0.59")
powerTek.write("SOURce:CURRent 0.8")

powerTek.write("INSTrument:NSELect 3")	# port 3
powerTek.write("SOURce:VOLTage 5.5")
powerTek.write("SOURce:CURRent 0.8")
powerTek.write("OUTPut:STATe ON")

vna.write("S12")	# Measure S21
vna.write("FORM4")	# ASCII Format
vna.write("MARK1")

for dir in range (0, MarkNum, 1):
	if not os.path.exists('MARK'+str(dir)):
		os.makedirs('MARK'+str(dir))

########### /Configuration ###########

count = 0;

for voltInit in range (voltInit, int((voltStop+voltInit)/2), voltStepAmp):
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
		time.sleep(4)	# 5s
		print("        -> Read Log Mag Data")

		for dir in range (0,MarkNum,1):
			vna.write(Mark[dir])
			vna.write("OUTPMARK")
			amp = vna.read_raw()
			amp = amp.decode("utf-8")
			markAmp[dir] = amp[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(0.5)	# 1s
		print("        -> Read Phase Data")

		for dir in range (0,MarkNum,1):
			vna.write(Mark[dir])
			vna.write("OUTPMARK")
			phs = vna.read_raw()
			phs = phs.decode("utf-8")
			markPhs[dir] = phs[1:14]

		for dir in range (0,MarkNum,1):
			famp = open('MARK' + str(dir)+'/' + str(count) + 'Region1 ' + timestamp, 'a')
			famp.write(str(voltmm) + " " + str(voltInit) + " " + markAmp[dir] + " " + markPhs[dir] + "\n" )
			famp.close()


	print("### Region 2 ###")
	for voltmm in range (voltInit, voltStop + voltStep, voltStep):
		volt = voltmm / 1000
		power.write(":sour2:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(4)	# 5s
		print("        -> Read Log Mag Data")
		
		for dir in range (0,MarkNum,1):
			vna.write(Mark[dir])
			vna.write("OUTPMARK")
			amp = vna.read_raw()
			amp = amp.decode("utf-8")
			markAmp[dir] = amp[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(0.5)	# 1s
		print("        -> Read Phase Data")
		
		for dir in range (0,MarkNum,1):
			vna.write(Mark[dir])
			vna.write("OUTPMARK")
			phs = vna.read_raw()
			phs = phs.decode("utf-8")
			markPhs[dir] = phs[1:14]

		for dir in range (0,MarkNum,1):
			famp = open('MARK' + str(dir)+'/' + str(count) + 'Region2 ' + timestamp, 'a')
			famp.write(str(voltStop) + " " +str(voltmm) + " " + markAmp[dir] + " " + markPhs[dir] + "\n" )
			famp.close()

	print("### Region 3 ###")
	for voltmm in range (voltStop, voltInit - voltStep, -voltStep):
		volt = voltmm / 1000
		power.write(":sour1:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(4)	# 5s
		print("        -> Read Log Mag Data")
		
		for dir in range (0,MarkNum,1):
			vna.write(Mark[dir])
			vna.write("OUTPMARK")
			amp = vna.read_raw()
			amp = amp.decode("utf-8")
			markAmp[dir] = amp[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(0.5)	# 1s
		print("        -> Read Phase Data")
		
		for dir in range (0,MarkNum,1):
			vna.write(Mark[dir])
			vna.write("OUTPMARK")
			phs = vna.read_raw()
			phs = phs.decode("utf-8")
			markPhs[dir] = phs[1:14]

		for dir in range (0,MarkNum,1):
			famp = open('MARK' + str(dir)+'/' + str(count) + 'Region3 ' + timestamp, 'a')
			famp.write(str(voltmm) + " " + str(voltStop) + " " + markAmp[dir] + " " + markPhs[dir] + "\n" )
			famp.close()

	print("### Region 4 ###")
	for voltmm in range (voltStop, voltInit - voltStep, -voltStep):
		volt = voltmm / 1000
		power.write(":sour2:volt " + str(volt))
		print("    Current Voltage = " + str(volt) + " V")

		print("    -> Change to Log Mag View")
		vna.write("LOGM")
		time.sleep(4)	# 5s
		print("        -> Read Log Mag Data")
		
		for dir in range (0,MarkNum,1):
			vna.write(Mark[dir])
			vna.write("OUTPMARK")
			amp = vna.read_raw()
			amp = amp.decode("utf-8")
			markAmp[dir] = amp[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(0.5)	# 1s
		print("        -> Read Phase Data")
		
		for dir in range (0,MarkNum,1):
			vna.write(Mark[dir])
			vna.write("OUTPMARK")
			phs = vna.read_raw()
			phs = phs.decode("utf-8")
			markPhs[dir] = phs[1:14]

		for dir in range (0,MarkNum,1):
			famp = open('MARK' + str(dir)+'/' + str(count) + 'Region4 ' + timestamp, 'a')
			famp.write(str(voltInit) + " " + str(voltmm) + " " + markAmp[dir] + " " + markPhs[dir] + "\n" )
			famp.close()

power.write(":outp1 off")
power.write(":outp2 off")
powerTek.write("OUTPut:STATe OFF")
vna.close()
power.close()
powerTek.close()
print("--Finish--")
