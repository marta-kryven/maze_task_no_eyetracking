function writeToFile_no_ET(fileID, ...
         subject, ... %subject ID
         rt, ... %reaction time that it takes the subjevt to move to a new cell
         world, ... % the current maz
         path, ... % the subject's path so far
         visible) ... % the area seen by the subject
     
 % The file format    
 %fprintf(fileID,'subject\trt\tworld\tpath\tvisible');
 
 svisible = '';
 for j=1:size(visible,1)
     for i=1:size(visible,2)
         svisible=sprintf('%s%d', svisible, visible(j,i));
     end
 end
 
 line1 = sprintf('%s\t%4.0f\t', subject, rt);
 line2 = sprintf('%s\t%s\t%s\n', world, path, svisible);
 fprintf(fileID, [line1 line2]); 
 
end