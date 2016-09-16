%% work with Attenuator.py
%%
close all;
clear;

%% configuration
targetF=23.6e9;
strAmp1='amp 20160908 104125';
strPhs1='phs 20160908 104125';

%%
startF=20e9;
stopF=30e9;
deltaF=(stopF-startF)/1600;
Freq=startF:deltaF:stopF;
Voltage=0:1:800;

amp1=importdata(strAmp1);
phs1=importdata(strPhs1);

% strAmp3='amp 20150921 131455';
% amp3=importdata(strAmp3);
% 
% strPhs3='phs 20150921 131455';
% phs3=importdata(strPhs3);

[r,c]=size(amp1);

figure;
for i=1:r
    plot(Freq,amp1(i,:));
    hold on;
end
hold off;
xlabel('Frequency (Hz)');
ylabel('Attenuation (dB)');

figure;
for i=1:r
    plot(Freq,phs1(i,:));
    hold on;
end
hold off;
xlabel('Frequency (Hz)');
ylabel('Phase (degree)');

figure;
fNum=fix((targetF-startF)/deltaF)+1;
plot(Voltage,amp1(:,fNum));
%hold on;
%plot(Voltage,amp2(:,fNum));
%plot(Voltage,amp3(:,fNum));
%hold off;
%legend('Attenuator 1','Attenuator 2');
xlabel('Bias voltage (mV)');
ylabel('Attenuation (dB)');
title('At 24GHz')

figure;
fNum=fix((targetF-startF)/deltaF)+1;
phs1c=phs1(:,fNum);
%phs2c=phs2(:,fNum);
%phs3c=phs3(:,fNum);
for i=1:length(phs1c)
    %if phs1c(i)<0
    %    phs1c(i)=phs1c(i)+360;
    %end
    %if phs2c(i)<0
    %    phs2c(i)=phs2c(i)+360;
    %end
    %if phs3c(i)<0
    %    phs3c(i)=phs3c(i)+360;
    %end
end
plot(Voltage,phs1c-min(phs1c));
%hold on;
%plot(Voltage,phs2c-min(phs1c));
%plot(Voltage,phs3c-min(phs1c));
hold off;
%legend('Attenuator 1','Attenuator 2');
xlabel('Bias voltage (mV)');
ylabel('Phase (degree)');
%title('At 24GHz')

% ampLin1=10.^(amp1/20);
% %ampLin2=10.^(amp2/20);
% figure;
% plot(Voltage,ampLin1(:,fNum)); % y = 1E-15x6 - 7E-12x5 + 2E-08x4 - 2E-05x3 + 0.0101x2 - 3.227x + 428.05
% % y = 3E-08x3 - 0.0001x2 + 0.1685x - 76.51
% %hold on;
% %plot(Voltage,ampLin2(:,fNum));
% %plot(Voltage,ampLin(:,fNum));
% %hold off;
% legend('Attenuator 1','Attenuator 2');
% xlabel('Bias voltage (mV)');
% ylabel('Attenuation');
% title('At 24.3GHz')
