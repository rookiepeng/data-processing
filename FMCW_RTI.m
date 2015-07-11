%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FMCW radar signal processing               %
%  Range vs. Time Intensity (RTI) plot        %
%                                             %
%  Version 1                                  %
%  Zhengyu Peng                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% constants
c = 3E8; %(m/s) speed of light

%% system parameters
chirp=88.3; % (Hz) frequency of chirp signal

%% read audio data
[Y,FS] = audioread('Rectest-03.wav');
sync=Y(:,2);
data=Y(:,1);

%% get reference data
% fid = fopen('ref.dat');
% REF = textscan(fid,'%f');
% fclose(fid);
% ref=REF{1}';

%% data prepare
BW=320E6;
offset=0;
%offset=0;
N=fix(FS/chirp)-11;
rr = c/(2*BW);
max_range = rr*fix(FS/chirp)/2;
thresh = 0.4;

%% read labview data
% fid = fopen('backup.lvm');
% C = textscan(fid,'%f%f%f%f');
% fclose(fid);

%%
count=0;
start=(sync<thresh);
for ii = 100:(size(start,1)-N)
    if start(ii) == 1 && mean(start(ii-2:ii-1)) == 0
        %start2(ii) = 1;
        count = count + 1;
        sif(count,:) = data(ii+offset:ii+N-1);
        time(count) = ii*1/FS;
    end
end
% plot(data,'.b');
% hold on;
% plot(start2,'.r');
% hold off;
% grid on;

%% subtract the reference
% for ii = 1:size(sif,1);
%     sif(ii,:) = sif(ii,:) - ref(offset:N-1);
% end

%% subtract the mean
ave = mean(sif,1);
for ii = 1:size(sif,1);
    sif(ii,:) = sif(ii,:) - ave;
end

avey=mean(sif,2);
for jj = 1:size(sif,2);
    sif(:,jj) = sif(:,jj) - avey;
end

%% FFT
zpad = 20*N;

%RTI plot
figure(2);
v = dbv(fft(sif,zpad,2));
%v = abs(fft(sif,zpad,2));
%v = 20*log10(fft(sif,zpad,2));
S = v(:,1:size(v,2)/2);
m = max(max(v));
%imagesc(linspace(0,max_range,zpad),time,S/m,[-20, 0]);
imagesc(linspace(0,max_range,zpad),time,S-m,[-60,0]);
%imagesc(linspace(0,max_range,zpad),time,S/m,[0,0.5]);
colorbar;
colormap hot;
ylabel('time (s)');
xlabel('range (m)');
title('Range vs. Time Intensity');
%axis([0,10,time(1),time(size(time))]);


figure(3);
sif2 = sif(2:size(sif,1),:)-sif(1:size(sif,1)-1,:);
v = fft(sif2,zpad,2);
S=v;
R = linspace(0,max_range,zpad);
for ii = 1:size(S,1)
    %S(ii,:) = S(ii,:).*R.^(3/2); %Optional: magnitude scale to range
end
S = dbv(S(:,1:size(v,2)/2));
m = max(max(S));
imagesc(R,time,S-m,[-70,0]);
colorbar;
ylabel('time (s)');
xlabel('range (m)');
title('RTI with 2-pulse cancelor clutter rejection');

