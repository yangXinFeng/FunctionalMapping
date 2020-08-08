fs=500;
task_name = {'static1','hand1','talk1','name1','name2','talk2','hand2',...
    'static2','static3','hand3','talk3','name3'};
% for n=1:4%length(task_name)
%     line_name=[];
%     figure;
%     for i=1:8
%         y=ECoG_segment.(task_name{n}).data(i,:);
%         N=length(y); %样点个数
%         df=fs/(N-1) ;%分辨率
%         f=(0:N-1)*df;%其中每点的频率
%         Y=fft(y)/N*2;%真实的幅值
%         %Y=fftshift(Y);      
%         plot3(f,i*ones(1,N),abs(Y)); 
%         hold on
%         line_name=[line_name;num2str(i)];
%     end
%     legend(line_name);
%     title([task_name{n} '频谱']);
%     axis([0,45,0,10,0,15])
% end

%各个导联中同一任务的不同重复次数的频率分布
% figure;
% for i=1:8
%     subplot(2,4,i)
%     y=ECoG_segment.static1.data(i,:);%'hand3','talk3','name3'
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot(f,abs(Y)); 
%     hold on
%     y=ECoG_segment.static2.data(i,:);%'hand3','talk3','name3'
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot(f,abs(Y)); 
%     hold on
%     y=ECoG_segment.static3.data(i,:);
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot(f,abs(Y)); 
%     legend('static1','static2','static3');%'hand3','talk3','name3'
%     title(['导联' num2str(i) '频谱']);
%     grid on
%     axis([0,60,0,15])
% end

% figure;
% for i=1:1%8
% %     subplot(2,4,i)
%     y=ECoG_segment.static1.data(i,:);%'hand3','talk3','name3'
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot3(f,0*ones(1,N),abs(Y));  
%     hold on
%     y=ECoG_segment.hand1.data(i,:);%'hand3','talk3','name3'
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot3(f,1*ones(1,N),abs(Y)); 
%     hold on
%     y=ECoG_segment.talk1.data(i,:);%'hand3','talk3','name3'
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot3(f,2*ones(1,N),abs(Y)); 
%     hold on
%     y=ECoG_segment.name1.data(i,:);%'hand3','talk3','name3'
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot3(f,-1*ones(1,N),abs(Y));   
%     legend('static1','hand1','talk1','name1');%'hand3','talk3','name3'
%     title(['导联' num2str(i) '频谱']);
%     grid on
%     axis([0,45,-1,2,0,15])
% end

%同一导联在不同任务时段的频率分布
% figure;
% for i=1:8
%     subplot(2,4,i)
%     y=ECoG_segment.static3.data(i,:);%'hand3','talk3','name3'
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot(f,abs(Y));  
%     hold on
%     y=ECoG_segment.hand3.data(i,1:N-1);%'hand3','talk3','name3'
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot(f,abs(Y)); 
%     hold on
%     y=ECoG_segment.talk3.data(i,:);%'hand3','talk3','name3'
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot(f,abs(Y)); 
%     hold on
%     y=ECoG_segment.name3.data(i,:);%'hand3','talk3','name3'
%     N=length(y); %样点个数
%     df=fs/(N-1) ;%分辨率
%     f=(0:N-1)*df;%其中每点的频率
%     Y=fft(y)/N*2;%真实的幅值
%     %Y=fftshift(Y);
%     plot(f,abs(Y));   
%     legend('static3','hand3','talk3','name3');%'hand3','talk3','name3'
%     title(['导联' num2str(i) '频谱']);
%     grid on
%     axis([0,45,0,15])
% end

% %画多个频率图
% figure;
% fs=500;
% rex=ECoG_segment.static3.swt{1,8};
% for i=1:6 
%     subplot(2,3,i);    
%     y=rex(i+1,:);
%      N=length(y); %样点个数
%      df=fs/(N-1) ;%分辨率
%      f=(0:N-1)*df;%其中每点的频率
%      Y=fft(y)/N*2;%真实的幅值
%      plot(f,abs(Y));  
%      axis([0,100,0,10])
% end


%%
%AR谱
ORDER=10;NFFT=2^14;Fs=500;
name3_pxx=[];talk3_pxx=[];hand3_pxx=[];static3_pxx=[];
for i=1:8
x=ECoG_segment.name3.data(i,:);
[Pxx,W]=pyulear(x,ORDER,NFFT,Fs);
name3_pxx=[name3_pxx;Pxx'];

x=ECoG_segment.talk3.data(i,:);
[Pxx,W]=pyulear(x,ORDER,NFFT,Fs);
talk3_pxx=[talk3_pxx;Pxx'];

x=ECoG_segment.hand3.data(i,:);
[Pxx,W]=pyulear(x,ORDER,NFFT,Fs);
hand3_pxx=[hand3_pxx;Pxx'];

x=ECoG_segment.static3.data(3,:);
[Pxx,W]=pyulear(x,ORDER,NFFT,Fs);
static3_pxx=[static3_pxx;Pxx'];
end
figure;
for i=1:8
subplot(2,4,i);
plot(W,[static3_pxx(i,:);hand3_pxx(i,:);talk3_pxx(i,:);name3_pxx(i,:)]);
legend('static3','hand3','talk3','name3');
title(['导联' num2str(i) 'AR频谱']);
grid on
axis([0,50,0,200]);
end


% figure;
% for i=1:8
%     subplot(2,4,i);
%     plot(W,[static1_pxx(i,:);static2_pxx(i,:);static3_pxx(i,:)]);
%     legend('static1','static2','static3');
%     title(['导联' num2str(i) 'AR频谱']);
%     grid on
%     axis([0,95,0,200]);
% end
% 
% figure;
% for i=1:8
%     subplot(2,4,i);
%     plot(W,[hand1_pxx(i,:);hand2_pxx(i,:);hand3_pxx(i,:)]);
%     legend('hand1','hand2','hand3');
%     title(['导联' num2str(i) 'AR频谱']);
%     grid on
%     axis([0,95,0,200]);
% end
% 
% figure;
% for i=1:8
%     subplot(2,4,i);
%     plot(W,[talk1_pxx(i,:);talk2_pxx(i,:);talk3_pxx(i,:)]);
%     legend('talk1','talk2','talk3');
%     title(['导联' num2str(i) 'AR频谱']);
%     grid on
%     axis([0,95,0,200]);
% end
% 
% figure;
% for i=1:8
%     subplot(2,4,i);
%     plot(W,[name1_pxx(i,:);name2_pxx(i,:);name3_pxx(i,:)]);
%     legend('name1','name2','name3');
%     title(['导联' num2str(i) 'AR频谱']);
%     grid on
%     axis([0,50,0,200]);
% end
    
    
    
    