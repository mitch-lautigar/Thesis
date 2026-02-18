function [power_line,fault_summary_array_x,fault_summary_array_y,fault_summary_array_i,fault_type,fault_array_parts,start_time_error] = compart_classify(Vx_1,Vx_2,Vx_3,Vy_1,Vy_2,Vy_3,i_1,i_2,i_3,t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following Code was designed, tested, and programmed originally by
%Mitch Lautigar. Though the code is open source, please either leave this
%comment block in here, or properly cite me for my code. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Notes from creator: 
%Out of all the files for this program, this is where 99% of all debugging
%will take place. If you have the program running, put a pause where you
%see the following line of code:
% "fault_array(1:4,counter) =
% {char(ftca);num2str(cycle_counter+1);num2str(starting_point);num2str(lines_faulted)};"
% and before you step into the fault loop, look at the fault array called
% fault which will tell you which phase is faulted at each grouping from
% the SMT values. The key point to know there is a definite fault with the
% for loop at the end of this function is when the "fault_array" has a
% matrix of [0 0 0] as it's last value at the bottom. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This program itself will look at the SMT values of all the inputs and find
%the "fault_array" output. The fault_array output is just an array with all
%data needed to compute the values that are computed in the "set_array"
%function. 

%{
---------------------------------------------------------------------------
 This function works effectively to take in the values of a comtrade file
 and classify the faults accordingly. The following steps will be commented
 and broken down for ease of understanding. 

                           Input Breakdown
Vx_1: The voltage of Phase A on the source side.
Vx_2: The voltage of Phase B on the source Side.
Vx_3: The voltage of Phase C on the source side.

Vy_1: The voltage of phase A on the load side.
Vy_2: The voltage of phase B on the load side.
Vy_3: The voltage of phase C on the load side.

i_1: The current through phase A.
i_2: The current through phase B.
i_3: The current through phase C.

                           Output Breakdown
1. current_value: The square mean test value computed by the code for all 3
phases of current stacked in a single array with phase A being row 1 of the 
array,phase B row 2, and phase C row 3.
2. source_voltage: The square mean test value computed by the code for all 3
phases of voltage stacked in a single array with phase A being row 1 of the 
array,phase B row 2, and phase C row 3.
3. load_voltage: The square mean test value computed by the code for all 3
phases of voltage stacked in a single array with phase A being row 1 of the 
array,phase B row 2, and phase C row 3.
4. fault_length: an array that contains the number of lines faulted at each
individual sample of the square mean test array.
5. fault_error: an array that contains what faults happened in this file
and will be used later and is designed to be in the report of this code.
---------------------------------------------------------------------------
%}
%The subplot below is designed for any using the hard coded functions to be
%able to see the graphs of the original values to eyeball what the fault
%is. Most of the time, this will be commented out unless it's needed.
%%{
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
 

 %}
%-------------------------------------------------------------------------%
%Send each individual input into the squaretestmean function to acquire a
%simplified array that can be used for comparison. The values are then
%grouped together into arrays specified to current, load voltage, and
%source voltage.
[i1_smt, i1] = squaretestmean(i_1');
[i2_smt, i2] = squaretestmean(i_2');
[i3_smt, i3] = squaretestmean(i_3');

[Vx1_smt, vx1] = squaretestmean(Vx_1');
[Vx2_smt, vx2] = squaretestmean(Vx_2');
[Vx3_smt, vx3] = squaretestmean(Vx_3');

[Vy1_smt, vy1] = squaretestmean(Vy_1');
[Vy2_smt, vy2] = squaretestmean(Vy_2');
[Vy3_smt, vy3] = squaretestmean(Vy_3');
start_time_error = [vx1 i1 vy1; vx2 i2 vy2; vx3 i3 vy3];
%{
figure
 subplot(3,1,1)
 plot(1:length(Vy1_smt),Vx1_smt,'x',1:length(Vy1_smt),Vx2_smt,'x',1:length(Vy1_smt),Vx3_smt,'x')
 title('Voltage SMT, Source Side')
 
 subplot(3,1,2)
 plot(1:length(Vy1_smt),Vy1_smt,'x',1:length(Vy1_smt),Vy2_smt,'x',1:length(Vy1_smt),Vy3_smt,'x')
 title('Voltage SMT, Load Side')
 
 subplot(3,1,3)
 plot(1:length(Vy1_smt),i1_smt,'x',1:length(Vy1_smt),i2_smt,'x',1:length(Vy1_smt),i3_smt,'x')
 title('Current SMT')
%}
current_value = [i1_smt; i2_smt; i3_smt];
source_voltage = [Vx1_smt;Vx2_smt;Vx3_smt];
load_voltage = [Vy1_smt;Vy2_smt;Vy3_smt];
power_line = [source_voltage;current_value;load_voltage];
%-------------------------------------------------------------------------%
%This is where the fault classification begins to take place. The first for
%loop effectively takes the stacked current array of all 3 phases and steps
%through each line at each individual value to see what that number is
%doing. Here's a quick explanation of how the following numbers were chosen
%but can quickly be edited as needed.

%For this method, after the values have been computed, we take the nominal
%line voltage and find the RMS value of it so as to compare it to the
%Square mean Test method and obtain a percent error between the two values.
%Once the percent error values have been found, I then have specified that
%if there is more than 10 percent difference, it's a fault. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
line_voltage = 10000;
v_check = line_voltage / sqrt(2);

vol_pe_x = abs(v_check - source_voltage) / v_check .* 100;
vol_pe_y = abs(v_check - load_voltage) / v_check .* 100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,b] = size(vol_pe_x);
fault_array_x(1:3,1:b) = 0;
fault_array_y(1:3,1:b) = 0;
fault_array_i(1:3,1:b) = 0;
for i = 1:b
    for k = 1:3
        if vol_pe_x(k,i) > 15
            fault_array_x(k,i) = 1;
        end    
        if vol_pe_y(k,i) > 15
            fault_array_y(k,i) = 1;
        end 
        if (current_value(k,i) > 250)
            fault_array_i(k,i) = 1;
        end
    end
end   
fault_array_parts = [fault_array_x;fault_array_i;fault_array_y];

 [fault_summary_array_x,fault_type_x] = fault_evaluate(fault_array_x);
 [fault_summary_array_y,fault_type_y] = fault_evaluate(fault_array_y);
 [fault_summary_array_i,fault_type_i] = fault_evaluate(fault_array_i);

[fault_summary_array_i] = fault_check(fault_summary_array_i);
[fault_summary_array_y] = fault_check(fault_summary_array_y);
[fault_summary_array_x] = fault_check(fault_summary_array_x);
fault_type = [fault_type_x,fault_type_i,fault_type_y];
end

