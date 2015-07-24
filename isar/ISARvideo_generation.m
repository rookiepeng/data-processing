load XXXX
[N_CPI,Nt] = size(rp); % rp are the range profiles stacked in raws
Nchip = 64; % Number of range profiles for each video ISAR image.
Nfft_dop = 256; % Number of Doppler FFT points.

maximum = max(max(abs(rp)));

% Generation of ISAR video
fig = figure;
aviobj = avifile('Example_x.avi')
for k = 1:(Nchip/16):(N_CPI-Nchip+1)
   k
   rp_chip = rp(k:(k+Nchip-1),:);
   rp_chip = rp_chip.*repmat(hamming(Nchip),1,Nt);
   im = fft(rp_chip,Nfft_dop,1); % Frame of ISAR video
   im = fftshift(im,1);
   h = imagesc(20*log10(abs(im)/maximum),[-32 0]);colorbar
   F = getframe(fig);
   aviobj = addframe(aviobj,F);
end
close(fig)
aviobj = close(aviobj);