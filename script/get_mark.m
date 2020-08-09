% get require mark cell and row mark cell form Mark.txt
function [cell, require_mark]= get_mark(mark_file_name)
    % DESCRIPTION
    % input mark_file path
    % output {mark status,mark time}
    % yangXinFeng,20200809

    data=importdata(mark_file_name);%'D:\MATLAB_work\EEG\functionalMapping\testData1\3.DaiYou\Mark.txt'
    begin = 0;
    cell={};
    for n=1:length(data)
        if begin
            temp = regexp(data{n},'  ','once','split');
            %time = [time;datevec(temp{1})];
            time=datevec(temp{1});
            time=time(4:6);
            cell=[cell;temp,time];
        end
        if strcmp(strtrim(data{n}),'Time	Title')
            disp(strsplit(data{n-1},':'));
            begin = 1;
        end
    end
    
    end_index=find(strcmp(strtrim(cell(:,2)),'over'));
    if isempty(end_index)
        end_index=find(strcmp(strtrim(cell(:,2)),'Stop Recording'));
    end
    start_index=find(strcmp(strtrim(cell(:,2)),'static start'));
    start_index=start_index(1);
    end_index=end_index(end_index>start_index);
    end_index=end_index(1);
    
    if isempty(end_index) && isempty(start_index)
        require_mark={};
        disp('Can not output require mark!');
        disp(cell);
    else
        require_mark=cell(start_index:end_index-1,2:3);
    end

end