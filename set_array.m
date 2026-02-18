function [output_array] = set_array(i_values,current_value,fault_array,name,dt,num_samples,ste)
%1 & 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following Code was designed, tested, and programmed originally by
%Mitch Lautigar. Though the code is open source, please either leave this
%comment block in here, or properly cite me for my code. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following code computes the output array that is as follows
%Name of device, fault_type, magnitude of fault, cycle duration, second
%duration, start sample, end sample


freq = round(length(current_value)/4);
fault_type = fault_array(1,:); %3
lines_faulted = fault_array(2,:); %4
cycle_duration = cell2mat(fault_array(4,:));
startpoint = cell2mat(fault_array(3,:));



[~,b] = size(fault_array);
beta = [];
if b == 0
    output_array = [name,dt,"blip","blip","blip","blip","blip","blip","blip" ];
elseif b ~= 0
for i = 1:b
    fa = str2num(cell2mat(lines_faulted(1,i)));
    ste2 = mean(ste(:,2) );
    cycle_durated = cycle_duration(1,i) / 4; %6
    if startpoint(1,i) == 1
        start_samples = 0;
    else
    start_samples = round((startpoint(1,i) ) * 8 );%8 
    end
    cycle_samples = round(cycle_durated * freq);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% account = [5,5];
% if (start_samples == 0) || (startpoint(1,i) - account(1,1) < 0)
%     account(1,1) = 0;
% end
% if startpoint(1,i) + ceil(cycle_durated)+account(1,2) > length(current_value)
%     account(1,2) = 0;
% end
% max_locate = sort(max(current_value(:,startpoint(1,i)-account(1,1):startpoint(1,i) + ceil(cycle_durated)+account(1,2) )));
% [line_use,~] = find(current_value(:,startpoint(1,i)-account(1,1):startpoint(1,i) + ceil(cycle_durated)+account(1,2) ) == max_locate(1,end-1));
% max_locate = sort(current_value(line_use,startpoint(1,i)-account(1,1):startpoint(1,i) + ceil(cycle_durated)+account(1,2) ));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if cycle_durated <= 3
        mag_max = max(max(abs(i_values(:,(start_samples*2-16):(start_samples*2+cycle_samples+32)))));
%     elseif (cycle_durated >= 2.25) && (cycle_durated < 3)
%         mag_max = max(max(abs(i_values(:,start_samples*2+16:start_samples*2+cycle_samples))));
%     
    else 
        mag_max = max(max(abs(i_values(:,start_samples*2+16:start_samples*2+cycle_samples)))); %5
        
    end
    end_sample = start_samples + cycle_samples;%9 
    second_duration = cycle_samples / num_samples; %7

    output_array(i,1:9) = [name,dt,fault_type(1,i),string(lines_faulted(1,i)),num2str(mag_max),num2str(cycle_durated),num2str(second_duration),num2str(start_samples),num2str(end_sample)];

end  

end

