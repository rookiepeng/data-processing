clear all
close all
clc

c = 3e8;
fc = 5.72e9;
lambda = c/fc;
duration_time = 100e-3;
duration_time1 = 2e-3;

gb = 1e-3; % guard band
num1 = 5;
Data = load('backup_1.lvm');
% Data = csvread('backup.csv');

time = Data(:,1);
signal_Q = Data(:,2);
signal_I = Data(:,4);
I=signal_I;
Q=signal_Q;
fsample = 1/(time(2)-time(1));
length(time)/fsample

chirp_num = round(duration_time1 * fsample)+4;
slop = diff(signal_I,1);
[pks,locs]=find(abs(slop)>0.1);

gbs =round(gb*fsample);
period = round(length(signal_I)/(duration_time * fsample))-1;
total_num = round(duration_time*fsample);

chirp_I = zeros(period,chirp_num);
chirp_Q = zeros(period,chirp_num);
chirp = zeros(period,chirp_num);
% chirp1 = 2871; % data2
% chirp1 = 1933; % data3
chirp1 = 964;

FP = slop(1:0.1*fsample);
sd = zeros(length(FP)-102,1);
for index = 1:length(FP)-102
    sect = FP(index:index+102);
    sd(index) = std(sect);
end

[w,g] = max(sd)

chirp1 = g;

for index = 1:period
    chirp_I(index,:)=signal_I((index-1)*total_num+chirp1:(index-1)*total_num+chirp1+chirp_num-1);
    chirp_Q(index,:)=signal_Q((index-1)*total_num+chirp1:(index-1)*total_num+chirp1+chirp_num-1);
    chirp(index,:) = 1i*chirp_I(index,:)+1*chirp_Q(index,:);
end

adz = 19;
addz = zeros(1,adz*chirp_num);
spectrum = zeros(period,chirp_num*(adz+1));
freq = linspace(0,fsample,chirp_num*(adz+1));
for index = 1:period
    spectrum(index,:)=abs(fft([chirp(index,:) addz]));
end

% num1 = 6;
figure
hold on
% h = plot(freq/1000,spectrum(num1,:),'linewidth',2);
h = plot(freq/1000,spectrum(num1,:)*2/chirp_num,'linewidth',2);
set(gca, 'Fontsize', 12);
box on; grid on;
h = xlabel('Frequency (KHz)');            set(h, 'Fontsize', 14);
h = ylabel('Amplitude (V)');  set(h, 'Fontsize', 14);
hh = get(gca, 'Position');
set(gca, 'Position', hh + [0 0.2 0 -0.4]);
xlim([0 10]);

figure
hold on
h = plot(time,signal_I,'-b','linewidth',2);
h = plot(time,signal_Q,'-r','linewidth',2);
set(gca, 'Fontsize', 12);
box on; grid on;
h = xlabel('Frequency (KHz)');            set(h, 'Fontsize', 14);
h = ylabel('Amplitude (V)');  set(h, 'Fontsize', 14);
hh = get(gca, 'Position');
set(gca, 'Position', hh + [0 0.2 0 -0.4]);
% xlim([0 10]);

% [max,xindex] = (max(spectrum(num1,1:300)))
% freq(xindex)
% output1 = spectrum(num1,:);
% 
% spec = zeros(period-1,chirp_num*(adz+1));
% % for index = 2:period
% %     spec(index-1,:) = abs(fft([chirp(1,:)-chirp(index,:) addz]));
% %     spec(index-1,:)=spec(index-1,:)/max(spec(index-1,:));   % this line can be comment out if simply want standard deviation without normalization
% % end
% for index = 2:period
%     spec(index-1,:)=abs(spectrum(index,:)-spectrum(1,:));
% end
% 
% 
% num2 = 10;
% figure
% hold on
% % h = plot(freq/1000,spec(num2,:)/max(spec(num2,:)),'linewidth',2);
% h = plot(freq/1000,spec,'linewidth',2);
% set(gca, 'Fontsize', 12);
% box on; grid on;
% h = xlabel('Frequency [KHz]');            set(h, 'Fontsize', 14);
% h = ylabel('Amplitude');  set(h, 'Fontsize', 14);
% hh = get(gca, 'Position');
% set(gca, 'Position', hh + [0 0.2 0 -0.4]);
% xlim([0 10]);
% 
% output2 = spec(num2,:);
% 
% FP = I(1:0.1*fsample);
% sd = zeros(length(FP)-102,1);
% for index = 1:length(FP)-102
%     sect = FP(index:index+102);
%     sd(index) = std(sect);
% end
% 
% % [w,g] = max(sd)
% 
% threesigma = zeros(1,length(spec(1,:)));
% 
% for index = 1:length(threesigma)
%     threesigma(index) = std(spec(:,index));
% end
% 
% figure
% hold on
% h = plot(freq/1000,threesigma,'linewidth',2);
% set(gca, 'Fontsize', 12);
% box on; grid on;
% h = xlabel('Frequency [KHz]');            set(h, 'Fontsize', 14);
% h = ylabel('Standard deviation');  set(h, 'Fontsize', 14);
% hh = get(gca, 'Position');
% set(gca, 'Position', hh + [0 0.2 0 -0.4]);
% xlim([0 10]);