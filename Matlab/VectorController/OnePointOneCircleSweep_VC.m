close all;
clear;

f=24.3e9;
strRegion1='Region1 20151027 134542';
strRegion2='Region2 20151027 134542';
strRegion3='Region3 20151027 134542';
strRegion4='Region4 20151027 134542';

R1=importdata(strRegion1);
R2=importdata(strRegion2);
R3=importdata(strRegion3);
R4=importdata(strRegion4);

VI1=R1(:,1);
VQ1=R1(:,2);
Amp1=R1(:,3);
Phase1=R1(:,4);

VI2=R2(:,1);
VQ2=R2(:,2);
Amp2=R2(:,3);
Phase2=R2(:,4);

VI3=R3(:,1);
VQ3=R3(:,2);
Amp3=R3(:,3);
Phase3=R3(:,4);

VI4=R4(:,1);
VQ4=R4(:,2);
Amp4=R4(:,3);
Phase4=R4(:,4);

figure;
plot(VI1,Phase1);
grid on;
hold on;

%figure;
for i=1:length(Phase2)
    if Phase2(i)>0
        Phase2(i)=Phase2(i)-360;
    end
end
%plot(VQ2,Phase2);
plot(VI1+730,Phase2);
grid on;
hold on;

%figure;
%for i=1:length(Phase3)
 %   if Phase3(i)>0
%        Phase3(i)=Phase3(i)-360;
%    end
%end
Phase3=Phase3-360;
%plot(VI3,Phase3);
plot(VI1+730*2,Phase3);
%set(gca,'XDir','reverse');
grid on;
hold on;

%figure;
Phase4=Phase4-360;
%plot(VQ4,Phase4);
plot(VI1+730*3,Phase4);
%set(gca,'XDir','reverse');
grid on;
hold off;
xlabel('Voltage (mV)');
ylabel('Phase (Degree)');
%axis([770, 1500+730*3,-450,-50]);