function plot_frequent(y,fs,upLimitFreq)
N=length(y); %样点个数
t=0:N-1;%采样步长%采样频率
df=fs/(N-1) ;%分辨率
f=(0:N-1)*df;%其中每点的频率
Y=fft(y)/N*2;%真实的幅值
%Y=fftshift(Y);
figure;
plot(f(1:upLimitFreq/df),abs(Y(1:upLimitFreq/df)));
title('频谱');