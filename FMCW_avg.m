%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FMCW radar signal processing               %
%  Get the average spectrum from FMCW radar   %
%                                             %
%  Version 1                                  %
%  Zhengyu Peng                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% constants
c = 3E8; %(m/s) speed of light

%% system parameters
chirp=5.04; % (Hz) frequency of chirp signal
thresh = 0.4;

%% read audio data
[Y,FS] = audioread('Rectest-01.wav');
sync=Y(:,2);
data=Y(:,1);

%% get reference data
fid = fopen('ref.dat');
REF = textscan(fid,'%f');
fclose(fid);
ref=REF{1}';

%% data prepare
BW=800E6;
%offset=1504;
offset=0;
N=fix(FS/chirp)-551;
rr = c/(2*BW);
max_range = rr*N/2;

%% read labview data
% fid = fopen('backup_1.lvm');
% C = textscan(fid,'%f%f%f%f');
% fclose(fid);
% 
% sync=C{2};
% data=C{4};
% T=C{1};
% FS=44100;

%% 
count=0;
start=(sync<thresh);
for ii = 100:(size(start,1)-N)
    if start(ii) == 1 && mean(start(ii-8:ii-1)) == 0
        flag(ii) = 1; % the beginning of each segment
        count = count + 1;
        sif(count,:) = data(ii+offset:ii+N-1);
        %time(count) = ii*1/FS;
    end
end
plot(data,'.b');
hold on;
plot(flag,'.r');
hold off;
grid on;

%% subtract the reference
% for ii = 1:size(sif,1);
%     sif(ii,:) = sif(ii,:) - ref(offset:N-1);
% end

%% subtract the mean
ave = mean(sif,1);
for ii = 1:size(sif,1);
    sif(ii,:) = sif(ii,:) - ave;
end

%% FFT
zpad = 8*(N-offset)/2; % zero padding
v = abs(fft(sif,zpad,2));
S = v(:,1:size(v,2)/2);
[Row,Column]=size(S);

%% average the spectrum
avg=zeros(1,Column);
for mm=1:Row
    avg=S(mm,:)+avg;
end
avg=avg/Row;

%% plot spectrum
figure(2);
f2=(0:zpad-1)*FS/zpad;
plot(f2(1:zpad/2),avg);
%plot(f2(1:zpad/2),S(4,:));
%axis([60,f2(zpad/2),0,1]);

