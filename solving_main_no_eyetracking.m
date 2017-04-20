    
%-----------------------------------------------------------------------
%
%    Maze-Solvig task
%    Maze maps will be loaded from the directory "world_maps"
%
%    If you would like to change worlds or to add new worlds, you will need
%    to edit files in the "world_maps" directory. 
%
%    For example, the world 1tunnel.txt looks like this:
%
%    3
%    6
%    000
%    030
%    032
%    030
%    030
%    003
%
%    The first two rows are world width and height;
%    The map is an array, in which each element can be empty (0), wall (3),
%    or exit (2). We assume there is always only one exit in each maze.
%
%    The first five world are practice trials, which are not scored
%-----------------------------------------------------------------------

function step_counter = solving_main_no_eyetracking(subject, window, mon)

    %-----------------------------------------------------------------------
    % setup the experiment
    %-----------------------------------------------------------------------
    
           
    fixationlog_here = 'solving_log_dir/'; % logging
       
    s = strcat(pwd, '/world_maps/'); % load files from here
    maps = loadAllMaps(s);           % maze maps
    ptrials = size(maps,1);          % how many maze maps were loaded
    cellsize = 80;                   % a size of a cell in pixels as it will be drawn
    gray = 127;
    
    
    number_of_practice_trials = 5;   % the first 5 maps that are loaded are not scored
    black_rectangle_time = 1;
   
    scanList=zeros(1,256); % Listening to keyboard events... tell Psychtoolbox which keys we are interested in
                           % This code can be easily changed to listening to a keypad
    scanList(41)=1; %esc
    scanList(81)=1; %down
    scanList(82)=1; %up
    scanList(80)=1; %esc
    scanList(79)=1; %esc

    trialsPermutation = randperm(ptrials-number_of_practice_trials) + number_of_practice_trials;
    t = 1:1:number_of_practice_trials; % the first five trials are practice trials, which are not scored
    trialsPermutation = [ t trialsPermutation];
    
    
    %-----------------------------------------------------------------------
    %
    % create the agent image
    %
    %-----------------------------------------------------------------------
    
    img = imread(strcat(pwd, '/tex/agent1.png')); % the agent's face
    imageAgent = Screen('MakeTexture', window, img);
    

    %-----------------------------------------------------------------------
    %
    % instructions screen
    %
    %-----------------------------------------------------------------------
    
    fprintf('Showing instructions\n');
    flipTime = showInstructions(window);
    
    KbWait;
    [ keyIsDown, t, keyCode ] = KbCheck;   % wait for any key to be pressed
    KbReleaseWait;
    
    fprintf('Response received...\n');
    
    escapeKey = KbName('ESCAPE');
    if keyCode(escapeKey)
      fprintf('Experiment skipped.\n');
    else
       
       escaped_experiment = 0; % is ESCAPE is pressed terminate the experiment; this is 
                               % necessary to debug the code
                               
       step_counter = 0;       % counting the total number of steps that teh subject takes
                               % over all trials
       

       fileID = fopen([fixationlog_here subject 'solving_log.txt'],'w');
       fprintf(fileID,'subject\trt\tworld\tpath\tvisible');  % The file format   
    
       %-----------------------------------------------------------------------
       %
       %    Here is the main experiment loop 
       %
       %-----------------------------------------------------------------------
              
       for next_map_index=1:ptrials
            
              if escaped_experiment
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
        
              world = maps{trialsPermutation(next_map_index)}; % path to the current maze map
              slash = max(strfind(world, '/'));
              dot = max(strfind(world, '.'));
              worldName = world(slash+1:dot-1);  % the name of the curent world
              
              % reading the map
              [ gridworld, worldw, worldh, visible ] = initialiseWorld(maps, trialsPermutation(next_map_index));
              
              redraw_needed = 0;

              %-----------------------------------------------------------------------
              % 
              %    Flashing a balck rectangle
              %
              %-----------------------------------------------------------------------
              
              Screen(window, 'FillRect', gray); 
              Screen('FillRect', window, [0,0,0], [10 mon.hp-60 60 mon.hp-10] );
              flipTime = Screen('Flip', window, flipTime, 0);
              
              %-----------------------------------------------------------------------
              % 
              %    Drawing a maze
              %
              %-----------------------------------------------------------------------
              
              stepStr = '';

              if next_map_index <= number_of_practice_trials
                stepStr=sprintf('Please use arrow keys to move. [Practice] Steps: %d', steps);
              else
                stepStr=sprintf('Please use arrow keys to move. [%d out of %d] Steps: %d', next_map_index-number_of_practice_trials, ptrials-number_of_practice_trials, steps);
              end

              [offx, offy] = drawWorld(window, gridworld, visible, agent_x, agent_y, mon.wp, mon.hp, imageAgent, cellsize, 0);
              flipTime = Screen('Flip', window, flipTime + black_rectangle_time, 0);
            
              
              tic;  %get current time so that we can record theit reaction times
              rt_end=0;
              
              while ~exit_reached
                  
                                   
                  %-----------------------------------------------------------------------
                  %
                  %    Listen for interaction  
                  %
                  %-----------------------------------------------------------------------
                  
                   FlushEvents('keyDown');
                   [ keyIsDown, t, keyCode ] = KbCheck([], scanList);   %keyCode is an array of 256
                   ikeyCode = find(keyCode);
                   
                   if ~isempty(ikeyCode)
                       [keyCode] = readKeyboardBufferAndFlush(scanList, ikeyCode, keyCode);
                   end
                   
                   has_moved = 0; % was the agent moved during interaction?
                   if keyCode(escapeKey)
                      fprintf('Experiment skipped.\n');
                      exit_reached = 1;
                      escaped_experiment = 1;
                   elseif keyCode(KbName('DownArrow'))
                       
                       %process the keypress only if interaction is allowed
                       if agent_y < size(gridworld,1) 
                           if gridworld(agent_y+1, agent_x) ~=3
                            agent_y=agent_y+1;
                            has_moved=1;
                           end
                       end
   
                   elseif keyCode(KbName('UpArrow'))
                       
                       if agent_y > 1 
                           if gridworld(agent_y-1, agent_x) ~=3
                            agent_y=agent_y-1;
                            has_moved=1;
                           end
                       end
                          
                   elseif keyCode(KbName('LeftArrow'))
                       
                       if agent_x > 1
                           if gridworld(agent_y, agent_x-1) ~=3
                            agent_x=agent_x-1;
                            has_moved=1;
                           end
                       end
                           
                   elseif keyCode(KbName('RightArrow'))
                       
                       if agent_x < size(gridworld,2) 
                           if gridworld(agent_y, agent_x+1) ~=3
                            agent_x=agent_x+1;
                            has_moved=1;
                           end
                       end
                           
                   elseif keyCode > 0
                       fprintf('Unexpected key %s %d\n', KbName(keyCode), keyCode)
                   end
                   
                   %update the maze if the agent has moved
                   if has_moved
                       visible = updateVisible(gridworld, visible, agent_x, agent_y);
                       steps = steps+1;
                       rt_end=toc;
                       tic;
                       agent_path = sprintf('%s(%d,%d);', agent_path, agent_x, agent_y);
                       has_moved = 0;
                       redraw_needed = 1;
                       if next_map_index > number_of_practice_trials
                           step_counter = step_counter+1;
                       end
                   end
                   
                   if (redraw_needed )
                        writeToFile_no_ET(fileID, subject, rt_end*1000,  worldName, agent_path, visible); 
                        redrawWorld(worldName, gray, window, agent_y, agent_x, next_map_index, ptrials, steps, gridworld, visible, mon.wp, mon.hp, imageAgent, cellsize, flipTime, offy); 
                   end

                   
                   if (redraw_needed )
                       redraw_needed = 0;
                       flipTime = Screen('Flip', window, flipTime + 0.01,0);
                   end
                   
                   if (gridworld(agent_y, agent_x) == 2)
                       exit_reached = 1;
                       %fprintf('Exit!\n');
                   end
                   
                   
              end
        end
        
        
    end
    
    fclose(fileID);
end