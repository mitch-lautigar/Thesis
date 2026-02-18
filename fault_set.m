function [fault_specifics] = fault_set(fault_array,current_value)
fault_class = sum(fault_array);
cycle_duration = 0;
startpoint = 0;
lines_faulted = 0;
for i = 1:length(fault_class)
    if i == 1
        fault_type = fault_class(1,i);
        cycle_duration = cycle_duration + 0.5;
        start_point = i;
    end 
    if i ~= 1
        fault_type_check = fault_class(1,i);
        if fault_type_check == fault_type
            
        end
    end    
end    


end

