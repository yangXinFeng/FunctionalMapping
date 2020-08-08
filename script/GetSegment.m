%%get segment from raw datas
function ECoG_segment = GetSegment(mark,task_name,edf_file_name)
% clc;clear;
% chenkai_mark=[36,3;37,18;
%     38,41;39,22;
%     39,30;40,43;
%     40,49;42,16];
% chenkai_task_name={'static','hand','talk','name'};
% 
% weijie_mark = [24,59;25,48;25,56;26,51;27,11;28,10;29,32;30,22;
%     31,08;32,03;32,18;33,11;33,28;34,26;34,30;35,21];
% weijie_task_name={'static1','hand1','talk1','name1',...
%     'static2','hand2','talk2','name2'};



wavelet_level=7;
wavelet_name='db3';

% mark=chenkai_mark;
% task_name=chenkai_task_name;
ECoG.etc.eeglabvers = '2019.7'; % this tracks which version of EEGLAB is being used, you may ignore it
% edf_file_name='D:\MATLAB_work\EEG\functionalMapping\testData1\1.ChenKai\chen~ kai_reduced_reduced.edf';
ECoG = pop_biosig(edf_file_name);
ECoG = pop_reref( ECoG, []);
ECoG = eeg_checkset( ECoG );
ECoG = pop_eegfiltnew(ECoG, 'locutoff',49,'hicutoff',51,'revfilt',1,'plotfreqz',1);
ECoG = pop_eegfiltnew(ECoG, 'locutoff',99,'hicutoff',101,'revfilt',1,'plotfreqz',1);
ECoG = pop_eegfiltnew(ECoG, 'locutoff',149,'hicutoff',151,'revfilt',1,'plotfreqz',1);
ECoG = eeg_checkset( ECoG );
ECoG = pop_rmbase( ECoG, [],[]);

ECoG = eeg_checkset( ECoG );
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
    ECoG_segment.(task_name{n}).data=ECoG.data(:,index(2*n-1):index(2*n));
    
    s=ECoG_segment.(task_name{n}).data;
    matrix=[];
    [chanel,~]=size(s);   
    for c=1:chanel
      disp(['chanel:',num2str(c)]);
      [C,L]=wavedec(s(c,:),wavelet_level,wavelet_name);  
      [Ea,Ed]=wenergy(C,L);
      focusSum=sum(Ed(1,4:wavelet_level));
      focusRate=zeros(1,4);
      for i=1:length(focusRate)
         focusRate(i)=Ed(1,3+i)/focusSum;
      end    
      matrix=[matrix;focusRate];
    end
    ECoG_segment.(task_name{n}).energy_ratio=matrix;
end

% data=importdata('D:\MATLAB_work\EEG\functionalMapping\testData1\3.DaiYou\Mark.txt');
% begin = 0;
% a={};time=[];
% for n=1:length(data)
%     if begin
%         temp = strsplit(data{n},'  ');
%         %time = [time;datevec(temp{1})];
%         a=[a;temp,datevec(temp{1})];
%     end
%     if strcmp(data{n},'     Time	Title')
%         strsplit(data{n-1},':')
%         begin = 1;
%     end
% end
% daiyou_mark = time(7:30,4:6);
% daiyou_task_name = {'static1','hand1','talk1','name1','name2','talk2','hand2','static2',...
%     'static3','hand3','talk3','name3'};




