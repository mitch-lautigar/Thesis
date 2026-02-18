function [fault_summary,fault_type] = fault_evaluate(fault_array)
fault_test = sum(fault_array);
begin_fault = 1;
output = [];
fault_class = {'Clear','LG','LL','LLL'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 3, find the fault type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fault_type = [];
if fault_test(1,1) ~= 0
    fault_type = [fault_type,'Ongoing'];
elseif fault_test(1,end) ~= 0
    fault_type = [fault_type,'Continuing'];
elseif (fault_test(1,1) == 0) && (fault_test(1,end) == 0)
    fault_type = ['contained'];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 1, find the beginning and end start time for all faults.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This while loop finds an array that is then used to calculate the end
%time.
    while length(fault_test) >= 1
        lines_faulted = fault_test(1,1);
        y = find(fault_test ~= lines_faulted);
        if isempty(y) == 1
            end_fault = length(fault_test);
        else
        end_fault = y(1,1)-1;
        end
        be_end = [begin_fault;end_fault];
        output = [output,be_end];
        fault_test(:,begin_fault:end_fault) = [];

    end
    output = [[0;0],output];
    rolling_sum = 0;
    %This for loop calculates the actual end time.
    for i = 1:length(output)-1
        rolling_sum = rolling_sum + output(2,i+1);
        ending(1,i) = rolling_sum;    
    end
    begin = 1 + ending;
    begin(:,end) = [];
    begin = [1,begin]; %Calculate the beginning time.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 2, find the fault class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 for i = 1:length(ending)
     spot_check = floor( (ending(1,i) + begin(1,i) ) / 2);
     lines_faulted(1:3,i) = fault_array(:,spot_check);
     fault_classification(1,i) = fault_class(1,sum(lines_faulted(:,i))+1); 
 end
    zeta = find(strcmpi(fault_classification,'Clear') == 1);
    
    fault_classification(:,zeta) = [];
    begin(:,zeta) = [];
    ending(:,zeta) = [];
    lines_faulted(:,zeta) = [];
    output(:,1) = [];
    output(:,zeta) = [];
    cycle_duration = output(2,:);
    
    %fault_summary_array = [cellstr(fault_abbrev);num2cell(phase_set);num2cell(counter_array);num2cell(starting_sample)];
    for i = 1:length(ending)
        fault_summary(1:4,i) = [cellstr(fault_classification(1,i));cellstr(num2str(lines_faulted(:,i)'));num2cell(begin(1,i));num2cell(cycle_duration(1,i))];
    end
    
    
end