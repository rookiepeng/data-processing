%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FMCW radar signal processing               %
%  ISAR Video Generator                       %
%                                             %
%  Version 1                                  %
%  Zhengyu Peng                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% system parameters
dataName='corridor2';
chirp=155; % (Hz) frequency of chirp signal
BW=2000E6;
offsetBegin=10;
offsetEnd=950;
thresh = 0.6;

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

avgDC=mean(sif,2);
for jj = 1:size(sif,2);
    sif(:,jj) = sif(:,jj) - avgDC;
end

%% FFT
zpad = 10*N;
[nr,nc]=size(sif);

%RTI plot
figure(1);
sif=sif.*repmat(taylorwin(nc,5,-50)',nr,1);
rp=fft(sif,zpad,2);
spec=abs(rp);
v = 20*log10(spec);
%v = abs(fft(sif,zpad,2));
S = v(:,1:size(v,2)/2);
m = max(max(v));
imagesc(linspace(0,max_range,zpad/2),time,S-m,[-20,0]);
%imagesc(linspace(0,max_range,zpad),time,S/m,[0,1]);
colorbar;
colormap hot;
ylabel('time (s)');
xlabel('range (m)');
title('Range vs. Time Intensity');
axis([1,20,0,max(time)]);

%%
[N_CPI,Nt] = size(rp); % rp are the range profiles stacked in raws
Nchip = 64; % Number of range profiles for each video ISAR image.
Nfft_dop = 512; % Number of Doppler FFT points.

%maximum = max(max(abs(rp)));

%% Generation of ISAR video
fig = figure;
aviobj = VideoWriter('Example_x.avi');
open(aviobj);
for k = 1:(Nchip/2):(N_CPI-Nchip+1)
   rp_chip = rp(k:(k+Nchip-1),:);
   rp_chip = rp_chip.*repmat(hanning(Nchip),1,Nt);
   im = fft(rp_chip,Nfft_dop,1); % Frame of ISAR video
   im = fftshift(im,1);
   maximum=max(max(abs(im)));
   h = imagesc(linspace(0,max_range,zpad/2),linspace(-chirp/2,chirp/2,Nfft_dop),20*log10(abs(im(:,1:size(im,2)/2)/maximum)),[-20 0]);
   colorbar;
   colormap jet;
   axis([0,15,-chirp/2,chirp/2])
   %savefig(strcat('isar-',int2str(k),'.fig'));
   %saveas(fig,strcat('isar-',int2str(k),'.png'));
   F = getframe(fig);
   writeVideo(aviobj,F);
end
close(fig)
close(aviobj);

% fig = figure;
% 
% k=5229;
% 
% rp_chip = rp(k:(k+Nchip-1),:);
% rp_chip = rp_chip.*repmat(hanning(Nchip),1,Nt);
% im = fft(rp_chip,Nfft_dop,1); % Frame of ISAR video
% im = fftshift(im,1);
% h = imagesc(linspace(0,max_range,zpad/2),linspace(-chirp/2,chirp/2,Nfft_dop),20*log10(abs(im(:,1:size(im,2)/2)/maximum)),[-10 0]);
% colorbar;
% colormap jet;
% axis([1,20,-chirp/2,chirp/2]);
% savefig(strcat('isar-',int2str(k),'.fig'));
% saveas(fig,strcat('isar-',int2str(k),'.png'));

% fig=figure;
% for k = 1:(Nchip/2):(N_CPI-Nchip+1)
%    rp_chip = rp(k:(k+Nchip-1),:);
%    rp_chip = rp_chip.*repmat(hanning(Nchip),1,Nt);
%    im = fft(rp_chip,Nfft_dop,1); % Frame of ISAR video
%    im = fftshift(im,1);
%    maximum=max(max(abs(im)));
%    h = imagesc(linspace(0,max_range,zpad/2),linspace(-chirp/2,chirp/2,Nfft_dop),20*log10(abs(im(:,1:size(im,2)/2)/maximum)),[-25 0]);
%    colorbar;
%    colormap jet;
%    axis([0,15,-chirp/2,chirp/2])
%    savefig(strcat('isar-',int2str(k),'.fig'));
%    saveas(fig,strcat('isar-',int2str(k),'.png'));
% end




