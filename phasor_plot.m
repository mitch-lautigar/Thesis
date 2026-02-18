function  phasor_plot(data)
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
%-------------------------------------------------------------------------%
%                                  Time                                   %
%-------------------------------------------------------------------------%
t = data.time;

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
 

%-------------------------------------------------------------------------%
%                           Simplified Arrays                             %
%-------------------------------------------------------------------------%
Vx_array = [Vx_1,Vx_2,Vx_3];
Vy_array = [Vy_1,Vy_2,Vy_3];
I_array = [i_1,i_2,i_3];
values_array = [Vx_array,I_array,Vy_array];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The Following code parses the values from the .mat file and find the     %
%maximum as well as at what sample that maximum is.                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Notes for "parsing_value:"
% 32 is half cycle calculations
% 64 is Full cycle Calculations
% 16 is Quarter cycle calculations
% No noted advantages to one over the other but in general, we will run at
% half cycle calculations

[a,~] = size(values_array);
parsing_value = 32;
max_array = [];
location_array = [];
maxed = [];
located = [];
rms_array = [];
if a > 32
    loop_counter = floor(a / parsing_value);
    remainder = rem(a,parsing_value);
    for i = 1:loop_counter
        array_look_at = abs(values_array(1:parsing_value,:));
        for j = 1:9
            max_number = max(array_look_at(:,j));
            location = find(array_look_at(:,j) == max_number);
            if (length(location) > 1) || (length(max_number) > 1)
                location = floor(mean(location));
                max_number = floor(mean(max_number));
            end    
            max_array = [max_array,max_number];
            location_array = [location_array,location];
        end 
        maxed = [maxed;max_array];
        located = [located;location_array];
        max_array = [];
        location_array = [];
        rms_array = [rms_array;rms(values_array(1:parsing_value,:)) ];
        values_array(1:parsing_value,:) = [];
    end
    if remainder / parsing_value > .9
        array_look_at = abs(values_array);
        for j = 1:9
            max_number = max(array_look_at(:,j));
            location = find(array_look_at(:,j) == max_number);
            if (length(location) > 1) || (length(max_number) > 1)
                location = floor(mean(location));
                max_number = floor(mean(max_number));
            end    
            max_array = [max_array,max_number];
            location_array = [location_array,location];
        end
        maxed = [maxed;max_array];
        located = [located;location_array];
        rms_array = [rms_array;rms(values_array(:,:)) ];
        max_array = [];
        location_array = [];
    end    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Pulls the calculated arrays of "maxed" and "located" from the previous   %
%loop to begin calculations for the phasor diagram.                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------------------------------%
%                               Magnitude                                 %
%-------------------------------------------------------------------------%
[a,b] = size(maxed);
rms_values = [];
for j = 1:b
    for i = 1:a
        rms_values(i,j) = rms(maxed(i,j));
        
    end
end  


%-------------------------------------------------------------------------%
%                             Phase Angle                                 %
%-------------------------------------------------------------------------%
for i = 1:a
    for j = 1:3
        phase_angle_1(i,j) = (located(i,j) - located(i,j+3)) * (360/64);
        phase_angle_2(i,j) = (located(i,j+6) - located(i,j+3)) * (360/64);
    end    
end 
phase_angle = [phase_angle_1,phase_angle_2];
phase = mean(phase_angle);
mag = mean(rms_array);

figure
hold on
compass(ptor(mag(1,1),phase(1,1)),'b --')
compass(ptor(mag(1,4),phase(1,1)),'b -')
compass(ptor(mag(1,7),phase(1,4)),'b -o')

compass(ptor(mag(1,2),phase(1,2)),'m --')
compass(ptor(mag(1,5),phase(1,2)),'m -')
compass(ptor(mag(1,8),phase(1,5)),'m -o')

compass(ptor(mag(1,3),phase(1,3)),'r --')
compass(ptor(mag(1,6),phase(1,3)),'r -')
compass(ptor(mag(1,9),phase(1,6)),'r -o')
legend('Vx_A','I_A','Vy_A','Vx_B','I_B','Vy_B','Vx_C','I_C','Vy_C')
hold off




















