function [spec, diffspec] = oneDir(FS, sync, data, chirp, BW, zpad,ref)
%% constants
c = 3E8; %(m/s) speed of light

%% data prepare
%BW=300E6;
offset=14;
N=fix(FS/chirp)-78;
rr = c/(2*BW);
thresh = 0.4;

%%
count=0;
start=(sync<thresh);
for ii = 100:(size(start,1)-N)
    if start(ii) == 1 && mean(start(ii-2:ii-1)) == 0
        %start2(ii) = 1;
        count = count + 1;
        sif(count,:) = data(ii+offset:ii+N-1);
        time(count) = ii*1/FS;
    end
end

%% subtract the reference
% for ii = 1:size(sif,1);
%     sif(ii,:) = sif(ii,:) - ref(offset:N-1);
% end

%% subtract the mean
% ave = mean(sif,1);
% for ii = 1:size(sif,1);
%     sif(ii,:) = sif(ii,:) - ave;
% end

avey=mean(sif,2);
for jj = 1:size(sif,2);
    sif(:,jj) = sif(:,jj) - avey;
end

%% average
%avg=mean(sif,1)- ref(offset:N-1);
avg=mean(sif,1);
avg=avg.*taylorwin(length(avg))';
spec=abs(fft(avg,zpad));
%spec=20*log10(spec(1:zpad/2)/max(max(spec)));
spec=20*log10(spec(1:zpad/2));

spect=abs(fft(sif,zpad,2));
diffspec=std(spect,0,1);
%maxdata=max(spect,[],1);
%mindata=min(spect,[],1);
%diffspec=maxdata-mindata;
diffspec=20*log10(diffspec(1:zpad/2));
%f2=(0:zpad-1)*FS/zpad;
%plot(f2(1:zpad/2),spec(1:zpad/2));



