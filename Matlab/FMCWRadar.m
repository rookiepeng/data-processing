clear;
close all;
fc=24e9;
bandwidth=500e6;
%T=2e-3;
%T=1e-9;
dt=30/3e8;
fs=100e9;
T=2000000/fs;
%T=2e-3;
N=T*fs;

t=0:1/fs:T;
%t=2e-3-1/1e10:1/1e13:T;

Tx=sin(2*pi*t.*(bandwidth/T*t/2+fc-bandwidth/2));
Tx2=cos(2*pi*t.*(bandwidth/T*t/2+fc-bandwidth/2));
figure;
plot(0:fs/N:fs,abs(fft(Tx)));
Rx=sin(2*pi*(t-dt).*(bandwidth/T*(t-dt)/2+fc-bandwidth/2));
beat=Tx.*Rx;
figure;
plot(t,beat);
spec=fft(beat);
figure;
f=0:fs/N:fs;
plot(f,abs(spec));

fbeat=bandwidth/T*dt


Rx2=sin(2*pi*(t-dt).*(bandwidth/T*(t-dt)/2+fc-bandwidth/2))+sin(2*pi*(t-dt).*(bandwidth/T*(t-dt)/2+fc-bandwidth/2)).*sin(2*pi*t*3e6);
beat2=Tx.*Rx2-Tx2.*Rx2;
spec2=fft(beat2);
figure;
plot(f,abs(spec2));
