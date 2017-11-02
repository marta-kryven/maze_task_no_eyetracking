

%show maze solving instructions at the start of the experiment
function [esc] = showIntroToPractice(window)

    esc = 0;
    Screen('FillRect', window, 127);
    textColour = [0, 0, 0, 255];
    Screen('TextFont', window, 'Times');
    Screen('TextSize', window, 25); 
    strIntr = ['Now it is your turn to practice!\n\n' ...
        'Press any key to start, then use arrow keys to move.\n\n'...
        'Steps will not be counted during practice.\n\n' ...
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
    end
end