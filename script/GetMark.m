function cell = GetMark(mark_file_name)
    data=importdata(mark_file_name);%'D:\MATLAB_work\EEG\functionalMapping\testData1\3.DaiYou\Mark.txt'
    begin = 0;
    cell={};time=[];
    for n=1:length(data)
        if begin
            temp = regexp(data{n},'  ','once','split');
            %time = [time;datevec(temp{1})];
            cell=[cell;temp,datevec(temp{1})];
        end
        if strcmp(data{n},'     Time	Title')
            disp(strsplit(data{n-1},':'));
            begin = 1;
        end
    end


end