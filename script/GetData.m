clc;clear;

daiyou_mark_filename = 'D:\MATLAB_work\EEG\functionalMapping\testData1\3.DaiYou\Mark.txt';
daiyou_edf_filename = 'D:\MATLAB_work\EEG\functionalMapping\testData1\3.DaiYou\dai~ you_reduced_reduced.edf';
daiyou_task_name = {'static1','hand1','talk1','name1','name2','talk2','hand2','static2',...
    'static3','hand3','talk3','name3'};
daiyou_target = {'name',[1,2];'language',[4,5,6];...
    'move',[7,8];'none',[3]};

weijie_mark_filename = 'D:\MATLAB_work\EEG\functionalMapping\testData1\2.weijie\Mark.txt';
weijie_edf_filename = 'D:\MATLAB_work\EEG\functionalMapping\testData1\2.weijie\WJ_all2_reduced1.edf';
weijie_task_name={'static1','hand1','talk1','name1',...
    'static2','hand2','talk2','name2'};
weijie_target = {'language',[9,10];'none',[11];...
    'move',[13,14];'name',[12]};

chenkai_mark_filename = 'D:\MATLAB_work\EEG\functionalMapping\testData1\1.ChenKai\Mark.txt';
chenkai_edf_filename = 'D:\MATLAB_work\EEG\functionalMapping\testData1\1.ChenKai\chen~ kai_reduced_reduced.edf';
chenkai_task_name={'static','hand','talk','name'};
chenkai_target = {'name',[2,3,7,8,12,13];...
    'none',[14,15];'vessel',[7,12,18]};

functional_mapping_data={};
functional_mapping_data(1).name = 'chenkai';
functional_mapping_data(1).mark_filename = chenkai_mark_filename ;
functional_mapping_data(1).edf_filename = chenkai_edf_filename;
functional_mapping_data(1).task_name = chenkai_task_name;
functional_mapping_data(1).target = chenkai_target;
row_mark = GetMark(chenkai_mark_filename);
time=[];mark=[];
time=cell2mat(row_mark(:,3));
mark=time([7,8,11:16],4:6);
functional_mapping_data(1).mark = mark;
functional_mapping_data(1).segment = GetSegment(mark,chenkai_task_name,chenkai_edf_filename);

functional_mapping_data(2).name = 'weijie';
functional_mapping_data(2).mark_filename = weijie_mark_filename ;
functional_mapping_data(2).edf_filename = weijie_edf_filename;
functional_mapping_data(2).task_name = weijie_task_name;
functional_mapping_data(2).target = weijie_target;
row_mark = GetMark(weijie_mark_filename);
time=[];mark=[];
time=cell2mat(row_mark(:,3));
mark=time(28:43,4:6);
functional_mapping_data(2).mark = mark;
functional_mapping_data(2).segment = GetSegment(mark,weijie_task_name,weijie_edf_filename);

functional_mapping_data(3).name = 'dayou';
functional_mapping_data(3).mark_filename = daiyou_mark_filename ;
functional_mapping_data(3).edf_filename = daiyou_edf_filename;
functional_mapping_data(3).task_name = daiyou_task_name;
functional_mapping_data(3).target =daiyou_target;
row_mark = GetMark(daiyou_mark_filename);
time=[];mark=[];
time=cell2mat(row_mark(:,3));
mark=time(7:30,4:6);%,4:6
functional_mapping_data(3).mark = mark;
functional_mapping_data(3).segment = GetSegment(mark,daiyou_task_name,daiyou_edf_filename);

