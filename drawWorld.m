%draw the world and the agent 

% texture_appearance controls how the maze is coloured, which might elicit
% more fixations
 % 1 = make the maze textured 
 % 2 = equiluminous colours for walls and rooms
 % 0 = no texturing, the same as it looks on the web

function [offx, offy] = drawWorld( win, gridworld, visible, ...
    agent_x, agent_y, W, H, ...
    imageDisplay, cellsize, texture_appearance, wallTex, ...
    debug_show_filenames, worldname )
    
    width = cellsize*size(gridworld,2); % x
    height = cellsize*size(gridworld,1); % y
    offx = W/2 - width/2;
    offy = H/2 - height/2;

    Screen('DrawLine', win ,[1,0,0], offx, offy, offx+width, offy);
    Screen('DrawLine', win ,[1,0,0], offx, offy, offx, offy+height);
    Screen('DrawLine', win ,[1,0,0], offx+width, offy, offx+width, offy+height);
    Screen('DrawLine', win ,[1,0,0], offx, offy+height,  offx+width, offy+height);

    for i = offx:cellsize:offx+width
       Screen('DrawLine', win ,[0,0,0], i, offy, i, offy+height); 
    end
    
    for i = offy:cellsize:offy+height
       Screen('DrawLine', win ,[0,0,0], offx, i, offx+width, i); 
    end

    for i = 1:size(gridworld,2)
        for j = 1:size(gridworld,1)
            
            skip_drawing = 0;
            
            x=offx+(i-1)*cellsize+1;
            y=offy+(j-1)*cellsize+1;
            
            if ( texture_appearance == 3)
                colour = [200,200,200];
            else 
                colour = [255,255,255];
            end
            
            if gridworld(j,i) == 3
                 if ( texture_appearance == 0)
                    colour = [70,70,110,255];
                 elseif ( texture_appearance == 3)
                    colour = [110,110,130,255];
                 elseif (texture_appearance == 1)
                     Screen('FillRect', win, [255,255,255], [x+1 y+1 x+cellsize-2 y+cellsize-2] );
                     Screen('DrawTexture', win, wallTex, [],[x+1 y+1 x+cellsize-2 y+cellsize-2]); 
                     skip_drawing = 1;
                     %fprintf('X');
                 else
                    colour = [90,110,90,255];
                 end
            else
                if visible(j,i)==0
                   if ( texture_appearance == 0 || texture_appearance == 1)
                      colour = [0,0,0,255]; 
                   elseif ( texture_appearance == 3)
                      colour = [50,50,50,255];
                   else 
                      colour = [110,90,90,255];
                   end
                else
                   if gridworld(j,i) == 2
                    colour = [255,0,0,255]; 
                   end
                end
            end
            
            %Screen('FillRect', win, colour, [x+1 y+1 x+cellsize-2 y+cellsize-2] );
            
            if i==agent_x && j==agent_y 
                Screen('FillRect', win, [255,255,255], [x+1 y+1 x+cellsize-2 y+cellsize-2] );
                Screen('DrawTexture', win, imageDisplay, [],[x+1 y+1 x+cellsize-2 y+cellsize-2]); 
            else
                if ~skip_drawing
                    Screen('FillRect', win, colour, [x+1 y+1 x+cellsize-2 y+cellsize-2] );
                end
            end
        end
    end
    
    if debug_show_filenames
        DrawFormattedText( win, worldname, 'center', offy-30, [255,0,0]);
    end
    
end