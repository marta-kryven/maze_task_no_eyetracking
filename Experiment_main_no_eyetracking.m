%------------------------------------------------------------------------
%
%   Runs the basic maze solving task, no eyetracking
%
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
%   Runs the maze solving task and eyetracking
%
%------------------------------------------------------------------------
%
%  Changes Nov 02 2017
%  1. new log fields:
%           timestamp dd/mm/yyyy hh:mm:ss:ms
%
%  2. added a log when the black rectangle is shown 
%  
%  3. added a variable repeat_task_times, which will repeat the same task 
%
%------------------------------------------------------------------------
%   Changes Aug 02 2017 
%   1. Demographics dialog replaced by Subject ID dialog
%   
%   2. new log fields:
%       trialtype   --- practice or experiment
%       keyPressed  --- a readable name of the key that was pressed
%       keyAction   --- action that resulted from the keypress (D,U,L,R) or NA
%       validAction --- 1 if action was valid, not leading into a wall and 0 otherwise 
%       blackremains -- the number of black squares that remain in the maze
%       numsquaresopen- number of squares opened if an observation occurred, 0 otherwise
%       squaretype  --- O - observation, N - neutral, X - starting, G -
%                       goal seen, D - observation with more than 2 exits
%       numexits    --- number of exits from this cell
%
%   3. experimenter demo at the start of the experiment
%       
%   4. an option to return and redo practice (the goal will be moved to a new
%   location)
%
%   5. will show 30 mazes twice; please refer to the document 30mazes.pdf
%   for detailed explanation of how the mazes are designed
%
%   Note. RT is logged in the sense `how long did it take to make the move'
%   so a record of the kind: 1331	1tunnel	(1,1);(2,1); .... 
%   means that the subjects spent 1331ms in the cell (1,1);
%------------------------------------------------------------------------

clc 
clear all
close all
commandwindow; % focus on the command window
Priority(2);
KbName('UnifyKeyNames');
textColour = [0, 0, 0, 255];


%------------------------------------------------------------------------
%
% the same task will run this many times
%
%------------------------------------------------------------------------


repeat_task_times = 1;  

%------------------------------------------------------------------------
%
%   Read Subject ID for this Session
% 
%------------------------------------------------------------------------

subject = sprintf('temp_subject_ID_%d', int32(rand()*1000)); % generate a random temporary subject ID
prompt={'ID:'};               
title= 'Session ID';
answer=inputdlg(prompt,title); 

if (length(answer{1}) > 1) 
    subject = answer{1};
end

%------------------------------------------------------------------------
%
%   To make the most of the eyetracker we will use low resolution and
%   render stimuli as large as possible
%
%------------------------------------------------------------------------
          
[mon, dres, rm] = configMonitor(); % set resolution suitable for eyetracking 

try
    
    [oldVisualDebugLevel, oldSupressAllWarnings, slack, window, gray] = defaultPsychtoolboxSetup; % psychtoolbox setup
    mon.slack=Screen('GetFlipInterval',window)/2; % how long does it take to render a new frame
   
    %------------------------------------------------------------------------
    %
    %   Running the task
    %
    %------------------------------------------------------------------------


    escaped = 0;
    step_counter_1 = 0;
    step_counter_2 = 0;
    
    [escaped, step_counter_1, step_counter_2, fileID] = solving_main_no_eyetracking(subject, window, mon, repeat_task_times);
    
    
    %------------------------------------------------------------------------
    %
    %   If the experiment was finished successfully shows step stats to the subject 
    %
    %------------------------------------------------------------------------
    
    
    if ~escaped
        
        % final comments for the subject
        [text] = comment_input(window, 'How did you make your decisions? Please type your answer and press OK.' );
             %'How did you make your decisions\n during the expiment?\n');
             
        str = '';
        for i=1:size(text,1)  
            str = [str  text{i}];
        end
          
        fprintf(fileID, 'SubjectComment:%s\n', str);
        
        Screen('TextSize',window,30);
        DrawFormattedText(window, 'Thanks! \n\nPress any key to see how you did in maze-solving... ', 'center', 'center', [0 0 0]);
        DrawFormattedText(window, 'You''ve completed the experiment.', 'center', mon.hp+150, [0 0 0]);
        final_screen = Screen('Flip', window);

        KbWait;
        [ keyIsDown, t, keyCode ] = KbCheck;
        KbReleaseWait;  

        feedback = sprintf([ 'You took %d steps in the first session. \n\n',...
            'You took %d steps in the second session. \n\n',...
            'Previously people took between 280 and 430 steps.\n\n Press any key...'], ...
            step_counter_1, step_counter_2);
        
        DrawFormattedText(window, feedback, 'center', 'center', [0 0 0]);
        final_screen = Screen('Flip', window);
        KbWait;     

    end
    
    %------------------------------------------------------------------------
    %
    %   Final comments for the experimenter 
    %
    %------------------------------------------------------------------------
        
    
    [text] = comment_input(window, 'Please enter experimenter comments about this session:');
    str = '';
    for i=1:size(text,1)  
        str = [str  text{i}];
    end
    fprintf(fileID, 'ExperimenterComment:%s\n', str);
    
    fclose(fileID);
    psychToolboxCleanup(oldVisualDebugLevel, oldSupressAllWarnings);
    
catch
    psychToolboxCleanup(oldVisualDebugLevel, oldSupressAllWarnings);
    psychrethrow(psychlasterror);
    
end

SetResolution(rm, dres.width, dres.height); %restore monotor resolution

disp('Program finished.');


%------------------------------------------------------------------------
%
%    place the cursor far below the last line when running the experiment
%
%------------------------------------------------------------------------










