function [flipTime] = redrawWorld(worldName, gray, window, agent_y, agent_x, next_map_index, ptrials, steps, gridworld, visible, W, H, imageAgent, cellsize, flipTime, offy)
     %disp(['Drawing... ' worldName]);
     Screen(window, 'FillRect', gray); 
     visible(agent_y, agent_x) = 1;
     
     stepStr = '';
     if next_map_index < 6
        stepStr=sprintf('Please use arrow keys to move. [Practice] Steps: %d', steps);
     else
        stepStr=sprintf('Please use arrow keys to move. [%d out of %d] Steps: %d', next_map_index-5, ptrials-5, steps);
     end

     DrawFormattedText( window, stepStr, 'center', offy-60, [255,0,0]);
     drawWorld(window, gridworld, visible, agent_x, agent_y, W, H, imageAgent, cellsize, 0);
end