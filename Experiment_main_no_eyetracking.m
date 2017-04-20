%------------------------------------------------------------------------
%
%   Runs the basic maze solving task, no eyetracking
%
%------------------------------------------------------------------------

clc 
clear all
close all                       

commandwindow; % focus on the command window
Priority(2);
KbName('UnifyKeyNames');

textColour = [0, 0, 0, 255];
demographics_here = 'demo_dir/';

subject = sprintf('SL%d', int32(rand()*1000)); % generate a random subject ID
fileIDSubject = fopen([demographics_here subject '_demo.txt'],'w');
subjectDemographics(fileIDSubject); % collect birthday and gender

[mon, dres, rm] = configMonitor(); % set resolution suitable for eyetracking 

try
    
    [oldVisualDebugLevel, oldSupressAllWarnings, slack, window, gray] = defaultPsychtoolboxSetup; % psychtoolbox setup
    mon.slack=Screen('GetFlipInterval',window)/2; % how long does it take to render a new frame
    step_counter = solving_main_no_eyetracking(subject, window, mon); %solving task
    
    Screen('TextSize',window,30);
    DrawFormattedText(window, 'Thanks! \n\nPress any key to see how you did in maze-solving... ', 'center', 'center', [0 0 0]);
    DrawFormattedText(window, 'You''ve completed the experiment.', 'center', mon.hp+150, [0 0 0]);
    final_screen = Screen('Flip', window);
    
    KbWait;
    [ keyIsDown, t, keyCode ] = KbCheck;
    KbReleaseWait;  
    
    feedback = sprintf('You took %d steps in total. \n\n Previously people took between 165 and 220 steps.\n\n Press any key to continue...', step_counter );
    DrawFormattedText(window, feedback, 'center', 'center', [0 0 0]);
    final_screen = Screen('Flip', window);
    KbWait;     
    
    psychToolboxCleanup(oldVisualDebugLevel, oldSupressAllWarnings);
    
catch
    psychToolboxCleanup(oldVisualDebugLevel, oldSupressAllWarnings);
    psychrethrow(psychlasterror);
    
end

SetResolution(rm, dres.width, dres.height); %restore monotor resolution
