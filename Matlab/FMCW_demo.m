%% FMCW signal processing demo
clear;
A=2; % amplitude of the signal

%% example 1
% f=100; % frequency
% fs=1200; % sample frequency
% Window=14; % window length
% Zlength=0; % zero fill length
% cycles=10; % period cycle number 
% N=1024; % FFT length with zero padding

%% example 2
% f=100; % frequency
% fs=1200; % sample frequency
% Window=12*5+4; % window length
% Zlength=3; % zero fill length
% cycles=10; % period cycle number 
% N=1024; % FFT length with zero padding

%% example 3
% f=100; % frequency
% fs=1200; % sample frequency
% Window=14; % window length
% Zlength=0; % zero fill length
% cycles=1; % period cycle number 
% N=1024; % FFT length with zero padding

%% example 4
f=100; % frequency
fs=1200; % sample frequency
Window=60; % window length
Zlength=0; % zero fill length
cycles=1; % period cycle number 
N=1024; % FFT length with zero padding

%%
n=0:Window-1;
t=n/fs;
x=A*sin(2*pi*f*t);
y=zeros(1,Window+Zlength); 
y(1:length(x))=x;
t1=(0:(Window+Zlength)*cycles-1)/fs;
for n=1:cycles
    x1((n-1)*length(y)+1:length(y)*n)=y;
end

% time domain signal
subplot(3,1,1);
plot(t1,x1);
axis([0,((Window+Zlength)*cycles-1)/fs,-A,A]);
title('Time domain')
xlabel('Time (s)');
ylabel('Amplitude (V)');

% FFT without zero padding
X1=fft(x1);
f1=(0:(Window+Zlength)*cycles-1)*fs/(Window+Zlength)/cycles;
subplot(3,1,2);
plot(f1(1:(Window+Zlength)*cycles/2),abs(X1(1:(Window+Zlength)*cycles/2))*2/(Window+Zlength)/cycles);
axis([0,f1((Window+Zlength)*cycles/2),0,A]);
title('Frequency domain (without zero padding)')
xlabel('Frequency (Hz)');
ylabel('Amplitude (V)');

% FFT with zero padding
X2=fft(x1,N);
f2=(0:N-1)*fs/N;
subplot(3,1,3);
plot(f2(1:N/2),abs(X2(1:N/2))*2/(Window+Zlength)/cycles);
axis([0,f2(N/2),0,A]);
title('Frequency domain (with zero padding)')
xlabel('Frequency (Hz)');
ylabel('Amplitude (V)');
