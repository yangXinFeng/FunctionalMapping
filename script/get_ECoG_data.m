% get ECoG data set and segment by task
clc;clear;
% DESCRIPTION
% input mark_file path
% output {mark status,mark time}
% yangXinFeng,20200809
%%
% Setting the file path and subjct name 
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
weijie_target = {'language',[9,10];'none',[11];...
    'move',[13,14];'name',[12]};
daiyou_target = {'name',[1,2];'language',[4,5,6];...
    'move',[7,8];'none',[3]};
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

% functional_mapping_data(1).name = 'chenkai';
% functional_mapping_data(1).mark_filename = chenkai_mark_filename ;
% functional_mapping_data(1).edf_filename = chenkai_edf_filename;
% functional_mapping_data(1).task_name = chenkai_task_name;
% functional_mapping_data(1).target = chenkai_target;
% row_mark = GetMark(chenkai_mark_filename);
% time=[];mark=[];
% time=cell2mat(row_mark(:,3));
% mark=time([7,8,11:16],4:6);
% functional_mapping_data(1).mark = mark;
% functional_mapping_data(1).segment = GetSegment(mark,chenkai_task_name,chenkai_edf_filename);
% 
% functional_mapping_data(2).name = 'weijie';
% functional_mapping_data(2).mark_filename = weijie_mark_filename ;
% functional_mapping_data(2).edf_filename = weijie_edf_filename;
% functional_mapping_data(2).task_name = weijie_task_name;
% functional_mapping_data(2).target = weijie_target;
% row_mark = GetMark(weijie_mark_filename);
% time=[];mark=[];
% time=cell2mat(row_mark(:,3));
% mark=time(28:43,4:6);
% functional_mapping_data(2).mark = mark;
% functional_mapping_data(2).segment = GetSegment(mark,weijie_task_name,weijie_edf_filename);
% 
% functional_mapping_data(3).name = 'dayou';
% functional_mapping_data(3).mark_filename = daiyou_mark_filename ;
% functional_mapping_data(3).edf_filename = daiyou_edf_filename;
% functional_mapping_data(3).task_name = daiyou_task_name;
% functional_mapping_data(3).target =daiyou_target;
% row_mark = GetMark(daiyou_mark_filename);
% time=[];mark=[];
% time=cell2mat(row_mark(:,3));
% mark=time(7:30,4:6);%,4:6
% functional_mapping_data(3).mark = mark;
% functional_mapping_data(3).segment = GetSegment(mark,daiyou_task_name,daiyou_edf_filename);

