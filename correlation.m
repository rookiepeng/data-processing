clear;
S11=0.16505142-1i*0.36220768;
S21=0.1162764-1i*0.13091481;
S22=0.16505142-1i*0.36220768;
S12=0.1162764-1i*0.13091481;

p=(abs(S11'*S12+S21'*S22))^2/(1-(abs(S11))^2-(abs(S21))^2)/(1-(abs(S22))^2-(abs(S12))^2)