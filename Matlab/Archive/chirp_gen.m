% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%
% This code is to generate the hybrid baseband signal incorporating the
% Linear Frequency Modulated Continuous-Wave (FMCW) base-band signal 
% (chirp signal)and interferometry base-band signal (single tone signal).
%
% For chirp signal, the frequency linearly increases from -FmDev to +FmDev
% within the duration time Tc. For the interferometry signal, the frequency
% keeps the same within duration time Ti.
%
% Code generates a binary files contains the I and Q channels of the hybrid
% signal. This bin file should be loaded to the corresponding LabVIEW code
% running on PXI that equipped with arbitrary waveform generator (AWG). AWG
% will load the files to the PXI on board memory to generate the waveform 
% based on the bind file. Since the AWG will automatically repeat the 
% waveform, in this code, only one complete waveform period is necessary.
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all
close all

FmDev         = 80e6;                      % FM deviation (-f/2 ... +f/2), half bandwidth
Fsample       = 200e6;                       % sample frequecy 200 MHz max sample rate of AWG
ratio = 49;                             % ration of the duration time of interferometry mode to that of FMCW mode
Tc        = 2e-3;                     % duration time of FMCW mode
Ti = ratio*Tc;                        % duration time of interferometry mode
Tsample = 1/Fsample;                     % resulting sample time
Points1 = round( Tc / Tsample );        % resulting number of  chirp waveform points
Points2 = round(Ti/Tsample);             % resulting number of interferometry points

fm1 = linspace(-FmDev,FmDev,Points1);      % define the frequency of FMCW chirp baseband signal

phase1 = 2.0 * pi / Fsample * cumsum(fm1); % convert frequency versus time to phase versus time
I_data1 =  cos( phase1 );   % I channel
Q_data1 =  sin( phase1 );   % Q channel

fm2 = linspace(-FmDev,-FmDev,Points2);        % define the frequency of interferometry baseband signal
phase2 = 2.0 * pi / Fsample * cumsum(fm2);    % convert frequency versus time to phase versus time
I_data2 = cos( phase2 );    % I channel
Q_data2 = sin( phase2 );    % Q channel

I_data = [I_data1, I_data2];    % combine two types of baseband signal in turn
Q_data = [Q_data1, Q_data2];

I = round(I_data * 32767);      % convert the data from floating to int16
Q = round(Q_data * 32767);
C = zeros(1,length(I)+length(Q));  % combine I and Q channels together, decided by AWG
C(1:2:end) = I;
C(2:2:end) = Q;
size = length(C);
% creat the binary file that will be recognized by LabVIEW code
fid = fopen('C.bin','w');           % creat the binary file name and enable write
m5 = fwrite(fid,C,'int16','ieee-le');   % write the data to the file, ieee little-ending format
fclose(fid);                        % close the file
