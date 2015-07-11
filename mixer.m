clear;
fs = 300;
t = 0:1/300:7;
Ndata=length(t);
%x = (square(2*pi*30*t)+1)/2;
%y = 0.2*(sin(2*pi*0.8*t)+2);
x = square(2*pi*30*t)+1;
y = 0.2*sin(2*pi*0.5*t);
out=x.*y;
%out=x;
figure(1);
plot(t,out);

figure(2);
N=4096*2;
f2=(0:N-1)*fs/N;
fout=abs(fft(out,N));
plot(f2(1:N/2),fout(1:N/2)*2/Ndata);


