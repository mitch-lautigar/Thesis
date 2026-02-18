function [fault_array_corrected] = fault_check(fault_array)
wiggle = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,b] = size(fault_array);
delta_b = 1;
while delta_b ~= 0
fan = cell2mat(fault_array(3:4,:));
fas = fault_array(1:2,:);
ad = [];
    if b ~= 1
        
        wa = [-wiggle wiggle];
       for i = 1:b-1           
           fc = fan(:,i);
           fp = fan(:,i+1);
           check = fp(1,1) - fc(1,1);
           if (check > wiggle) && (fc(2,1) < wiggle)
               ad = [ad,i];
           else
               fpc = fp(1,1) + wa;
               if (sum(fc) >= fpc(1,1) ) && (sum(fc) <= fpc(1,2) ) && (min([fc(2,1),fp(2,1)]) < 4 * wiggle)
                  fan(1,i+1) = fc(1,1);
                  fan(2,i+1) = fp(2,1) + fc(2,1);
                  ad = [ad,i];
                  fas(:,i+1) = fas(:,i);   
               end
           end
       end
        fault_array = [fas;num2cell(fan)];
        fault_array(:,ad) = [];
        fault_array_corrected = fault_array;
    
    [~,b2] = size(fault_array_corrected);
    delta_b = b2-b;
        if delta_b ~= 0
           b = b2; 
           fault_array = fault_array_corrected;
        end
    end
    if b == 1
       delta_b = 0; 
       fault_array_corrected = fault_array;
    end
end



% [~,b] = size(fault_array);
% if b ~= 1
% fault_values = cell2mat(fault_array(3:4,:));
% collapse_array = [];
% array_delete = [];
% for i = 1:length(fault_values)
%    if fault_values(2,i) == 1
%        if (i == 1) 
%            fault_values(:,2) = fault_values(:,2) - [1; -1];
%        elseif (i == length(fault_values)) 
%            if sum(fault_values(:,i-1) ) == fault_values(1,i) 
%            fault_values(:,end-1) = fault_values(:,end-1) - [0; -1];
%            end
%        elseif (i ~= length(fault_values)) && (i ~= 1) && (sum(fault_values(:,i)) == fault_values(1,i+1) )
%            fault_values(2,i-1) = fault_values(2,i-1)+fault_values(2,i);
% 
%        end
%        array_delete = [array_delete,i];
%    end
% end
% fault_array(3:4,:) = num2cell(fault_values);
% fault_array(:,array_delete) = [];
% end
% [~,b] = size(fault_array);
% 
% 
% if b ~= 1
% 
% fault_values = cell2mat(fault_array(3:4,:));
% array_delete = [];
% for i = 1:length(fault_values)-1
%     if sum(fault_values(:,i)) == fault_values(1,i+1)
%         fault_values(2,i) = fault_values(2,i) + fault_values(2,i+1);
%         array_delete = [array_delete,i+1];
%     end
% end
% fault_array(3:4,:) = num2cell(fault_values);
% fault_array(:,array_delete) = [];
% 
% fault_array_corrected = fault_array;
% elseif b == 1
%     fault_array_corrected = fault_array;
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [~,b] = size(fault_array);
% 
% for i = b-1:-1:1
%     if strcmpi(cellstr(fault_array(2,i+1)),cellstr(fault_array(2,i))) == 1
%         if cell2mat(fault_array(3,i+1)) - sum(cell2mat( fault_array(3:4,i) )) < 3
%            fault_array(4,i) = num2cell(cell2mat(fault_array(4,i)) + cell2mat(fault_array(4,i+1)));
%            fault_array(:,i+1) = [];
%         end
%         
%     end
%     
% end
% 
% fault_array_corrected = fault_array;
% 
% %Finish this!!!!
end

