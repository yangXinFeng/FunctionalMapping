clc;clear;
daiyou_mark_filename = 'D:\MATLAB_work\EEG\functionalMapping\testData1\3.DaiYou\Mark.txt';
daiyou_edf_filename = 'D:\MATLAB_work\EEG\functionalMapping\testData1\3.DaiYou\dai~ you_reduced_reduced.edf';
daiyou_task_name = {'static1','hand1','talk1','name1','name2','talk2','hand2','static2',...
    'static3','hand3','talk3','name3'};
daiyou_target = {'name',[1,2];'language',[4,5,6];...
    'move',[7,8];'none',[3]};
target_static=[1 1 2 3 3 3 4 4];traget_name=[1 1 2 2 2 2 2 2];
target_hand=[1 1 1 1 1 1 2 2];target_talk=[1 1 1 2 2 2 1 1];
row_mark = GetMark(daiyou_mark_filename);
time=cell2mat(row_mark(:,3));
mark=time(7:30,4:6);%,4:6
task_name=daiyou_task_name;edf_file_name=daiyou_edf_filename;

sl_cluster_set=[];energy_ratio_cluster_set=[];psd_cluster_set=[];
psd_cluster_set2=[];power_cluster_set2=[];

wavelet_level=7;
wavelet_name='coif3';%'db3';
require_level=6;

analyse_time_window=10;%second

config.TimeDelay=10;   % lag
config.EmbDim=10;   % embedding dimension
config.w1 = 100;  % window (Theiler correction for autocorrelation)
config.w2 = 410;%analyse_time_window*500/10;  % window (used to sharpen the time resolution of synchronization measure)
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
EEG = pop_eegfiltnew(EEG, 'locutoff',2,'hicutoff',128,'plotfreqz',1);
ECoG = eeg_checkset( ECoG );
ECoG = pop_rmbase( ECoG, [],[]);
ECoG = eeg_checkset( ECoG );
% plot_frequent(ECoG.data(1,:),500,128)

disp('--raw data start time:--');disp(ECoG.etc.T0);
tags=[mark(:,1)-ECoG.etc.T0(4) mark(:,2)-ECoG.etc.T0(5) mark(:,3)-ECoG.etc.T0(6)]*[60*60;60;1];
disp('--tags:--');disp(tags);
for n=1:length(tags)
    [~,i]=sort(abs(ECoG.times-tags(n)*1000));
    index(n)=i(1);
end
disp('--index:--');disp(index)
for n=1:length(task_name)
    disp(task_name{n});
    switch task_name{n}(1)
        case 'h'
            target=target_hand;
            cluster_class=2;
        case 'n'
            target=traget_name;
            cluster_class=2;
        case 't'
            target=target_talk;
            cluster_class=2;
        case 's'
            target=target_static;
            cluster_class=length(daiyou_target);
        otherwise
            disp('target error');
            continue;
    end
    
    ECoG_segment.(task_name{n}).data=ECoG.data(:,index(2*n-1):index(2*n));
    
    s=ECoG_segment.(task_name{n}).data;
%     All_C=[];All_L=[];
    energy_ratio=[];All_rex={};psd=[];square_rex=[];
    [chanel,~]=size(s);   
    for c=1:chanel
        
      data=s(c,:);
      
%       %the length of analyse_time_window
%       analyse_time_window_length=ceil(analyse_time_window*ECoG.srate/(2^wavelet_level))*(2^wavelet_level);
%       %window the midden of the origin signal
%       data=data(round(length(data)/2)-analyse_time_window_length/2+1:round(length(data)/2)+analyse_time_window_length/2);
        
      [pxx, f] = pwelch(data, [], [], [], ECoG.srate);
       power_delta = bandpower(pxx, f, [1, 4], 'psd');
       power_theta = bandpower(pxx, f, [4, 8], 'psd');
       power_alpha = bandpower(pxx, f, [8, 14], 'psd');
       power_beta = bandpower(pxx, f, [14, 30], 'psd');
       power_low_gama = bandpower(pxx, f, [30, 45], 'psd');
       power_high_gama = bandpower(pxx, f, [70, 95], 'psd');
       psd=[psd;power_theta power_alpha power_beta power_low_gama power_high_gama];
      
      rex=dwt_rex(data,wavelet_level,wavelet_name);
      All_rex(c)={rex};
      square_rex=[square_rex;sum(rex.*rex,2)'];
%       square_rex=sum(rex.*rex,2);
%       focusRate=square_rex./sum(square_rex);    
%       energy_ratio=[energy_ratio;focusRate'];
%       All_C=[All_C;C];All_L=[All_L;L];
    end
    ECoG_segment.(task_name{n}).square_rex=square_rex;
%     ECoG_segment.(task_name{n}).energy_ratio=energy_ratio;
    ECoG_segment.(task_name{n}).rex=All_rex;
    ECoG_segment.(task_name{n}).psd=psd;
   
    disp('--基于频率相似性--')
    power_X=zeros(size(square_rex,1),size(square_rex,2)-1);
    for ii=1:size(square_rex,1)
        power_X(ii,:)=square_rex(ii,2:end)./sum(square_rex(ii,2:end));
    end
    ECoG_segment.(task_name{n}).energy_ratio=power_X;
    Y=pdist(power_X);
    Z=linkage(Y);
%     figure;
%     dendrogram(Z);%显示系统聚类树
    T=cluster(Z,'maxclust',cluster_class);
    disp([task_name{n} '能量占比聚类结果：']);
    disp(T');
    disp([cluster_class nmi(target,T')]);
    energy_ratio_cluster_set=[energy_ratio_cluster_set;n,nmi(target,T'),T'];
       
    psd_Y=pdist(mapminmax(psd')');
    psd_Z=linkage(psd_Y);
    T=cluster(psd_Z,'maxclust',cluster_class);
    disp([task_name{n} '功率谱密度聚类结果：']);
    disp(T');
    disp([cluster_class,nmi(target,T')]);
    psd_cluster_set=[psd_cluster_set;n,nmi(target,T'),T'];
    
    if cluster_class~=length(daiyou_target)
        T=cluster(Z,'maxclust',length(daiyou_target));
        disp([task_name{n} '能量占比聚类结果：']);
        disp(T');
        disp([length(daiyou_target) nmi(target_static,T')])
        energy_ratio_cluster_set=[energy_ratio_cluster_set;n,nmi(target_static,T'),T'];
        
        T=cluster(psd_Z,'maxclust',length(daiyou_target));
        disp([task_name{n} '功率谱密度聚类结果：']);
        disp(T');
        disp([length(daiyou_target),nmi(target_static,T')]);
        psd_cluster_set=[psd_cluster_set;n,nmi(target_static,T'),T'];
        
        disp('--减去静息基态--');
        psd_X=psd-static_psd;
         psd_Y=pdist(mapminmax(psd_X')');
         psd_Z=linkage(psd_Y);
         T=cluster(psd_Z,'maxclust',cluster_class);
         disp([task_name{n} '减去静息态的功率谱密度聚类结果：']);
         disp(T');
         disp([cluster_class,nmi(target,T')]);
         psd_cluster_set2=[psd_cluster_set2;n,nmi(target,T'),T'];
        
         power_X=square_rex-static_square_rex;
         ECoG_segment.(task_name{n}).sub_energy=power_X;
         power_Y=pdist(mapminmax(power_X')');
         power_Z=linkage(power_Y);
         T=cluster(power_Z,'maxclust',cluster_class);
         disp([task_name{n} '减去静息态的能量占比聚类结果：']);
         disp(T');
         disp([cluster_class,nmi(target,T')]);
         power_cluster_set2=[power_cluster_set2;n,nmi(target,T'),T'];        

         cluster_class=4;target=target_static;
         T=cluster(psd_Z,'maxclust',cluster_class);
         disp([task_name{n} '减去静息态的功率谱密度聚类结果：']);
         disp(T');
         disp([cluster_class,nmi(target,T')]);
         psd_cluster_set2=[psd_cluster_set2;n,nmi(target,T'),T'];

         T=cluster(power_Z,'maxclust',cluster_class);
         disp([task_name{n} '减去静息态的能量占比聚类结果：']);
         disp(T');
         disp([cluster_class,nmi(target,T')]);
         power_cluster_set2=[power_cluster_set2;n,nmi(target,T'),T'];
    else
         static_square_rex=square_rex;
         static_psd=psd;
    end
    

    
%     All_SL={};
%     for i=1:require_level
%         All_cD=[];
%         for c=1:chanel
% %             cD=detcoef(All_C(c,:),All_L(c,:),i);
%             rex = All_rex{c};
%             cD = rex(i,:);
%             All_cD=[All_cD;cD];
%         end
%         RESULT=H_sl(All_cD',config);
%         Z=linkage(squareform(1-RESULT));
%         All_SL(i)={RESULT};
% %         figure;
% %         dendrogram(Z);%显示系统聚类树
%         T=cluster(Z,'maxclust',cluster_class);
%         disp(['第' num2str(i) '层小波系数聚类结果：']);
%         disp(T');
%         disp([cluster_class nmi(target,T')])
%         sl_cluster_set=[sl_cluster_set;n,i,nmi(target,T'),T'];
%         
%         if cluster_class~=length(daiyou_target)
%         T=cluster(Z,'maxclust',length(daiyou_target));
%         disp(['第' num2str(i) '层小波系数聚类结果：']);
%         disp(T');
%         disp([length(daiyou_target) nmi(target_static,T')])
%         sl_cluster_set=[sl_cluster_set;n,i,nmi(target_static,T'),T'];
%     end
%         
%     end
%     ECoG_segment.(task_name{n}).SL=All_SL;
    
end
