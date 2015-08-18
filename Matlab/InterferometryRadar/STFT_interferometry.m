%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  STFT of Interferometry radar                   %
%                                                 %
%  Version 1                                      %
%  Zhengyu Peng                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%%
fs=44100; % sampling frequency
fcarrier=32; % carrier frequency
maxOutputFreq=fs/2;

%% read audio data
[Y,FS] = audioread('breath back.wav');
dataI=Y(:,1);
dataQ=Y(:,2);
dataI=dataI-mean(dataI);
dataQ=dataQ-mean(dataQ);
data=dataI+1i*dataQ;

%% data prepare
t=linspace(0,length(dataI)/fs,length(dataI)); % time domain axis
rangeMin=fix(1*fs);
rangeMax=fix(48*fs);
N=length(dataI)*2; % length of FFT
f2=(0:N-1)*fs/N; % frequency domain axis

%figure
%plot(t(rangeMin:rangeMax),real(data(rangeMin:rangeMax)));

%% FFT of origional
% spec=fft(data,N);
% spec=(abs(spec(1:N/2))*2/length(dataI));
% figure;
% plot(f2(1:N/2),spec);
% axis([0,maxOutputFreq,0,max(spec(1:fix(maxOutputFreq/fs/2*length(f2))))]);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude (V)');
% title('Spectrum of the original signal');

%% STFT
windowSize=700;
overlaps=600;
Nfft=4096;

axis_dp = ((-Nfft/2):(Nfft/2-1))*(fs/Nfft); % Axis in Doppler
[spect,F,Time]=spectrogram(transpose(data),hanning(windowSize),overlaps,Nfft,fs);
spect=fftshift(spect,1);
figure;
imagesc(Time,axis_dp,20*log10(abs(spect)/max(max(abs(spect)))),[-80 0]);
colorbar;
colormap hot;
xlabel('Time (s)');
ylabel('Doppler frequency (Hz)');

%shifting=100;
% for k=1:fix((length(data)-windowSize)/shifting)
%     tempdata=data((k-1)*shifting+1:(k-1)*shifting+windowSize).*hanning(windowSize);
%     stft(:,k)=fft(tempdata,N);
% end
% 
% stft=fftshift(stft,1);
% stftdB=20*log10(abs(stft));
% stftdB=stftdB-max(max(stftdB));
% time=0:shifting/fs:(fix((length(data)-windowSize)/shifting)-1)*shifting/fs;
% figure;
% imagesc(time,linspace(-fs/2,fs/2,N),stftdB,[-70,0]);
% xlabel('Time (s)');
% ylabel('Doppler (Hz)');
% colorbar;
% colormap hot;


