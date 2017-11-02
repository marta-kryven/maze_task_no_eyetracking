function [esc] = askIfMorePractice(window, repeat_task_times, num_mazes)

    esc = 0;
    
    Screen('FillRect', window, 127);
    textColour = [0, 0, 0, 255];
    Screen('TextFont', window, 'Times');
    Screen('TextSize', window, 25); 
    
    s = sprintf ('The experiment consists of %d blocks of %d mazes.\n\n', repeat_task_times, num_mazes);
    strIntr = ['Nice job! You have finished practice!\n\n', ...
        'If you are ready to start the experiment, press the DOWN ARROW.\n\n', ...
        s ...
        'The mazes get harder as you go along\n\n',...
        'To go back to practice press the UP ARROW.\n\n ', ...
        'From now on steps will be counted toward the score.\n\n' ...
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
    elseif keyCode(KbName('DownArrow'))
      fprintf('Proceed with experiment.\n');  
    else
      fprintf('Practice more.\n');
      esc = 2;
    end
    
end