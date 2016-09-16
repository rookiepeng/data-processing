%% work with MultiPointMultiCircleSweep_VC.py
%%
close all;
clear;

f=24e9;
count=1;

%% plot all data
figure(1);
for num=1:46
    %figure;
    strRegion1=strcat(int2str(num),'Region1 20160915 163715');
    strRegion2=strcat(int2str(num),'Region2 20160915 163715');
    strRegion3=strcat(int2str(num),'Region3 20160915 163715');
    strRegion4=strcat(int2str(num),'Region4 20160915 163715');

    R1=importdata(strRegion1);
    R2=importdata(strRegion2);
    R3=importdata(strRegion3);
    R4=importdata(strRegion4);
    
    VI1=R1(:,1);
    VQ1=R1(:,2);
    Amp1=R1(:,3);
    Phase1=R1(:,4);

    VI2=R2(:,1);
    VQ2=R2(:,2);
    Amp2=R2(:,3);
    Phase2=R2(:,4);

    VI3=R3(:,1);
    VQ3=R3(:,2);
    Amp3=R3(:,3);
    Phase3=R3(:,4);

    VI4=R4(:,1);
    VQ4=R4(:,2);
    Amp4=R4(:,3);
    Phase4=R4(:,4);
    
    Amp1=10.^(Amp1/20);
    Amp2=10.^(Amp2/20);
    Amp3=10.^(Amp3/20);
    Amp4=10.^(Amp4/20);
    for i=1:length(Amp1)
        if (Amp1(i)>0.162&&Amp1(i)<0.17)
            CirA(count)=Amp1(i);
            CirP(count)=Phase1(i);
            count=count+1;
        end
    end
    for i=1:length(Amp2)
        if (Amp2(i)>0.162&&Amp2(i)<0.17)
            CirA(count)=Amp2(i);
            CirP(count)=Phase2(i);
            count=count+1;
        end
    end
    for i=1:length(Amp3)
        if (Amp3(i)>0.162&&Amp3(i)<0.17)
            CirA(count)=Amp3(i);
            CirP(count)=Phase3(i);
            count=count+1;
        end
    end
    for i=1:length(Amp4)
        if (Amp4(i)>0.162&&Amp4(i)<0.17)
            CirA(count)=Amp4(i);
            CirP(count)=Phase4(i);
            count=count+1;
        end
    end
    
    Amp1=Amp1(1:2:length(Amp1));
    Phase1=Phase1(1:2:length(Phase1));
    x=Amp1.*cos(Phase1/180*pi);
    y=Amp1.*sin(Phase1/180*pi);
    plot(x,y,'b.');
    hold on;
    
    Amp2=Amp2(1:2:length(Amp2));
    Phase2=Phase2(1:2:length(Phase2));
    x=Amp2.*cos(Phase2/180*pi);
    y=Amp2.*sin(Phase2/180*pi);
    plot(x,y,'b.');
    hold on;
    
    Amp3=Amp3(1:2:length(Amp3));
    Phase3=Phase3(1:2:length(Phase3));
    x=Amp3.*cos(Phase3/180*pi);
    y=Amp3.*sin(Phase3/180*pi);
    plot(x,y,'b.');
    
    Amp4=Amp4(1:2:length(Amp4));
    Phase4=Phase4(1:2:length(Phase4));
    x=Amp4.*cos(Phase4/180*pi);
    y=Amp4.*sin(Phase4/180*pi);
    plot(x,y,'b.');
    axis([-0.5,0.5,-0.5,0.5]);
end

%% plot circle one
angle=0:360;
r=0.17;
x=r*cos(angle/180*pi);
y=r*sin(angle/180*pi);
plot(x,y);

%% plot circle two
r=0.3;
x=r*cos(angle/180*pi);
y=r*sin(angle/180*pi);
plot(x,y);
hold off;
axis([-0.5,0.5,-0.5,0.5]);
axis equal;

%%
figure(2);
x=CirA.*cos(CirP/180*pi);
y=CirA.*sin(CirP/180*pi);
plot(x,y,'b.');
axis equal;
axis([-0.2,0.2,-0.2,0.2]);
