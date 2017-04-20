function [oldVisualDebugLevel, oldSupressAllWarnings, slack, window, gray] = defaultPsychtoolboxSetup
    Screen('Preference', 'SkipSyncTests', 1);  
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    
    screens = Screen('Screens'); %get screen numbers
    %whichScreen = max(screens);

    whichScreen = max(screens); % = 0
    [window, rect] = Screen('OpenWindow', whichScreen);
    slack = Screen('GetFlipInterval', window)/2;
    
    W=rect(RectRight); % screen width
    H=rect(RectBottom); % screen height
    black = BlackIndex(window);  
    white = WhiteIndex(window);  
                                      
    gray = (black + white) / 2;  
    if round(gray)==white
        gray=black;
    end
    
    fprintf('Opened screen width: %d, height: %d', W, H);
    
    fprintf('Ready to start the experiment!\n');
end