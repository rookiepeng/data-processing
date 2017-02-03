clear;

N=20;   % array size
d=0.5;  % spacing

phase=360*rand(1,N);
amp=rand(1,N);

theta=1:0.25:360;
AF=0;
for k=1:N
    AF=AF+amp(k)*exp(1i*2*pi*d*(k-1)*cos(theta*pi/180)+1i*phase(k)*pi/180);
end
AFdb=20*log10(abs(AF));
%plot(theta-90, AFdb-max(AFdb));
%axis([-90,90,-20,0]);
%xlabel('Angle (Degree)');
%ylabel('Normalized Amplitude (dB)');

polar(theta*pi/180,AFdb-max(AFdb));