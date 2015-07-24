%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Interferometry radar low-IF signal processing  %
%  Range vs. Time Intensity (RTI) plot            %
%                                                 %
%  Version 1                                      %
%  Zhengyu Peng                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%%
fs=44100; % sampling frequency
fcarrier=32; % carrier frequency
maxOutputFreq=5;

%% read audio data
[Y,FS] = audioread('heartbeat-01.wav');
dataI=Y(:,1);
dataQ=Y(:,2);
data=dataI+1i*dataQ;

%% data prepare
t=linspace(0,length(dataI)/fs,length(dataI)); % time domain axis
N=length(dataI)*2; % length of FFT
f2=(0:N-1)*fs/N; % frequency domain axis

%% FFT of origional
spec=fft(data,N);
spec=(abs(spec(1:N/2))*2/length(dataI));
plot(f2(1:N/2),spec);
axis([0,maxOutputFreq,0,max(spec(1:fix(maxOutputFreq/fs/2*length(f2))))]);
xlabel('Frequency (Hz)');
ylabel('Amplitude (V)');
title('Spectrum of the original signal');

%% down-converter
% carrier=sin(2*pi*fcarrier*t)'; % carrier signal
% carrierQ=cos(2*pi*fcarrier*t)';
% downData=data.*carrier; % down convert
% downDataQ=data.*carrierQ;
% downData=downData-mean(downData); % subtract DC
% downDataQ=downDataQ-mean(downDataQ);
% downSpec=fft(downData+1i*downDataQ,N); % FFT
carrier=exp(2*pi*fcarrier*t*1i)'; % carrier signal
downData=data.*carrier; % down convert
downData=downData-mean(downData); % subtract DC
downSpec=fft(downData,N); % FFT

figure;
%plot(f2(1:N/2),20*log10(abs(downSpec(1:N/2))*2/length(dataI)));
plot(f2(1:N/2),(abs(downSpec(1:N/2))*2/length(dataI)));
axis([0,maxOutputFreq,0,abs(max(downSpec(1:fix(maxOutputFreq/fs/2*length(downSpec)))))*2/length(dataI)]);
xlabel('Frequency (Hz)');
ylabel('Amplitude (V)');
title('Spectrum after down convert');