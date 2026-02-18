function run_me()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following Code was designed, tested, and programmed originally by
%Mitch Lautigar. Though the code is open source, please either leave this
%comment block in here, or properly cite me for my code. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The program below takes in the output array after creating an array for
%all files in the folder and writes it into a string array that gets
%written to a .txt file.

file_list = dir('*.mat');
x = [];
for i = 1:length(file_list)
    load(file_list(i).name);
    report = loadandgraph(data,dataCFG);
    %pause(2);
    x = [x;report];
end    
c = clock;
c = num2str(c);
c = strsplit(c,' ');
c = strjoin([c,'.txt'],'_');
fid = fopen(c,'w');
fprintf(fid,'%s ~~~~~ %s ~~~~~ %s ~~~~~ %s ~~~~~ %s ~~~~~ %s ~~~~~ %s ~~~~~ %s \r\n', [string(x(:,1)),string(x(:,2)),string(x(:,3)),string(x(:,4)),string(x(:,5)),string(x(:,6)),string(x(:,7)),string(x(:,8))]');
fclose(fid);
end

