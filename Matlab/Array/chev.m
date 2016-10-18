%% even
% R0=20;
% N=6;
% x0=((R0+sqrt(R0*R0-1))^(1/(N-1))+(R0+sqrt(R0*R0-1))^(-1/(N-1)))/2
% 
% M=3;
% q=1;
% n=1;
% x1=(-1)^(M-q)*x0^(2*q-1)*factorial(q+M-2)*(2*M-1)/(factorial(q-n)*factorial(q+n-1)*factorial(M-q));
% q=2;
% x2=(-1)^(M-q)*x0^(2*q-1)*factorial(q+M-2)*(2*M-1)/(factorial(q-n)*factorial(q+n-1)*factorial(M-q));
% q=3;
% x3=(-1)^(M-q)*x0^(2*q-1)*factorial(q+M-2)*(2*M-1)/(factorial(q-n)*factorial(q+n-1)*factorial(M-q));
% I1=x1+x2+x3
% 
% n=2;
% q=2;
% x2=(-1)^(M-q)*x0^(2*q-1)*factorial(q+M-2)*(2*M-1)/(factorial(q-n)*factorial(q+n-1)*factorial(M-q));
% q=3;
% x3=(-1)^(M-q)*x0^(2*q-1)*factorial(q+M-2)*(2*M-1)/(factorial(q-n)*factorial(q+n-1)*factorial(M-q));
% I2=x2+x3
% 
% n=3;
% q=3;
% I3=(-1)^(M-q)*x0^(2*q-1)*factorial(q+M-2)*(2*M-1)/(factorial(q-n)*factorial(q+n-1)*factorial(M-q))


%% odd
R0=20;
N=3;
x0=((R0+sqrt(R0*R0-1))^(1/(N-1))+(R0+sqrt(R0*R0-1))^(-1/(N-1)))/2

M=1;
n=1;
q=1;
x1=(-1)^(M-q+1)*x0^(2*(q-1))*factorial(q+M-2)*(2*M)/(2*factorial(q-n)*factorial(q+n-2)*factorial(M-q+1));
q=2;
x2=(-1)^(M-q+1)*x0^(2*(q-1))*factorial(q+M-2)*(2*M)/(2*factorial(q-n)*factorial(q+n-2)*factorial(M-q+1));
I1=x1+x2

n=2;
q=2;
x2=(-1)^(M-q+1)*x0^(2*(q-1))*factorial(q+M-2)*(2*M)/(factorial(q-n)*factorial(q+n-2)*factorial(M-q+1));
I2=x2
