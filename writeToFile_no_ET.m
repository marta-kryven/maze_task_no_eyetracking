function writeToFile_no_ET(fileID, ...
         logtimestamp, ...
         subject, ... %subject ID
         rt, ... %reaction time that it takes the subjevt to move to a new cell
         world, ... % the current maze
         worldtopleft_x, worldtopleft_y, ... % the top-left coordinates of the maze being rendered
         path, ... % the subject's path so far
         visible, ... % the area seen by the subject
         trial_type, ... % 1 -- practice, 2 -- experiment
         readKeyName, ... % the readable name of the key that was pressed
         actionName, ... % if the keypress resulted in an action : U,D,L,R
         actionValid, ... % 1 -- valid action 0-- invalid action, such as going intoa wall
         blackremains, ... % number of balck squares that remains to open
         numsquaresopen, ... % if an observation was received, how many squares opened? otherwise 0
         squaretype, ...   % 'O' - observation, 'N' - nothing happened, 'X' - the first square,  'G' - observing the goal
          ...                 % 'D'-- observation with > 2 exits
         numexits, ... % number of exits from this square
         cellsize, ... % the size of the cells that we render
         gridworld) % the world structure
     

 world_w = size(gridworld,2); % x
 world_h = size(gridworld,1); %
    
 svisible = '';
 for j=1:size(visible,1)
     for i=1:size(visible,2)
         svisible=sprintf('%s%d', svisible, visible(j,i));
     end
 end
 
 s_trial = 'practice';
 
 if trial_type == 2
     s_trial = 'experiment';
 end
 
 if length(readKeyName) == 0
      readKeyName = 'NA';
 end
 
    eye_x = -1;
    eye_y = -1;
    cellx = -1;
    celly = -1;
    pupil = -1;
    timefrom = -1;
    timeto = -1;

    line1 = sprintf('%s\t%s\t%4.0f\t%4.0f\t%4.0f\tevent\t', logtimestamp, subject, rt, eye_x, eye_y);
    line2 = sprintf('%8.0f\t%8.0f\t%4.0f\t%d\t%d\t', timefrom, timeto, pupil, cellx, celly);
    line3 = sprintf('%s\t%s\t%s\t%s\t%s\t%s\t%d\t', world, path, svisible, s_trial, readKeyName, actionName, actionValid );
    line4 = sprintf('%d\t%d\t%s\t%d\n', blackremains, numsquaresopen, squaretype, numexits);
    fprintf(fileID, [line1 line2 line3 line4]);
 
end