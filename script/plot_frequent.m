function plot_frequent(y,fs,upLimitFreq)
N=length(y); %�������
t=0:N-1;%��������%����Ƶ��
df=fs/(N-1) ;%�ֱ���
f=(0:N-1)*df;%����ÿ���Ƶ��
Y=fft(y)/N*2;%��ʵ�ķ�ֵ
%Y=fftshift(Y);
figure;
plot(f(1:upLimitFreq/df),abs(Y(1:upLimitFreq/df)));
title('Ƶ��');