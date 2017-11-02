function [esc] = showSplash(window)

    esc = 0;
    
    Screen('FillRect', window, 127);
    textColour = [0, 0, 0, 255];
    Screen('TextFont', window, 'Times');
    Screen('TextSize', window, 25); 
    strIntr = ['Nice job! You have finished the first half!\n\n', ...
        'Now you will see the same mazes again. \n\n', ...
        'Press any key to continue...\n\n' ...
        ];
    
    DrawFormattedText( window, strIntr, 'center', 190, textColour);
    flipTime=Screen('Flip',window);
    
    KbWait;
    [ keyIsDown, t, keyCode ] = KbCheck;   % wait for any key to be pressed
    KbReleaseWait;
    
    fprintf('Starting experiment...\n');
    
    escapeKey = KbName('ESCAPE');
    if keyCode(escapeKey)
      fprintf('Experiment skipped.\n');
      esc = 1;
    else
      fprintf('Block 2...\n'); 
    end
    
end