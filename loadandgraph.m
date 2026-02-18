function [output_array,max,debug_values] = loadandgraph(data,dataCFG)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following Code was designed, tested, and programmed originally by
%Mitch Lautigar. Though the code is open source, please either leave this
%comment block in here, or properly cite me for my code. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This program takes in the structures from the .mat files and communicates
%between the other functions and then relays that information to run_me()
%while also saving the graph as a .png file.


%-------------------------------------------------------------------------%
%                            Voltage Upstream                             %
%-------------------------------------------------------------------------%
Vx_1 = data.analog.VX1;
Vx_2 = data.analog.VX2;
Vx_3 = data.analog.VX3;
%-------------------------------------------------------------------------%
%                           Voltage Downstream                            %
%-------------------------------------------------------------------------%
Vy_1 = data.analog.VY1;
Vy_2 = data.analog.VY2;
Vy_3 = data.analog.VY3;
%-------------------------------------------------------------------------%
%                                Current                                  %
%-------------------------------------------------------------------------%
i_1 = data.analog.I1;
i_2 = data.analog.I2;
i_3 = data.analog.I3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = data.time;
%theory(i_1,i_2,i_3,Vx_1,Vx_2,Vx_3,Vy_1,Vy_2,Vy_3,1:1981)
device_name = dataCFG.recording_device;
Date_time = [dataCFG.startdate,'_',dataCFG.starttime];
i_values = [i_1';i_2';i_3'];
%-------------------------------------------------------------------------%
%                              Plot Values                                %
%-------------------------------------------------------------------------%
 [num_samples,~] = size(t);
[power_line,~,~,fault_summary_array_i,~,fault_array_parts,ste] = compart_classify(Vx_1,Vx_2,Vx_3,Vy_1,Vy_2,Vy_3,i_1,i_2,i_3,t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[current_output] = set_array(i_values,power_line(4:6,:),fault_summary_array_i,device_name,Date_time,num_samples,ste);
[a,~] = size(current_output);
array_delete = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%false hits with magnitude less than specified amps.
speced_amps = 900;
speced_amps_check = 1000;
if a > 1
    for i = 1:a
       mag_check = str2num(cell2mat(cellstr(current_output(i,5)))); 
       if mag_check < speced_amps
           array_delete = [array_delete,i];
       end
       if (mag_check >= speced_amps) && (mag_check <= speced_amps_check)
           cycle_check = str2num(cell2mat(cellstr(current_output(i,5))));
           if cycle_check >= 1
               array_delete = [array_delete,i];
           end
       end
    end
    if length(array_delete) ~= a
        current_output(array_delete,:) = [];
    end
end
output_array = current_output;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% artifact_array = check_voltages(fault_array_parts);
% [A,~] = size(current_output);
% if A ~= 1
%     answers = artifact_array(1,1);
%     for i = 1:A
%         artifact_array(i,1) = answers;
%     end
% end
% output_array = [current_output,string(artifact_array)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[e,~] = size(output_array);
for i = 1:e
   b_samp(i,1) = str2num(cell2mat(output_array(i,8)));
   e_samp(i,1) = str2num(cell2mat(output_array(i,9)));
   max(i,1) = str2num(cell2mat(output_array(i,5)));
end
tims = [b_samp,e_samp] ./ length(t);
freq = num_samples / length(power_line);
debug_values = [tims];


%{
graph_title = strjoin([output_array(1,1:3),'png'],'__');
c = strsplit(graph_title,'/');
c = strjoin(c,'_');
c = strsplit(c,':');
c = strjoin(c,'-');
figure
 subplot(3,1,1)
 plot(t,Vx_1,t,Vx_2,t,Vx_3)
 title('Voltage, Source Side')
 
 subplot(3,1,2)
 plot(t,i_1,t,i_2,t,i_3)
 title('Current') 
 
 subplot(3,1,3)
 plot(t,Vy_1,t,Vy_2,t,Vy_3)
 title('Voltage, Load Side')
 print('-f1',c,'-dpng')
 close(figure(1))
 %}

end

