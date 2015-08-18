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
maxOutputFreq=2; % fs/2

%% read audio data
[Y,FS] = audioread('Li-02.wav');
dataI=Y(:,1);
dataQ=Y(:,2);
data=dataI.^2+1i*dataQ.^2;
data=data-mean(data);

%% data prepare
t=linspace(0,length(dataI)/fs,length(dataI)); % time domain axis
rangeMin=fix(1*fs);
rangeMax=fix(48*fs);
N=length(dataI)*2; % length of FFT
f2=(0:N-1)*fs/N; % frequency domain axis


%% STFT
windowSize=12*fs;
overlaps=11.5*fs;
Nfft=windowSize*10;

axis_dp = ((-Nfft/2):(Nfft/2-1))*(fs/Nfft); % Axis in Doppler
[spect,F,Time]=spectrogram(transpose(data),ones(1,windowSize),overlaps,Nfft,fs);
spect=fftshift(spect,1);
figure;
imagesc(Time,axis_dp,20*log10(abs(spect)/max(max(abs(spect)))),[-20 0]);
shading interp;

colorbar;
colormap hot;
xlabel('Time (s)');
ylabel('Doppler frequency (Hz)');
axis([min(Time),max(Time),-2,2]);



