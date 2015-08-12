close all;
clear;
clc;

%% constant number
c = 3E8; %(m/s) speed of light

%% configuration
maxPlotRange=20; % meters
dataNum=7; % data number
chirpFreq=82; % (Hz) frequency of chirp signal
BW=780E6; % bandwidth
fs=44100; % sampling frequency
zPadding=2^14; % zero padding 
offset=0; % sampling offset, discard bad data

%% prepare data
N=fix(fs/chirpFreq)-316; % data number in one chirp
rr = c/(2*BW); % range resolution
maxRange = rr*fix(fs/chirpFreq)/2; % maximum range
antennaAngle=-dataNum/2*8+4:8:8*dataNum/2-4; % antenna angle array
antennaAngleRad = antennaAngle*pi/180; % Rad angle
disAxial = linspace(0,maxRange,zPadding/2); % distance axial

%%
% fid = fopen('ref.dat');
% REF = textscan(fid,'%f');
% fclose(fid);
% ref=REF{1}';
ref=0;

%% read data
for i=1:dataNum
    if i<10
        str=strcat('grass person-0',int2str(i),'.wav');
    else
        str=strcat('grass person-',int2str(i),'.wav');
    end
    [Y,fs] = audioread(str);
    [spec(i,:),diffspec(i,:)] = oneDir(fs,Y(:,1),Y(:,2),chirpFreq,BW,zPadding,ref);
end


X = disAxial(300:fix(zPadding/2*maxPlotRange/maxRange))'*cos(antennaAngleRad);
Y = disAxial(300:fix(zPadding/2*maxPlotRange/maxRange))'*sin(antennaAngleRad);
spec=spec(:,(300:fix(zPadding/2*maxPlotRange/maxRange)))-max(max(spec(:,(300:fix(zPadding/2*maxPlotRange/maxRange)))));
pcolor(Y,X,spec');
axis equal;
shading interp;

figure;
diffspec=diffspec(:,(300:fix(zPadding/2*maxPlotRange/maxRange)))-max(max(diffspec(:,(300:fix(zPadding/2*maxPlotRange/maxRange)))));
pcolor(Y,X,diffspec');
axis equal;
shading interp;