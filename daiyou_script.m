clc;clear;
daiyou_mark_filename = 'D:\MATLAB_work\EEG\functionalMapping\testData1\3.DaiYou\Mark.txt';
daiyou_edf_filename = 'D:\MATLAB_work\EEG\functionalMapping\testData1\3.DaiYou\dai~ you_reduced_reduced.edf';
daiyou_task_name = {'static1','hand1','talk1','name1','name2','talk2','hand2','static2',...
    'static3','hand3','talk3','name3'};
daiyou_target = {'name',[1,2];'language',[4,5,6];...
    'move',[7,8];'none',[3]};
target=[1 1 2 3 3 3 4 4];
row_mark = GetMark(daiyou_mark_filename);
time=[];mark=[];sl_cluster_set=[];energy_ratio_cluster_set=[];
time=cell2mat(row_mark(:,3));
mark=time(7:30,4:6);%,4:6
task_name=daiyou_task_name;edf_file_name=daiyou_edf_filename;

wavelet_level=7;
wavelet_name='coif3';%'db3';
require_level=5;

analyse_time_window=30;%second

config.TimeDelay=10;   % lag
config.EmbDim=10;   % embedding dimension
config.w1 = 100;  % window (Theiler correction for autocorrelation)
config.w2 = analyse_time_window*500/10;  % window (used to sharpen the time resolution of synchronization measure)
config.pref= 0.05;


% mark=chenkai_mark;
% task_name=chenkai_task_name;
ECoG.etc.eeglabvers = '2019.7'; % this tracks which version of EEGLAB is being used, you may ignore it
% edf_file_name='D:\MATLAB_work\EEG\functionalMapping\testData1\1.ChenKai\chen~ kai_reduced_reduced.edf';
ECoG = pop_biosig(edf_file_name);
ECoG = pop_reref( ECoG, []);
ECoG = eeg_checkset( ECoG );
ECoG = pop_eegfiltnew(ECoG, 'locutoff',49,'hicutoff',51,'revfilt',1,'plotfreqz',1);
ECoG = pop_eegfiltnew(ECoG, 'locutoff',99,'hicutoff',101,'revfilt',1,'plotfreqz',1);
ECoG = eeg_checkset( ECoG );
% ECoG = pop_rmbase( ECoG, [],[]);
% ECoG = eeg_checkset( ECoG );
% plot_frequent(ECoG.data(1,:),500,128)

disp('--raw data start time:--');
disp(ECoG.etc.T0);
tags=[mark(:,1)-ECoG.etc.T0(4) mark(:,2)-ECoG.etc.T0(5) mark(:,3)-ECoG.etc.T0(6)]*[60*60;60;1];
disp('--tags:--')
disp(tags)
for n=1:length(tags)
    [~,i]=sort(abs(ECoG.times-tags(n)*1000));
    index(n)=i(1);
end
disp('--index:--')
disp(index)
for n=1:length(task_name)
    disp(task_name{n});
    ECoG_segment.(task_name{n}).data=ECoG.data(:,index(2*n-1):index(2*n));
    
    s=ECoG_segment.(task_name{n}).data;
%     All_C=[];All_L=[];
    energy_ratio=[];All_swt={};
    [chanel,~]=size(s);   
    for c=1:chanel
%       disp(['chanel:',num2str(c)]);
%       [C,L]=wavedec(s(c,:),wavelet_level,wavelet_name);  
%       [Ea,Ed]=wenergy(C,L);
%       focusSum=sum(Ed(1,wavelet_level-require_level+1:wavelet_level));
%       focusRate=zeros(1,require_level);
%       for i=1:length(focusRate)
%          focusRate(i)=Ed(1,wavelet_level-require_level+i)/focusSum;
%       end    

      swt_s=s(c,:);
      %the length of analyse_time_window
      analyse_time_window_length=floor(length(swt_s)/(2^wavelet_level))*(2^wavelet_level);
      %window the midden of the origin signal
      swt_s=swt_s(round(length(swt_s)/2)-analyse_time_window_length/2+1:round(length(swt_s)/2)+analyse_time_window_length/2);
%       swt_s=swt_s(length(swt_s)-(2^wavelet_level)*floor(length(swt_s)/(2^wavelet_level))+1:end);
      swc=swt(swt_s,wavelet_level,wavelet_name);
      
%       sw2c=swt(swc(2,:),1,wavelet_name);
%       sw3c=swt(swc(3,:),1,wavelet_name);
%       All_swt(c)={[sw2c(2,:);sw3c(2,:);swc(4:7,:)]};
%       square_swc=sum(All_swt{c}.*All_swt{c},2);
%       focusRate=square_swc(1:5)./sum(square_swc(1:5));
      All_swt(c)={swc};
      square_swc=sum(All_swt{c}.*All_swt{c},2);
      focusRate=square_swc(2:6)./sum(square_swc(2:6));
      
      energy_ratio=[energy_ratio;focusRate'];
%       All_C=[All_C;C];All_L=[All_L;L];
    end
    ECoG_segment.(task_name{n}).energy_ratio=energy_ratio;
    ECoG_segment.(task_name{n}).swt=All_swt;
    Y=pdist(energy_ratio);
    Z=linkage(Y);
%     figure;
%     dendrogram(Z);%显示系统聚类树
    T=cluster(Z,'maxclust',length(daiyou_target));
    disp([task_name{n} '能量占比聚类结果：']);
    disp(T');
    energy_ratio_cluster_set=[energy_ratio_cluster_set;n,nmi(target,T'),T'];
%     ECoG_segment.(task_name{n}).C=All_C;
%     ECoG_segment.(task_name{n}).L=All_L;
    
%     All_Z={};
%     for i=1:require_level
%         All_cD=[];
%         for c=1:chanel
% %             cD=detcoef(All_C(c,:),All_L(c,:),i);
%             swc = All_swt{c};
%             cD = swc(i+1,:);
%             All_cD=[All_cD;cD];
%         end
%         RESULT=H_sl(All_cD',config);
%         Z=linkage(squareform(1-RESULT));
%         All_Z(i)={Z};
% %         figure;
% %         dendrogram(Z);%显示系统聚类树
%         T=cluster(Z,'maxclust',length(daiyou_target));
%         disp(['第' num2str(i) '层小波系数聚类结果：']);
%         disp(T');
%         sl_cluster_set=[sl_cluster_set;n,i,nmi(target,T'),T'];
%         
%     end
%     ECoG_segment.(task_name{n}).Z=All_Z;
    
end
