function [ gridworld, worldw, worldh, visible ] = initialiseWorld(maps, next_map_index)

  [ gridworld, worldw, worldh] = readWorld(maps{next_map_index});
              
   %initialise the visible area
   visible = gridworld;
   visible(gridworld == 3) = 1;
   visible(gridworld < 3 ) = 0;
   
   %the starting cell is alwyas visible
   visible(1, 1) = 1;
   
   % let the agent look around
   visible = updateVisible(gridworld, visible, 1, 1);
end