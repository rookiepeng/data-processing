close all;
clear;
clc;

%% configuration
dataNum=7; % how many data
chirpFreq=82; % (Hz) frequency of chirp signal
BW=780E6; % bandwidth
fs=44100; % sampling frequency
zPadding=2^14; % zero padding 
offsetBegin=10; % sampling offset, discard bad data
offsetEnd=316;
maxPlotRange=20; % meters
minPlotRange=2; % meters

%% constant number
c = 3E8; %(m/s) speed of light

%% prepare data
N=fix(fs/chirpFreq)-316; % data number in one chirp
rr = c/(2*BW); % range resolution
maxRange = rr*fix(fs/chirpFreq)/2; % maximum range
antennaAngle=-dataNum/2*8+4:8:8*dataNum/2-4; % antenna angle array
antennaAngleRad = antennaAngle*pi/180; % Rad angle
disAxial = linspace(0,maxRange,zPadding/2); % distance axial

%%
ref=0;
% fid = fopen('ref.dat');
% REF = textscan(fid,'%f');
% fclose(fid);
% ref=REF{1}';

%% read data
for i=1:dataNum
    if i<10
        str=strcat('grass person-0',int2str(i),'.wav');
    else
        str=strcat('grass person-',int2str(i),'.wav');
    end
    [Y,fs] = audioread(str);
    [spec(i,:),diffspec(i,:)] = oneDir(fs,Y(:,1),Y(:,2),chirpFreq,BW,zPadding,offsetBegin,offsetEnd,ref);
end

minRange2Index=fix(zPadding/2*minPlotRange/maxRange);
maxRange2Index=fix(zPadding/2*maxPlotRange/maxRange);

X = disAxial(minRange2Index:maxRange2Index)'*cos(antennaAngleRad);
Y = disAxial(minRange2Index:maxRange2Index)'*sin(antennaAngleRad);
spec=spec(:,(minRange2Index:maxRange2Index))-max(max(spec(:,(minRange2Index:maxRange2Index))));
pcolor(Y,X,spec');
colorbar;
axis equal;
%shading interp;
shading flat;

figure;
diffspec=diffspec(:,(minRange2Index:maxRange2Index))-max(max(diffspec(:,(minRange2Index:maxRange2Index))));
pcolor(Y,X,diffspec');
colorbar;
axis equal;
shading interp;