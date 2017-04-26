%%%%%%%%%%%

%%Here is a Matlab code that I have written so far..

clear all;
close all;
clc;

tic;

r=1; % Radius (m)
N=16; % Number of Elements
d=2*r*sin(pi/N); % Inter element spacing

s=1; % Number of source signals

noise_var=0;

gamma=2*pi/N*(0:N-1); % Angle between two sensors (wrt origin and ref sensor)

fc=30e3; % Carrier frequency
c=3e8; % Speed of light (m/s)
lambda=c/fc; % wavelength

a_theta=35; % Elevation Angle [0 90]
a_phi=50; % Azimuth angle [0 2pi)

zeta=2*pi/lambda*r*sin(a_theta*pi/180);
A=exp(1i*zeta*cos((a_phi-gamma)*pi/180)).'; % Steering vector

samples=100;
t=(0:samples-1)/1000; % Time

S=sin(2*pi*fc*t);

X=A*S; % Received Signal

noise=sqrt(noise_var/2)*(randn(size(X))+1i*randn(size(X))); % Uncorrelated noise

X=X+noise;

R=X*X'/samples;

[Q,D]=eig(R); % Compute eigendecomposition of covariance matrix
[D,I]=sort(diag(D),1,'descend'); % Find s largest eigenvalues
Q=Q(:,I); % Sort the eigenvectors to put signal eigenvectors first
Qs=Q(:,1:s); % Get the signal eigenvectors
Qn=Q(:,s+1:N); % Get the noise eigenvectors

theta=0:90;
phi=0:1:359;

p_MUSIC=zeros(length(theta),length(phi));

for ii=1:length(theta)
    for iii=1:length(phi)
        zeta=2*pi/lambda*r*sin(theta(ii)*pi/180);
        A=exp(1i*zeta*cos((phi(iii)-gamma)*pi/180)).'; % Steering vector
        p_MUSIC(ii,iii)=(1/(A'*(Qn*Qn')*A));
% p_MUSIC(ii,iii)=(1/norm(A'*Qn));
    end
end

mesh(phi,theta,abs(p_MUSIC))
grid on;xlabel('\phi');ylabel('\theta');zlabel('PMUSIC');title('UCA MUSIC');


toc;