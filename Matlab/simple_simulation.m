% A simple FMCW radar-signal simulation (a single scatterer)

% General parameters
c = 3e8; % Speed of light (m/s)

% Radar parameters
fc = 10e9; % Central frequency (Hz)
B = 1e9; % Bandwidth (Hz)
T = 1e-3; % Period interval (s)
CPI = 1; % Coherent Processing Interval (s)

% Target parameters
R0 = 10; % Initial range (m)
v = 4; % Along-LOS speed (m/s)

% Transmitted signal
gamma = B/T; % Chirp rate (Hz/s)
fs = 4*(2*gamma*R0/c); % Sampling frequency
t = -(T/2):(1/fs):(T/2); % Fast-time vector (s)
st = exp(j*(2*pi*fc*t + pi*gamma*t.^2)); % Transmitted signal

% Raw-data matrix
M = length(t); % Length of fast-time vector
N = floor(CPI/T); % Number of slow-time instants
tau = (0:(N-1))*T; % Slow-time vector (s)
raw_data = zeros(N,M);
for n = 1:N
    R = R0 + v * tau(n); % Range of the scatter for the n-th slow-time instant
    delay = 2*R/c; % Delay
    sr = exp(j*(2*pi*fc*(t-delay) + pi*gamma*(t-delay).^2)); % Received signal
    sb = st.*conj(sr); % Beat signal
    raw_data(n,:) = sb;
end

% Range-profile matrix and ISAR image
Nfft = 2048; % Number of FFT points for fast-time
Nfft_dop = 2048; % Even number of FFT points for slow-time
range_axis = (0:(Nfft-1))*(fs/Nfft)*(c/(2*gamma)); % Range axis
Doppler_axis = (-(Nfft_dop/2):(Nfft_dop/2 - 1))*(1/T)/Nfft_dop; % Doppler axis

range_profiles = fft(raw_data,Nfft,2); % Range-profile matrix
ISAR_image = fft(range_profiles,Nfft_dop,1); % ISAR image
ISAR_image = fftshift(ISAR_image,1);

% Plotting
figure;imagesc(range_axis,tau*1e3,20*log10(abs(range_profiles)/max(max(abs(range_profiles)))),[-50 0]);
colorbar; xlabel('Range (m)'); ylabel('Slow-time (ms)');
figure;imagesc(range_axis,Doppler_axis,20*log10(abs(ISAR_image)/max(max(abs(ISAR_image)))),[-50 0]);
colorbar; xlabel('Range (m)'); ylabel('Doppler (Hz)');

