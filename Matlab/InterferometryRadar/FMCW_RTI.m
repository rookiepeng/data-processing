%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FMCW radar signal processing               %
%  Range vs. Time Intensity (RTI) plot        %
%                                             %
%  Version 2                                  %
%  Zhengyu Peng                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% system parameters
chirp=80; % (Hz) frequency of chirp signal
dataName='glass 3m person-02';
BW=1000E6;
offsetBegin=0;
offsetEnd=316;
thresh = 0.4;

%% constants
c = 3E8; %(m/s) speed of light

%% read audio data
[Y,FS] = audioread(strcat(dataName,'.wav'));
sync=Y(:,1);
data=Y(:,2);

%% data prepare
N=fix(FS/chirp)-offsetEnd;
rr = c/(2*BW);
max_range = rr*fix(FS/chirp)/2;

%%
count=0;
start=(sync<thresh);
for ii = 100:(size(start,1)-N)
    if start(ii) == 1 && mean(start(ii-2:ii-1)) == 0
        %start2(ii) = 1;
        count = count + 1;
        sif(count,:) = data(ii+offsetBegin:ii+N-1);
        time(count) = ii*1/FS;
    end
end
% plot(data,'.b');
% hold on;
% plot(start2,'.r');
% hold off;
% grid on;

%% subtract the reference
% fid = fopen('ref.dat');
% REF = textscan(fid,'%f');
% fclose(fid);
% ref=REF{1}';
% for ii = 1:size(sif,1);
%     sif(ii,:) = sif(ii,:) - ref(offset:N-1);
% end

%% subtract the mean
% ave = mean(sif,1);
% for ii = 1:size(sif,1);
%     sif(ii,:) = sif(ii,:) - ave;
% end

%% subtract the DC
avgDC=mean(sif,2);
for jj = 1:size(sif,2);
    sif(:,jj) = sif(:,jj) - avgDC;
end

%% FFT
zpad = 10*N;
[nr,nc]=size(sif);

%RTI plot
figure;
spec=abs(fft(sif,zpad,2));
v = 20*log10(spec);
%v = abs(fft(sif,zpad,2));
S = v(:,1:size(v,2)/2);
m = max(max(v));
imagesc(linspace(0,max_range,zpad),time,S-m,[-20,0]);
%imagesc(linspace(0,max_range,zpad),time,S/m,[0,1]);
colorbar;
colormap hot;
ylabel('Time (s)');
xlabel('Range (m)');
title('Range vs. Time Intensity');

figure
subplot(3,1,1),plot(linspace(0,max_range,zpad/2),spec(200,1:size(v,2)/2)/max(max(spec(200,1:size(v,2)/2))));
axis([1,12,0,1]);
xlabel('Range (m)');
ylabel('Normalized amplitude (V)');

subplot(3,1,2);
for ii=1:6:nr
    plot(linspace(0,max_range,zpad/2),spec(ii,1:size(v,2)/2)/max(max(spec(ii,1:size(v,2)/2))));
    hold on;
end
hold off;
axis([1,12,0,1]);
xlabel('Range (m)');
ylabel('Normalized amplitude (V)');


diffspec=std(spec,0,1);
subplot(3,1,3),plot(linspace(0,max_range,zpad/2),diffspec(1:size(v,2)/2)/max(max(diffspec(1:size(v,2)/2))));
axis([1,12,0,1]);
xlabel('Range (m)');
ylabel('Normalized amplitude (V)');

%% average
% figure(2)
% avg=mean(sif,1)- ref(offset:N-1);
% avg=avg-mean(avg);
% avgFft=abs(fft(avg,zpad));
% f2=(0:zpad-1)*FS/zpad;
% plot(f2(1:zpad/2),avgFft(1:zpad/2));

% figure(3);
% sif2 = sif(2:size(sif,1),:)-sif(1:size(sif,1)-1,:);
% v = fft(sif2,zpad,2);
% S=v;
% R = linspace(0,max_range,zpad);
% for ii = 1:size(S,1)
%     %S(ii,:) = S(ii,:).*R.^(3/2); %Optional: magnitude scale to range
% end
% S = dbv(S(:,1:size(v,2)/2));
% m = max(max(S));
% imagesc(R,time,S-m,[-70,0]);
% colorbar;
% ylabel('time (s)');
% xlabel('range (m)');
% title('RTI with 2-pulse cancelor clutter rejection');

