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
%timeStart=3; %5 %7 %8
timeStart=10;
timeLength=12.5;
timeStop=0;
fs=44100; % sampling frequency
fcarrier=32; % carrier frequency
maxOutputFreq=2;

%% read audio data
[Y,FS] = audioread('Li-02.wav');
dataI=Y(:,1);
dataQ=Y(:,2);
%data=dataI+1i*dataQ;
if timeStop==0
    timeStop=length(dataI);
end
%data=dataI(timeStart:timeStop)+1i*dataQ(timeStart:timeStop);
%data=dataI(timeStart*FS:timeStart*FS+timeLength*FS)+1i*dataQ(timeStart*FS:timeStart*FS+timeLength*FS);
data=dataI+1i*dataQ;

%% data prepare
t=linspace(0,length(dataI)/fs,length(dataI)); % time domain axis
N=length(dataI)*10; % length of FFT
f2=(0:N-1)*fs/N; % frequency domain axis

%%
figure;
time=0:length(data)-1;
time=time/FS;
subplot(2,1,1),plot(time,real(data));
ylabel('Amplitude (V)');
axis([0,max(time),-1,1]);
subplot(2,1,2),plot(time,imag(data));
xlabel('Time (s)');
ylabel('Amplitude (V)');
axis([0,max(time),-1,1]);

%% FFT of origional
% figure;
% spec=fft(data,N);
% spec=(abs(spec(1:N/2))*2/length(dataI));
% plot(f2(1:N/2),spec);
% axis([0,maxOutputFreq,0,max(spec(1:fix(maxOutputFreq/fs/2*length(f2))))]);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude (V)');
% title('Spectrum of the original signal');

%%
dataE=dataI.^2+1i*dataQ.^2;
%dataE=dataE(timeStart:timeStop);
dataE=dataE(timeStart*FS:timeStart*FS+timeLength*FS);
dataE=dataE-mean(dataE);
%dataE=atan2(real(dataE),imag(dataE));
specE=fft(dataE,N);
specE=(abs(specE(1:N/2))*2/length(dataI));
specE=specE/max(specE);
figure;
plot(f2(1:N/2)*60,28*log10(specE));
%axis([0,maxOutputFreq*60,0,max(specE(1:fix(maxOutputFreq/fs/2*length(f2))))]);
axis([0,maxOutputFreq*60,-25,0]);
xlabel('Beats per Minute');
ylabel('Normalized amplitude (dB)');
title('Respiration Frequency after Envelope Detection');

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

timeStart=7;
timeLength=12.5;
figure;
fid = fopen('li.lvm');
niData = textscan(fid,'%f %f %f %f');
fclose(fid);
time=niData{1}';
niDataI=niData{2}';
niDataQ=niData{4}';

for i=1:length(niDataI)/256
    niDataII(i)=niDataI((i-1)*256+1);
    niDataQQ(i)=niDataQ((i-1)*256+1);
end

niDataII=niDataII;
niDataQQ=niDataQQ;
niDataI=[niDataII,niDataI(length(niDataI)-254:length(niDataI))]';
niDataQ=[niDataQQ,niDataQ(length(niDataQ)-254:length(niDataQ))]';
niDataI=niDataI(timeStart*20:(timeStart+timeLength)*20);
niDataQ=niDataQ(timeStart*20:(timeStart+timeLength)*20);

%niDataI=niDataI(fix(1.5/0.05):fix(15/0.05));
%niDataQ=niDataQ(fix(1.5/0.05):fix(15/0.05));
time1=0:0.05:length(niDataI)*0.05-0.05;
subplot(2,1,1),plot(time1,niDataI);
ylabel('Amplitude (V)');
axis([0,max(time1),1.95,2.3]);
%axis([0,max(time),-1,1]);
subplot(2,1,2),plot(time1,niDataQ);
axis([0,max(time1),2,2.5]);
xlabel('Time (s)');
ylabel('Amplitude (V)');
%axis([0,max(time),-1,1]);

figure;
Npad=4096;
dataB=niDataI+1i*niDataQ;
dataB=dataB-mean(dataB);
dataB=atan2(real(dataB),imag(dataB));
specB=fft(dataB,Npad);
specB=(abs(specB(1:Npad/2))*2/length(dataB));
specB=specB/max(specB);
f3=(0:Npad-1)*20/Npad;
plot(f3(1:Npad/2)*60,20*log10(specB));
%axis([0,maxOutputFreq*60,0,max(specB(1:fix(maxOutputFreq/20/2*length(f3))))]);
axis([0,maxOutputFreq*60,-25,0]);
xlabel('Beats per Minute');
ylabel('Normalized amplitude (dB)');
title('Respiration Frequency without Low-IF');