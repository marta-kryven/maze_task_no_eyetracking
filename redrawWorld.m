function [flipTime] = redrawWorld(worldName, gray, window, agent_y, agent_x, ...
     next_map_index, ptrials, steps, gridworld, visible, W, H, imageAgent, ...
     cellsize, flipTime, offy, debug_show_filenames)
     %disp(['Drawing... ' worldName]);
     Screen(window, 'FillRect', gray); 
     visible(agent_y, agent_x) = 1;
     drawWorld(window, gridworld, visible, agent_x, agent_y, W, H, imageAgent, cellsize, 0, 0, debug_show_filenames, worldName);
end