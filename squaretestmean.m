function  [avg_mean,location] = squaretestmean(value)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following Code was designed, tested, and programmed originally by
%Mitch Lautigar. Though the code is open source, please either leave this
%comment block in here, or properly cite me for my code. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%The Following Program computes the square mean Test(SMT) of the value array
%brought in.  How it does it is by squaring each value of the array,
%parsing for every 32 samples, and find the mean of each grouping of 32
%samples.

%value = value';
value = value .^2;
avg_mean = [];
slope = value(1,2) - value(1,1);
seperator = 24;

    if slope > 0 %find max
        the_max = max(value(1,1:seperator) );
        location = find(value(1,1:seperator) == the_max);
    end
    if slope < 0 %find min
        the_min = min(value(1,1:seperator) );
        location = find(value(1,1:seperator) == the_min);

    end
    if slope == 0
        location = 0;
    end
     location = min(location);
if location >= 13    
    location = rem(location,13);
end
if location < 1
    location = 1;
end
value = value(1,location:end);
iteration = 16;
 [~,a] = size(value);
 actual_iterations = floor(a / iteration);


 
 for i = 1:actual_iterations
     ca = value(1,1:iteration);
     avg_mean(1,i) = mean(ca);
     value = value(1,iteration:end);
 end 
avg_mean = sqrt(avg_mean);
   

end

