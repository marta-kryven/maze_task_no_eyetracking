
%show maze solving instructions at the start of the experiment
function [flipTime] = showInstructions(window)

    Screen('FillRect', window, 127);
    textColour = [0, 0, 0, 255];
    Screen('TextFont', window, 'Times');
    Screen('TextSize', window, 25); 
    strIntr = ['Welcome to our study! \n\nIT IS IMPORTANT TO READ THE INSTRUCTIONS CAREFULLY\n\n' ...
        'Escape the maze in AS FEW MOVES AS POSSIBLE by reaching the exit (the red square).\n\n'...
        'Blue squares are walls. You cannot see through the walls. The squares you cannot see yet are black.\n\n'...
        'The exit is EQUALLY LIKELY to be behind ANY of the black squares.\n\n '...
        'In the end you will see how many steps you took compared to other people.\n\n'...
        'There are 5 practice mazes and 12 test mazes. \n\n' ...
        'Press any key to start, then use arrow keys to move.'...
        ];
    DrawFormattedText( window, strIntr, 'center', 190, textColour);
    flipTime=Screen('Flip',window);
end