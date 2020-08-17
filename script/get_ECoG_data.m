% get ECoG data set and segment by task
clc;clear;
% DESCRIPTION
% input mark_file path
% output {mark status,mark time}
% yangXinFeng,20200809
%%
% Setting the file path and subjct name 

% addpath(genpath('../'));

subject_name={'chenkai'; 'weijie';'dayou'};

mark_file_path={ '..\data\testData1\1.ChenKai\Mark.txt';...
    '..\data\testData1\2.weijie\Mark.txt';...
   '..\data\testData1\3.DaiYou\Mark.txt';};

edf_file_path={'..\data\testData1\1.ChenKai\chen~ kai_reduced_reduced.edf';...
    '..\data\testData1\2.weijie\WJ_all2_reduced1.edf';...
    '..\data\testData1\3.DaiYou\dai~ you_reduced_reduced.edf';};

% chenkai_task_name={'static','hand','talk','name'};
% weijie_task_name={'static1','hand1','talk1','name1',...
%     'static2','hand2','talk2','name2'};
% daiyou_task_name = {'static1','hand1','talk1','name1','name2','talk2',...
%     'hand2','static2','static3','hand3','talk3','name3'};
% task_name={chenkai_task_name;weijie_task_name;daiyou_task_name};

chenkai_target = {'name',[2,3,7,8,12,13];...
    'none',[14,15];'vessel',[7,12,18]};
weijie_target = {'talk',[9,10];'none',[11];...
    'hand',[13,14];'name',[12]};
daiyou_target = {'name',[1,2];'talk',[4,5,6];...
    'hand',[7,8];'none',[3]};
electrode_position={chenkai_target;weijie_target;daiyou_target};

%%
% Get data set and segment by task form *.edf file and corresponding Mark.txt
data_set={};
for subject_number=1:length(subject_name)
    data_set(subject_number).subject_name=subject_name{subject_number};
    data_set(subject_number).mark_file_path=mark_file_path{subject_number};
    data_set(subject_number).edf_file_path=edf_file_path{subject_number};
    data_set(subject_number).electrode_position=electrode_position{subject_number};
    
    [~,require_mark]=get_mark(mark_file_path{subject_number});
    if isempty(require_mark)
        disp('Can not get require mark!');
    else
        data_set(subject_number).require_mark=require_mark;
        mark_name={};mark_time=cell2mat(require_mark(:,2));
        for i=1:length(require_mark)/2
            mark_name(i,1)={[strtrim(require_mark{2*i-1,1}),'--',strtrim(require_mark{2*i,1})]};
        end

        data_set(subject_number).segment=get_segment(mark_time,mark_name,edf_file_path{subject_number});
    end
end

% the resulting data set is  visually inspected to avoid unreasonable segment
% this task--static4 do not has enough data point to analyse 
data_set(3).segment(13)=[];

% save data set
file_name = ['data_set_' datestr(now,'yy_mm_dd')];
save(file_name,'data_set');
