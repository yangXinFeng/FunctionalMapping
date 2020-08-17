function target = get_target(task_name,electrode_position,electrode_number)

for i = 1:length(electrode_position)
    target = zeros(1,electrode_number);
    is_task = 0;
    if strcmp(electrode_position{i,1},...
            task_name(1:length(electrode_position{i,1})))        
        target(electrode_position{i,2})=1;
        is_task = 1;
        break;
    end
end

if ~is_task
    for i = 1:length(electrode_position)
        target(electrode_position{i,2}) = i;
    end
end
   
end