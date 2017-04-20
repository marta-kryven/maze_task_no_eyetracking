clc 
clear all
close all

[oldVisualDebugLevel, oldSupressAllWarnings, slack,    window, gray] = ...
    defaultPsychtoolboxSetup;

try
    
    fprintf('Starting test...\n');
    
    Screen('TextSize',window,50);
    DrawFormattedText(window, 'Thanks!', 'center', 'center', [0 0 0]);
    DrawFormattedText(window, 'Press any key...', 'center', 250, [0 0 0]);
    t.final_screen = Screen('Flip', window);
    
    KbWait;                 
    
    psychToolboxCleanup(oldVisualDebugLevel, oldSupressAllWarnings);
    
catch
    psychToolboxCleanup(oldVisualDebugLevel, oldSupressAllWarnings);
    psychrethrow(psychlasterror);
    
end