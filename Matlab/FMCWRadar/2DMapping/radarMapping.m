close all;
clear;
clc;

%% configuration
dataName='car person1';
dataNum=29; % how many data
chirpFreq=80; % (Hz) frequency of chirp signal
BW=1000E6; % bandwidth
fs=44100; % sampling frequency
zPadding=2^14; % zero padding 
offsetBegin=10; % sampling offset, discard bad data
offsetEnd=316;
maxPlotRange=20; % meters
minPlotRange=1; % meters
angleStep=4;

%% constant number
c = 3E8; %(m/s) speed of light

%% prepare data
N=fix(fs/chirpFreq)-316; % data number in one chirp
rr = c/(2*BW); % range resolution
maxRange = rr*fix(fs/chirpFreq)/2; % maximum range
antennaAngle=-dataNum/2*angleStep+angleStep/2:angleStep:angleStep*dataNum/2-angleStep/2; % antenna angle array
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
        str=strcat(dataName,'-0',int2str(i),'.wav');
    else
        str=strcat(dataName,'-',int2str(i),'.wav');
    end
    [Y,fs] = audioread(str);
    [spec(i,:),diffspec(i,:)] = oneDir(fs,Y(:,1),Y(:,2),chirpFreq,BW,zPadding,offsetBegin,offsetEnd,ref);
end

%spec=flipud(spec);
%diffspec=flipud(diffspec);
minRange2Index=fix(zPadding/2*minPlotRange/maxRange);
maxRange2Index=fix(zPadding/2*maxPlotRange/maxRange);

X = disAxial(minRange2Index:maxRange2Index)'*cos(antennaAngleRad);
Y = disAxial(minRange2Index:maxRange2Index)'*sin(antennaAngleRad);
spec=spec(:,(minRange2Index:maxRange2Index))-max(max(spec(:,(minRange2Index:maxRange2Index))));
pcolor(Y,X,spec');
colorbar;
axis equal;
shading interp;
%shading flat;

figure;
diffspec=diffspec(:,(minRange2Index:maxRange2Index))-max(max(diffspec(:,(minRange2Index:maxRange2Index))));
pcolor(Y,X,diffspec');
colorbar;
axis equal;
shading interp;