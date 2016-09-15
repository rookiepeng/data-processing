#!/usr/bin/python

####
# Automated measurement script for vector controller (Full voltage sweept)
# Python 3.X
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
########### /Configuration ###########

now = datetime.datetime.now()
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
power.write(":sour1:volt "+str(voltInit/1000))
power.write(":sens1:curr:prot 0.2")
power.write(":outp1 on")

power.write(":sour2:func:mode volt")
power.write(":sour2:volt "+str(voltInit/1000))
power.write(":sens2:curr:prot 0.2")
power.write(":outp2 on")

vna.write("S21")	# Measure S21
vna.write("FORM4")	# ASCII Format

########### Configuration ###########
vna.write("MARK1")	# enable MARK 1
vna.write("MARKBUCK528")  # set the Mark to 640th point, which is 23.3 GHz with the range from 20 GHz to 30 GHz and 1601 points
vna.write("MARK2")	# enable MARK 2
vna.write("MARKBUCK576")  # 23.6 GHz
vna.write("MARK3")	# enable MARK 3
vna.write("MARKBUCK592")  # 23.7 GHz
vna.write("MARK4")	# enable MARK 4
vna.write("MARKBUCK608")  # 23.8 GHz
vna.write("MARK5")	# enable MARK 5
vna.write("MARKBUCK624")  # 23.9 GHz

if not os.path.exists('MARK1'):
    os.makedirs('MARK1')
if not os.path.exists('MARK2'):
    os.makedirs('MARK2')
if not os.path.exists('MARK3'):
    os.makedirs('MARK3')
if not os.path.exists('MARK4'):
    os.makedirs('MARK4')
if not os.path.exists('MARK5'):
    os.makedirs('MARK5')
########### /Configuration ###########

count = 0;

for voltInit in range (voltInit, voltStop, voltStepAmp):
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
		vna.write("OUTPMARK1")
		amp1 = vna.read_raw()
		amp1 = amp1.decode("utf-8")
		markAmp1 = amp1[1:14]

		vna.write("OUTPMARK2")
		amp2 = vna.read_raw()
		amp2 = amp2.decode("utf-8")
		markAmp2 = amp2[1:14]

		vna.write("OUTPMARK3")
		amp3 = vna.read_raw()
		amp3 = amp3.decode("utf-8")
		markAmp3 = amp3[1:14]

		vna.write("OUTPMARK4")
		amp4 = vna.read_raw()
		amp4 = amp4.decode("utf-8")
		markAmp4 = amp4[1:14]

		vna.write("OUTPMARK5")
		amp5 = vna.read_raw()
		amp5 = amp5.decode("utf-8")
		markAmp5 = amp5[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(0.5)	# 1s
		print("        -> Read Phase Data")
		vna.write("OUTPMARK1")
		phs1 = vna.read_raw()
		phs1 = phs1.decode("utf-8")
		markPhs1 = phs1[1:14]

		vna.write("OUTPMARK2")
		phs2 = vna.read_raw()
		phs2 = phs2.decode("utf-8")
		markPhs2 = phs2[1:14]

		vna.write("OUTPMARK3")
		phs3 = vna.read_raw()
		phs3 = phs3.decode("utf-8")
		markPhs3 = phs3[1:14]

		vna.write("OUTPMARK4")
		phs4 = vna.read_raw()
		phs4 = phs4.decode("utf-8")
		markPhs4 = phs4[1:14]

		vna.write("OUTPMARK5")
		phs5 = vna.read_raw()
		phs5 = phs5.decode("utf-8")
		markPhs5 = phs5[1:14]

		famp = open('MARK1/' + str(count) + 'Region1 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltInit) + " " + markAmp1 + " " + markPhs1 + "\n" )
		famp.close()

		famp = open('MARK2/' + str(count) + 'Region1 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltInit) + " " + markAmp2 + " " + markPhs2 + "\n" )
		famp.close()

		famp = open('MARK3/' + str(count) + 'Region1 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltInit) + " " + markAmp3 + " " + markPhs3 + "\n" )
		famp.close()

		famp = open('MARK4/' + str(count) + 'Region1 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltInit) + " " + markAmp4 + " " + markPhs4 + "\n" )
		famp.close()

		famp = open('MARK5/' + str(count) + 'Region1 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltInit) + " " + markAmp5 + " " + markPhs5 + "\n" )
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
		vna.write("OUTPMARK1")
		amp1 = vna.read_raw()
		amp1 = amp1.decode("utf-8")
		markAmp1 = amp1[1:14]

		vna.write("OUTPMARK2")
		amp2 = vna.read_raw()
		amp2 = amp2.decode("utf-8")
		markAmp2 = amp2[1:14]

		vna.write("OUTPMARK3")
		amp3 = vna.read_raw()
		amp3 = amp3.decode("utf-8")
		markAmp3 = amp3[1:14]

		vna.write("OUTPMARK4")
		amp4 = vna.read_raw()
		amp4 = amp4.decode("utf-8")
		markAmp4 = amp4[1:14]

		vna.write("OUTPMARK5")
		amp5 = vna.read_raw()
		amp5 = amp5.decode("utf-8")
		markAmp5 = amp5[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(0.5)	# 1s
		print("        -> Read Phase Data")
		vna.write("OUTPMARK1")
		phs1 = vna.read_raw()
		phs1 = phs1.decode("utf-8")
		markPhs1 = phs1[1:14]

		vna.write("OUTPMARK2")
		phs2 = vna.read_raw()
		phs2 = phs2.decode("utf-8")
		markPhs2 = phs2[1:14]

		vna.write("OUTPMARK3")
		phs3 = vna.read_raw()
		phs3 = phs3.decode("utf-8")
		markPhs3 = phs3[1:14]

		vna.write("OUTPMARK4")
		phs4 = vna.read_raw()
		phs4 = phs4.decode("utf-8")
		markPhs4 = phs4[1:14]

		vna.write("OUTPMARK5")
		phs5 = vna.read_raw()
		phs5 = phs5.decode("utf-8")
		markPhs5 = phs5[1:14]

		famp = open('MARK1/' + str(count) + 'Region2 ' + timestamp, 'a')
		famp.write(str(voltStop) + " " +str(voltmm) + " " + markAmp1 + " " + markPhs1 + "\n" )
		famp.close()

		famp = open('MARK2/' + str(count) + 'Region2 ' + timestamp, 'a')
		famp.write(str(voltStop) + " " +str(voltmm) + " " + markAmp2 + " " + markPhs2 + "\n" )
		famp.close()

		famp = open('MARK3/' + str(count) + 'Region2 ' + timestamp, 'a')
		famp.write(str(voltStop) + " " +str(voltmm) + " " + markAmp3 + " " + markPhs3 + "\n" )
		famp.close()

		famp = open('MARK4/' + str(count) + 'Region2 ' + timestamp, 'a')
		famp.write(str(voltStop) + " " +str(voltmm) + " " + markAmp4 + " " + markPhs4 + "\n" )
		famp.close()

		famp = open('MARK5/' + str(count) + 'Region2 ' + timestamp, 'a')
		famp.write(str(voltStop) + " " +str(voltmm) + " " + markAmp5 + " " + markPhs5 + "\n" )
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
		vna.write("OUTPMARK1")
		amp1 = vna.read_raw()
		amp1 = amp1.decode("utf-8")
		markAmp1 = amp1[1:14]

		vna.write("OUTPMARK2")
		amp2 = vna.read_raw()
		amp2 = amp2.decode("utf-8")
		markAmp2 = amp2[1:14]

		vna.write("OUTPMARK3")
		amp3 = vna.read_raw()
		amp3 = amp3.decode("utf-8")
		markAmp3 = amp3[1:14]

		vna.write("OUTPMARK4")
		amp4 = vna.read_raw()
		amp4 = amp4.decode("utf-8")
		markAmp4 = amp4[1:14]

		vna.write("OUTPMARK5")
		amp5 = vna.read_raw()
		amp5 = amp5.decode("utf-8")
		markAmp5 = amp5[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(0.5)	# 1s
		print("        -> Read Phase Data")
		vna.write("OUTPMARK1")
		phs1 = vna.read_raw()
		phs1 = phs1.decode("utf-8")
		markPhs1 = phs1[1:14]

		vna.write("OUTPMARK2")
		phs2 = vna.read_raw()
		phs2 = phs2.decode("utf-8")
		markPhs2 = phs2[1:14]

		vna.write("OUTPMARK3")
		phs3 = vna.read_raw()
		phs3 = phs3.decode("utf-8")
		markPhs3 = phs3[1:14]

		vna.write("OUTPMARK4")
		phs4 = vna.read_raw()
		phs4 = phs4.decode("utf-8")
		markPhs4 = phs4[1:14]

		vna.write("OUTPMARK5")
		phs5 = vna.read_raw()
		phs5 = phs5.decode("utf-8")
		markPhs5 = phs5[1:14]

		famp = open('MARK1/' + str(count) + 'Region3 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltStop) + " " + markAmp1 + " " + markPhs1 + "\n" )
		famp.close()

		famp = open('MARK2/' + str(count) + 'Region3 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltStop) + " " + markAmp2 + " " + markPhs2 + "\n" )
		famp.close()

		famp = open('MARK3/' + str(count) + 'Region3 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltStop) + " " + markAmp3 + " " + markPhs3 + "\n" )
		famp.close()

		famp = open('MARK4/' + str(count) + 'Region3 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltStop) + " " + markAmp4 + " " + markPhs4 + "\n" )
		famp.close()

		famp = open('MARK5/' + str(count) + 'Region3 ' + timestamp, 'a')
		famp.write(str(voltmm) + " " + str(voltStop) + " " + markAmp5 + " " + markPhs5 + "\n" )
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
		vna.write("OUTPMARK1")
		amp1 = vna.read_raw()
		amp1 = amp1.decode("utf-8")
		markAmp1 = amp1[1:14]

		vna.write("OUTPMARK2")
		amp2 = vna.read_raw()
		amp2 = amp2.decode("utf-8")
		markAmp2 = amp2[1:14]

		vna.write("OUTPMARK3")
		amp3 = vna.read_raw()
		amp3 = amp3.decode("utf-8")
		markAmp3 = amp3[1:14]

		vna.write("OUTPMARK4")
		amp4 = vna.read_raw()
		amp4 = amp4.decode("utf-8")
		markAmp4 = amp4[1:14]

		vna.write("OUTPMARK5")
		amp5 = vna.read_raw()
		amp5 = amp5.decode("utf-8")
		markAmp5 = amp5[1:14]

		print("    -> Change to Phase View")
		vna.write("PHAS")
		time.sleep(0.5)	# 1s
		print("        -> Read Phase Data")
		vna.write("OUTPMARK1")
		phs1 = vna.read_raw()
		phs1 = phs1.decode("utf-8")
		markPhs1 = phs1[1:14]

		vna.write("OUTPMARK2")
		phs2 = vna.read_raw()
		phs2 = phs2.decode("utf-8")
		markPhs2 = phs2[1:14]

		vna.write("OUTPMARK3")
		phs3 = vna.read_raw()
		phs3 = phs3.decode("utf-8")
		markPhs3 = phs3[1:14]

		vna.write("OUTPMARK4")
		phs4 = vna.read_raw()
		phs4 = phs4.decode("utf-8")
		markPhs4 = phs4[1:14]

		vna.write("OUTPMARK5")
		phs5 = vna.read_raw()
		phs5 = phs5.decode("utf-8")
		markPhs5 = phs5[1:14]

		famp = open('MARK1/' + str(count) + 'Region4 ' + timestamp, 'a')
		famp.write(str(voltInit) + " " + str(voltmm) + " " + markAmp1 + " " + markPhs1 + "\n" )
		famp.close()

		famp = open('MARK2/' + str(count) + 'Region4 ' + timestamp, 'a')
		famp.write(str(voltInit) + " " + str(voltmm) + " " + markAmp2 + " " + markPhs2 + "\n" )
		famp.close()

		famp = open('MARK3/' + str(count) + 'Region4 ' + timestamp, 'a')
		famp.write(str(voltInit) + " " + str(voltmm) + " " + markAmp3 + " " + markPhs3 + "\n" )
		famp.close()

		famp = open('MARK4/' + str(count) + 'Region4 ' + timestamp, 'a')
		famp.write(str(voltInit) + " " + str(voltmm) + " " + markAmp4 + " " + markPhs4 + "\n" )
		famp.close()

		famp = open('MARK5/' + str(count) + 'Region4 ' + timestamp, 'a')
		famp.write(str(voltInit) + " " + str(voltmm) + " " + markAmp5 + " " + markPhs5 + "\n" )
		famp.close()

power.write(":outp1 off")
power.write(":outp2 off")
vna.close()
power.close()
print("--Finish--")
