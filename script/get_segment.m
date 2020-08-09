%get segment from raw datas
function ECoG_segment = get_segment(mark,task_name,edf_file_name)
    % DESCRIPTION
    % input: 
    % mark--mark time, for instance:[10 54 36;10 55 23;10 55 33;10 57 13;...]
    % task_name--mark name, for instance:{'static';'hand';'talk';...}
    % edf_file_name--the path of *.edf
    % output :
    % ECoG_segment--a structure of data after segmentation
    % yangXinFeng,20200809
    
%     addpath(genpath('../lib/eeglab2019_1'));
    %%
    % Pretreatment
    % edf_file_name='D:\MATLAB_work\EEG\functionalMapping\testData1\1.ChenKai\chen~ kai_reduced_reduced.edf';
    ECoG = pop_biosig(edf_file_name);
    ECoG = pop_reref( ECoG, []);
    ECoG = eeg_checkset( ECoG );
    ECoG = pop_eegfiltnew(ECoG, 'locutoff',49,'hicutoff',51,'revfilt',1,'plotfreqz',1);
    ECoG = pop_eegfiltnew(ECoG, 'locutoff',99,'hicutoff',101,'revfilt',1,'plotfreqz',1);
    ECoG = pop_eegfiltnew(ECoG, 'locutoff',1,'hicutoff',128,'plotfreqz',1);
    ECoG = eeg_checkset( ECoG );
    ECoG = pop_rmbase( ECoG, [],[]);
    ECoG = eeg_checkset( ECoG );

    %%
    % Segmentation
    disp('--raw data start time:--');
    disp(ECoG.etc.T0);
    if ~mod(length(mark),2)
        tags=[mark(:,1)-ECoG.etc.T0(4) mark(:,2)-ECoG.etc.T0(5) mark(:,3)-ECoG.etc.T0(6)]*[60*60;60;1];
        disp('--tags:--')
        disp(tags)
        for n=1:length(tags)
            [~,i]=sort(abs(ECoG.times-tags(n)*1000));
            index(n)=i(1);
        end
        disp('--index:--')
        disp(index)
        for n=1:length(index)/2
            ECoG_segment(n).data=ECoG.data(:,index(2*n-1):index(2*n));
            ECoG_segment(n).task_name=task_name{n};

    %         s=ECoG_segment.(task_name{n}).data;
    %         matrix=[];
    %         [chanel,~]=size(s);   
    %         for c=1:chanel
    %           disp(['chanel:',num2str(c)]);
    %           [C,L]=wavedec(s(c,:),wavelet_level,wavelet_name);  
    %           [Ea,Ed]=wenergy(C,L);
    %           focusSum=sum(Ed(1,4:wavelet_level));
    %           focusRate=zeros(1,4);
    %           for i=1:length(focusRate)
    %              focusRate(i)=Ed(1,3+i)/focusSum;
    %           end    
    %           matrix=[matrix;focusRate];
    %         end
    %         ECoG_segment.(task_name{n}).energy_ratio=matrix;
        end
    else
        disp('mark error');
        ECoG_segment=[];
    end
end




