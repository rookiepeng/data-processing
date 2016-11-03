clear all
close all
clc    

c = 3e8;
fc = 5.4e9;
lambda = c/fc;
duration_time = 100e-3;
duration_time1 = 2e-3;

gb = 5e-3; % guard band

Data = load('data.lvm'); 

time = Data(:,1);
signal_I = Data(:,2);
signal_Q = Data(:,4);
I=signal_I;
Q=signal_Q;
fsample = 1/(time(2)-time(1));

chirp_num = round(duration_time1 * fsample); % calculate the total number of chirps
slop = diff(signal_I,1);    % calculate the 1st order deviation of the time signal, since beat signal has a much larger and faster variation
[pks,locs]=find(abs(slop)>0.1);  % it can expect peaks at the conjonction between interferometry signal and beat signal

gbs =round(gb*fsample);
period = round(length(signal_I)/(duration_time * fsample));
total_num = round(duration_time*fsample);  % calculate how many samples within in one period that takes both beat and interferometry signal


% % % % % % %  locate the begining point of beat signal based on % convolution algorithm % % % % % % % 

FP = slop(1:0.1*fsample);
    sd = zeros(length(FP)-102,1);
    for point = 1:length(FP)-102
        sect = FP(point:point+102);
        sd(point) = std(sect);
    end
    
    [w,g] = max(sd);
    chirp1 = g-1;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% % % % % % % % % % replace the beat signals with linear interpolation % % % % % % % % % % % %

for index=1:period-1
    signal_I(chirp1+total_num*(index-1)-gbs:chirp1+chirp_num+total_num*(index-1)+gbs)=linspace(signal_I(chirp1+total_num*(index-1)-gbs),signal_I(chirp1+chirp_num+total_num*(index-1)+gbs),round(chirp_num+2*gbs+1));
    signal_Q(chirp1+total_num*(index-1)-gbs:chirp1+chirp_num+total_num*(index-1)+gbs)=linspace(signal_Q(chirp1+total_num*(index-1)-gbs),signal_Q(chirp1+chirp_num+total_num*(index-1)+gbs),round(chirp_num+2*gbs+1));
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% % % % % % % % % % average the dechirp signal to further make it smooth % % % % % % % % % %
avg_time = 1e-3;
avg_num = fsample*avg_time;
avg_cyc = round(length(signal_I)/avg_num);
sig_I = zeros(1,avg_cyc);
sig_Q = zeros(1,avg_cyc);
for index =1:avg_cyc-1
    sig_I(index)=(sum(signal_I((index-1)*avg_num+1:index*avg_num)))/avg_num;
    sig_Q(index)=(sum(signal_Q((index-1)*avg_num+1:index*avg_num)))/avg_num;
end

sig_I(end)=sig_I(end-1);
sig_Q(end)=sig_Q(end-1);

d=fdesign.lowpass('Fp,Fst,Ap,Ast',0.01,0.1,1,80);
LP = design(d,'equiripple');
sig_I = filter(LP,sig_I );
sig_Q = filter(LP,sig_Q );

% % % % % % % % % % % % % % % % % % % % % recover the displacement % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
arctangent = (sig_Q-mean(sig_Q))./(sig_I-mean(sig_I));
arctangent = atan(arctangent);
for index = 1:length(arctangent)-1
    if (abs((arctangent(index+1) - arctangent(index))) > (pi*3/4))
        arctangent(index+1) = arctangent(index+1) - (round((arctangent(index+1) - arctangent(index))/pi))*pi;
    end
end
Displacement = arctangent.*lambda./(4*pi)*1;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% % % % % % % % % % % % % % % % % % % % % recover the displacement % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
NL=length(sig_I);
phi=zeros(NL,1); % initial phase info

for i=2:NL
    for k=2:i
    phi(i)=phi(i)+(sig_I(k)*(sig_Q(k)-sig_Q(k-1))-(sig_I(k)-sig_I(k-1))*sig_Q(k))/(sig_I(k)^2+sig_Q(k)^2);
    end
end
disp = phi.*lambda./(4*pi);
% for index = 1:NL
%     phi(index)=phi(index);
% end
% Disp=phi.*lambda./(4*pi);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

fast_time=linspace(0,20,length(I)); % define fast time

% % % % % % % % % % % % % plot original signal % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
figure
hold on
h=plot(fast_time,I,'-b','linewidth',0.5);
h=plot(fast_time,Q,'-r','linewidth',0.5);
set(gca, 'Fontsize', 12);
box on; grid on;
h = xlabel('Time [s]');            set(h, 'Fontsize', 14);
h = ylabel('Voltage [V]');  set(h, 'Fontsize', 14);
hh = get(gca, 'Position');
set(gca, 'Position', hh + [0 0.2 0 -0.4]);
% xlim([0 10]);
% ylim([-0.22 0.22]);

slow_time = linspace(0,length(time)/fsample,avg_cyc);

% % % % % % % % % % % % % plot dechirped signal % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
figure
hold on
h=plot(slow_time,sig_I,'-b','linewidth',2);
h=plot(slow_time,sig_Q,'-r','linewidth',2);
set(gca, 'Fontsize', 12);
box on; grid on;
h = xlabel('Time [s]');            set(h, 'Fontsize', 14);
h = ylabel('Voltage [V]');  set(h, 'Fontsize', 14);
hh = get(gca, 'Position');
set(gca, 'Position', hh + [0 0.2 0 -0.4]);
% xlim([0 10]);
% ylim([-0.22 0.22]);

% d=fdesign.lowpass('Fp,Fst,Ap,Ast',0.01,0.1,1,80);
% LP = design(d,'equiripple');
% Displacement = filter(LP,Displacement );

figure
hold on
h=plot(slow_time,Displacement*100,'-b','linewidth',2);
set(gca, 'Fontsize', 12);
box on; grid on;
h = xlabel('Time (s)');            set(h, 'Fontsize', 14);
h = ylabel('Dispe (cm)');  set(h, 'Fontsize', 14);
hh = get(gca, 'Position');
set(gca, 'Position', hh + [0 0.2 0 -0.4]);

% % % % % % % % % % % % % MicroDoppler calculation % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

L = length(sig_I);
fs = 1/avg_time;

win_len = 20; % define short time FFT length, basiclly it is the sliding window length. Different length will result in different result

% % % % % % % % % % % % % slide the window % % % % % % % % % % % % % % % % % % % % 

% for l=1:1:fix(L./win_len)
% 
% x_I(:,l) = sig_I(win_len*(l-1)+1:win_len*l);
% x_I(:,l) = x_I(:,l) - mean(x_I(:,l));
% 
% x_Q(:,l) = sig_Q(win_len*(l-1)+1:win_len*l);
% x_Q(:,l) = x_Q(:,l) - mean(x_Q(:,l));
% 
% Y_I(win_len*(l-1)+1:win_len*l) = x_I(:,l);
% Y_Q(win_len*(l-1)+1:win_len*l) = x_Q(:,l);
% 
% end
% 
% y_I = Y_I';
% y_Q = Y_Q';
% 
% data_I_new(:,2) = y_I;
% data_I_new(:,1) = 1:1:length(y_I);
% 
% data_Q_new(:,2) = y_Q;
% data_Q_new(:,1) = 1:1:length(y_Q);
% 
% %  data(:,2) = data_I_new(:,2) + 1i*data_Q_new(:,2);
%  data(:,2) = sig_Q + 1i*sig_I;
%   t=(1:length(data_I_new))./fs;
% % 
%  Y = fft(data(:,2)); %fft of the I+j*Q
% 
%  Y1 = fftshift(Y);
%  
%  figure; %specturm plotted directly from FFT result of the function spectruogram
%  subplot(2,4,7);
%  [S F T P] = spectrogram(data(:,2),64,63,512,fs);
% 
% % pcolor(T,F-mean(F),abs(fftshift(S,1)));
% figure
% pcolor(T,F-mean(F),abs(fftshift(S,1)));
% %  ylim([-50 50]);
%  shading interp
%  colormap(hot)
%  %title('FFT amplitude');  
% %  set(gca, 'Fontsize',13);
% %    set (gcf,'size',[1200,400,1200,400]) 
%  xlabel('Time (second)','FontSize',14);
%  ylabel('Frequency (Hz)','FontSize',13);
%  ylim([-50 50])