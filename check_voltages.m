function artifact_array = check_voltages(fault_array_parts)

fault_array_x = fault_array_parts(1:3,:);
fault_array_i = fault_array_parts(4:6,:);
fault_array_y = fault_array_parts(7:9,:);

sum_x = sum(fault_array_x);
sum_i = sum(fault_array_i);
sum_y = sum(fault_array_y);
artifact_array = {};
if (sum_y(1,1) > 1) || (sum_x(1,1) > 1)
   artifact = 'F_C'; 
   if isempty(artifact_array) == 1
       artifact_array = artifact;
    elseif isempty(artifact_array) ~= 1
       artifact_array = [artifact_array,';',artifact];
   end
end
if sum_x(1,end) > 1
   artifact = 'L-O-S';  
   if isempty(artifact_array) == 1
       artifact_array = artifact;
   elseif isempty(artifact_array) ~= 1
       artifact_array = [artifact_array,';',artifact];
   end
end
if sum_y(1,end) > 1
   artifact = 'L-O-L';  
   if isempty(artifact_array) == 1
       artifact_array = artifact;
   elseif isempty(artifact_array) ~= 1
       artifact_array = [artifact_array,';',artifact];
   end
end




if isempty(artifact_array) == 1
    artifact_array = ['C'];
end
end

