%% FTT demo
clear;
A=2; % amplitude of the signal
f=100; % frequency of the signal
fs=1.5e3; % sampling frequency
Ndata=128; % sampling data length
N=1024; % data length for FFT, zero padding if N>Ndata
n=0:Ndata-1;
t=n/fs;
x=A*sin(2*pi*f*t); % signal

% time domain signal without zero padding
figure(1);
subplot(2,2,1);
plot(t,x);
axis([0,(Ndata-1)/fs,-A,A]);
title('Time domain (without zero padding)')
xlabel('Time (s)');
ylabel('Amplitude (V)');

% FFT without zero padding
X1=fft(x);
f1=n*fs/Ndata;
subplot(2,2,2);
plot(f1(1:Ndata/2),abs(X1(1:Ndata/2))/length(x));
title('Frequency domain (without zero padding)')
xlabel('Frequency (Hz)');
ylabel('Amplitude (V)');

% time domian signal with zero padding
y=zeros(1,N);
y(1:length(x))=x;
t1=(0:N-1)/fs;
subplot(2,2,3);
plot(t1,y);
axis([0,(N-1)/fs,-A,A]);
title('Time domain (with zero padding)')
xlabel('Time (s)');
ylabel('Amplitude (V)');

% FFT with zero padding
X2=fft(x,N);
f2=(0:N-1)*fs/N;
subplot(2,2,4);
plot(f2(1:N/2),abs(X2(1:N/2))/length(x));
title('Frequency domain (with zero padding)')
xlabel('Frequency (Hz)');
ylabel('Amplitude (V)');
