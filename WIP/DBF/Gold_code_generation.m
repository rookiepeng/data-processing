%Generate Gold Sequences of length 31 by taking the modulo-2 sum of two
%m-sequence generators...............

clear
clc
G=93;  % Code length
x=[];
%...............Generation of first perferred PN sequence............
sd1 =[0 0 0 0 1];      % Initial State of Register.
PS1=[];                       
for j=1:G        
    PS1=[PS1 sd1(5)];
    if sd1(1)==sd1(4)
        temp1=0;
    else temp1=1;
    end
    sd1(1)=sd1(2);
    sd1(2)=sd1(3);
    sd1(3)=sd1(4);
    sd1(4)=sd1(5);
    sd1(5)=temp1;
end
x=[x PS1];


%.................Generation of Second Preferred sequnces..............
PS2=[];
PS2(1)=x(1);
for i=1:30
    j=(3*i)+1;
    PS2(i+1)=x(j);
end
PS2=[PS2];
 
%.................Shifting and Storing of PS1 in Matrix 'y'............

for k=1:31
    for j=1:31
        y(k,j)=x(j+k-1);
    end
end

%..................Generation of Gold Sequences........................

for i=1:31
Gold_Seq(1,:)=[PS1(1,(1:31))];
Gold_Seq(2,:)=[PS2];
Gold_Seq(i+2,:)=xor(PS2,y(i,(1:31)));
end
for j=1:33
subplot(11,3,j)
stem(Gold_Seq(j,:))
axis([1 32 0 1.5])
end
    