clear;
I1=1;
%I2=0.5;
I2=1;

theta=0:180;
u=pi/2*cosd(theta);
S=I1*cos((2*1-1).*u)+I2*cos((2*2-1).*u);
AF=0;

shift=110/180*pi;
AF=I2*exp(1i*0*(pi*cosd(theta)+shift))+I1*exp(1i*1*(pi*cosd(theta)+shift))+I1*exp(1i*2*(pi*cosd(theta)+shift))+I2*exp(1i*3*(pi*cosd(theta)+shift));

Sdb=20*log10(abs(S));
plot(theta-90, Sdb-max(Sdb));
axis([-90,90,-50,0]);
hold on;
AF=20*log10(abs(AF));
plot(theta-90, AF-max(AF));
hold off;
% hold on;

% I1=1;
% I2=1;
% S=I1*cos((2*1-1).*u)+I2*cos((2*2-1).*u);
% Sdb=20*log10(abs(S));
% plot(theta, Sdb-max(Sdb));
% hold off;