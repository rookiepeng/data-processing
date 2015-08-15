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
timeStart=5.658e5;
timeStop=1.048e6;
fs=44100; % sampling frequency
fcarrier=32; % carrier frequency
maxOutputFreq=3;

%% read audio data
[Y,FS] = audioread('heart-03.wav');
dataI=Y(:,1);
dataQ=Y(:,2);
data=dataI(timeStart:timeStop)+1i*dataQ(timeStart:timeStop);
%data=data(3.42e5:4.1e5);

%% data prepare
t=linspace(0,length(dataI)/fs,length(dataI)); % time domain axis
N=length(dataI)*2; % length of FFT
f2=(0:N-1)*fs/N; % frequency domain axis

%%
figure;
time=0:length(data)-1;
time=time/FS;
subplot(2,1,1),plot(time,real(data));
ylabel('Amplitude (V)');
axis([0,max(time),-0.4,0.4]);
subplot(2,1,2),plot(time,imag(data));
xlabel('Time (s)');
ylabel('Amplitude (V)');
axis([0,max(time),-0.4,0.4]);

%% FFT of origional
figure;
spec=fft(data,N);
spec=(abs(spec(1:N/2))*2/length(dataI));
plot(f2(1:N/2),spec);
axis([0,maxOutputFreq,0,max(spec(1:fix(maxOutputFreq/fs/2*length(f2))))]);
xlabel('Frequency (Hz)');
ylabel('Amplitude (V)');
title('Spectrum of the original signal');

%%
dataE=dataI.^2+1i*dataQ.^2;
dataE=dataE(timeStart:timeStop);
dataE=dataE-mean(dataE);
dataE=atan2(real(dataE),imag(dataE));
specE=fft(dataE,N);
specE=(abs(specE(1:N/2))*2/length(dataI));
specE=specE/max(specE);
figure;
plot(f2(1:N/2)*60,specE);
axis([0,maxOutputFreq*60,0,max(specE(1:fix(maxOutputFreq/fs/2*length(f2))))]);
xlabel('Beats per Minute');
ylabel('Normalized amplitude (V)');
title('Heart Beat Rate after Envelope Detection');

%% down-converter
% carrier=exp(2*pi*fcarrier*t*1i)'; % carrier signal
% downData=data.*carrier; % down convert
% downData=downData-mean(downData); % subtract DC
% downSpec=fft(downData,N); % FFT

% figure;
% %plot(f2(1:N/2),20*log10(abs(downSpec(1:N/2))*2/length(dataI)));
% plot(f2(1:N/2),(abs(downSpec(1:N/2))*2/length(dataI)));
% axis([0,maxOutputFreq,0,abs(max(downSpec(1:fix(maxOutputFreq/fs/2*length(downSpec)))))*2/length(dataI)]);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude (V)');
% title('Spectrum after down convert');