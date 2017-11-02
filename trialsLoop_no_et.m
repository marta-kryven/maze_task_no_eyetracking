function [exitFlag, step_counter] = trialsLoop_no_et( imageAgent, ... 
        testTrialsPermutation, ... % the order in which the worlds will be shown
        test_maps, ...% the array of world maps loaded from file
        trial_type, ... % 0 -- demo, 1 -- practice, 2 -- experiment
        fileID, ... % log file
        window, mon, subject, ...
        number_of_prior_trials, ...
        total_trials)                          % eyetracker 
    
        debug_show_filenames = 0; % this is to show the name of the maze file
    
        if trial_type == 0
            fprintf('Showing demo, data will not be recorded...\n');
        elseif trial_type == 1
            fprintf('Showing practice, data will be recorded...\n');
        else
            fprintf('Main experiment...\n');
        end
    
        scanList=zeros(1,256); % Listening to keyboard events... tell Psychtoolbox which keys we are interested in
                           % This code can be easily changed to listening to a keypad
        scanList(41)=1; %esc
        scanList(81)=1; %down
        scanList(82)=1; %up
        scanList(80)=1; %esc
        scanList(79)=1; %esc
    
        cellsize = 80;                   % a size of a cell in pixels as it will be drawn
        gray = 127;
        black_rectangle_time = 1;        % this is used to flash the black sqaure for ephys synchronisation
        exitFlag = 0;                    % 0 -- finished successfully, 1 -- ECS
        number_of_test_trials = size(test_maps,1);
        step_counter = 0;
       
        fprintf('DEBUG: number of trials %d\n', number_of_test_trials);
       
        %-----------------------------------------------------------------------
        %
        %    Loop through all trials                   
        %
        %-----------------------------------------------------------------------
        
        for next_map_index=1:number_of_test_trials
            
              if exitFlag
                  fprintf('Experiment terminated... escaping\n');
                  break;
              end
              
              %-----------------------------------------------------------------------
              %
              %    Initialise the trial 
              %
              %-----------------------------------------------------------------------
              
              exit_reached = 0;      % has the exit been reached yet?
              steps=0;               % counting the number of steps that the subject took on this trial
              
              agent_path = '(1,1);'; % the agent will always start at the top-left corner
              agent_x=1; agent_y=1; 
        
              world = test_maps{testTrialsPermutation(next_map_index)}; % path to the current maze map
              slash = max(strfind(world, '/'));
              dot = max(strfind(world, '.'));
              worldName = world(slash+1:dot-1);  % the name of the curent world
              
              fprintf('DEBUG: world name %s\n', worldName);

              %-----------------------------------------------------------------------
              %
              %    Reading the map. If this is a practice trial, move the
              %    goal to a new random location, such that is not visible
              %    from the very begining postion
              %
              %-----------------------------------------------------------------------
              
              [ gridworld, worldw, worldh, visible, blackremains ] = ...
                  initialiseWorld( world,  (trial_type==1) );
              
              redraw_needed = 0;
              numsquaresopen = 0;
              squaretype = 'X';
              numexits = 0;
              
              if gridworld(1,2) == 0
                  numexits = 1;
              end
              
              if gridworld(2,1) == 0
                  numexits = numexits + 1;
              end

              %-----------------------------------------------------------------------
              % 
              %    Flashing a balck rectangle
              %
              %-----------------------------------------------------------------------
              
              Screen(window, 'FillRect', gray); 
              Screen('FillRect', window, [0,0,0], [10 mon.hp-120 120 mon.hp-10] );
              flipTime = Screen('Flip', window);
              
              line1 = sprintf('%s\t%s\n', getTimestamp(), 'startmarker');
              fprintf(fileID, line1);
            
              
              %-----------------------------------------------------------------------
              % 
              %    Drawing a maze
              %
              %-----------------------------------------------------------------------
              
              stepStr = '';
        
              fprintf(stepStr);
              fprintf('\n');

              [offx, offy] = drawWorld(window, gridworld, visible, ...
                  agent_x, agent_y, mon.wp, mon.hp, ...
                  imageAgent, cellsize, 0, 0, ...
                  debug_show_filenames, worldName);
              
              drawStepCount(trial_type, steps, window, offy, next_map_index, ...
                  number_of_test_trials, number_of_prior_trials,  total_trials);
              
              flipTime = Screen('Flip', window, flipTime + black_rectangle_time, 0);
            
              line1 = sprintf('%s\t%s\n', getTimestamp(), 'endmarker');
              fprintf(fileID, line1);
              
              tic;  %get current time so that we can record theit reaction times
              rt_end=0;
              
              while ~exit_reached
                  
                                   
                  %-----------------------------------------------------------------------
                  %
                  %    Listen for interaction  
                  %
                  %-----------------------------------------------------------------------
                  
                   FlushEvents('keyDown');
                   [ keyIsDown, t, keyCode ] = KbCheck([]);
                   ikeyCode = find(keyCode);
                   
                   if ~isempty(ikeyCode)
                      [keyCode] = readKeyboardBufferAndFlushAllKeys(ikeyCode, keyCode);
                   end
                   
                   readKeyName = KbName(keyCode);      % we will log whichever key was pressed
                   actionName = 'NA';                  % a key was pressed resulting in no action
                   actionValid = 0;
                   
                   has_moved = 0; % was the agent moved during interaction?
                   if keyCode(KbName('ESCAPE'))
                      fprintf('Experiment skipped.\n');
                      exit_reached = 1;
                      exitFlag = 1;
                   elseif keyCode(KbName('DownArrow'))
                       
                       %process the keypress only if interaction is allowed
                       if agent_y < size(gridworld,1) 
                           if gridworld(agent_y+1, agent_x) ~=3
                            agent_y=agent_y+1;
                            has_moved=1;
                           end
                       end
                       
                       actionName = 'D';
   
                   elseif keyCode(KbName('UpArrow'))
                       
                       if agent_y > 1 
                           if gridworld(agent_y-1, agent_x) ~=3
                            agent_y=agent_y-1;
                            has_moved=1;
                           end
                       end
                          
                       actionName = 'U';
                   elseif keyCode(KbName('LeftArrow'))
                       
                       if agent_x > 1
                           if gridworld(agent_y, agent_x-1) ~=3
                            agent_x=agent_x-1;
                            has_moved=1;
                           end
                       end
                           
                       actionName = 'L';
                   elseif keyCode(KbName('RightArrow'))
                       
                       if agent_x < size(gridworld,2) 
                           if gridworld(agent_y, agent_x+1) ~=3
                            agent_x=agent_x+1;
                            has_moved=1;
                           end
                       end
                           
                       actionName = 'R';
                   elseif length(KbName(keyCode)) > 0
                       fprintf('Unexpected key %s %d\n', KbName(keyCode), keyCode)
                   end
                   
                   %update the maze if the agent has moved
                   
                   
                   if has_moved
                       numsquaresopen = 0;
                       squaretype = 'N';
                      
                       [visible, numsquaresopen, squaretype, blackremains, numexits]  = ...
                           updateVisible(gridworld, visible, agent_x, agent_y);
                       steps = steps+1;
                       rt_end=toc;
                       tic;
                       agent_path = sprintf('%s(%d,%d);', agent_path, agent_x, agent_y);
                       has_moved = 0;
                       redraw_needed = 1;
                       step_counter = step_counter+1;
                       actionValid = 1;
                   end
         
                   if ( redraw_needed  )

                        redrawWorld(worldName, gray, window, agent_y, agent_x, ...
                            next_map_index, number_of_test_trials, steps, gridworld, visible, ...
                            mon.wp, mon.hp, imageAgent, cellsize, flipTime, offy, debug_show_filenames); 
                        
                        drawStepCount(trial_type, steps, window, offy, ...
                            next_map_index, number_of_test_trials, ...
                            number_of_prior_trials,  total_trials);
                   end
                   
                   
                   
                   if (redraw_needed )
                       redraw_needed = 0;
                       flipTime = Screen('Flip', window, flipTime + 0.01,0);
                   
                       if trial_type > 0 

                          writeToFile_no_ET(fileID, ...
                                    getTimestamp(), ...
                                    subject, ...
                                    rt_end*1000,  ...
                                    worldName, ...
                                    offx, offy, ...                 %*
                                    agent_path, ...
                                    visible, ...
                                    trial_type, readKeyName, actionName, actionValid, ... %$
                                    blackremains, numsquaresopen, squaretype, numexits, ...%$
                                    cellsize, ...                   %*
                                    gridworld);         
                       end
                   end

                   
                   if (redraw_needed )
                       redraw_needed = 0;
                       flipTime = Screen('Flip', window, flipTime + 0.01,0);
                   end
                   
                   if (gridworld(agent_y, agent_x) == 2)
                       exit_reached = 1;
                       fprintf('Exit reached!\n');
                   end
                   
                   
              end
       end   % loop for all trials

end
