clear all
close all
clc

c = 3e8;
fc = 2.4e9;
lambda = c/fc;

I_data = load('I.lvm');
Q_data = load('Q.lvm');

time = I_data(:,1);
I = I_data(:,2);
Q = Q_data(:,2);

time(257:end)=time(257:end)+12.75;

figure
hold on
h = plot(time,I,'b','linewidth',2);
h = plot(time,Q,'r','linewidth',2);
set(gca, 'Fontsize', 12);
box on; grid on;
h = xlabel('Time (s)');            set(h, 'Fontsize', 14);
h = ylabel('Voltage (V)');  set(h, 'Fontsize', 14);
hh = get(gca, 'Position');
set(gca, 'Position', hh + [0 0.2 0 -0.4]);
% ylim([1.3 1.7]);

arctangent = atan((I-mean(I))./(Q-mean(Q)));
for index = 1:length(arctangent)-1
    if (abs((arctangent(index+1) - arctangent(index))) > (pi*3/4))
        arctangent(index+1) = arctangent(index+1) - (round((arctangent(index+1) - arctangent(index))/pi))*pi;
    end
end
Displacement = arctangent.*lambda./(4*pi)/1.5

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Automatic DC Offset Compensation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data4DC = [I, Q];
result = CircleFitting(Data4DC);
Si = (I - result(1))./result(3);
Sq = (Q - result(2))./result(3);

x=-1:0.001:1; 
figure; % use I/Q signals to plot constellation
plot(x, sqrt(1-x.^2),'color',[0.7 0.7 0.7],'Linewidth',2); 
hold on; 
plot(x, -sqrt(1-x.^2),'color',[0.7 0.7 0.7],'Linewidth',2);
hold on;
plot(Si,Sq); 
hold off;
daspect([1 1 1]);
set(gca,'XTick',-1:0.5:1);set(gca,'YTick',-1:0.5:1);
set(gca, 'Fontsize',14);set(gca,'Linewidth',2);
xlabel('Channel I [V]');ylabel('Channel Q [V]');
axis([-1.5 1.5 -1.5 1.5]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NL=length(Si);
phi=zeros(NL,1); % initial phase info
for i=2:NL
    for k=2:i
    phi(i)=phi(i)+(Si(k)*(Sq(k)-Sq(k-1))-(Si(k)-Si(k-1))*Sq(k))/(Si(k)^2+Sq(k)^2);
    end
end
Disp=phi.*lambda./(4*pi);
Disp = Disp * 100;
figure;
plot(time,Disp-mean(Disp));
xlim([0 max(time)]);
hh = get(gca, 'Position');set(gca, 'Position', hh + [0 0.1 0 -0.3]); %[left bottom width height]
set(gca, 'Fontsize',14);
set(gca,'Linewidth',2);
xlabel('Time [second]');
ylabel('Disp. [cm]');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
h = plot(time,Displacement*100,'b','linewidth',2);
set(gca, 'Fontsize', 12);
box on; grid on;
h = xlabel('Time (s)');            set(h, 'Fontsize', 14);
h = ylabel('Disp (cm)');  set(h, 'Fontsize', 14);
hh = get(gca, 'Position');
set(gca, 'Position', hh + [0 0.2 0 -0.4]);
% ylim([0.7 0.85]);