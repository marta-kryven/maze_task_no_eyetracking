function [ gridworld, worldw, worldh, visible, blackremains ] = initialiseWorld(worldname, ispractice)

  blackremains = 0;
  [ gridworld, worldw, worldh] = readWorld(worldname);
              
   %initialise the visible area
   visible = gridworld;
   visible(gridworld == 3) = 1;
   visible(gridworld < 3 ) = 0;
   
   %the starting cell is alwyas visible
   visible(1, 1) = 1;
   
   % let the agent look around
   visible = updateVisible(gridworld, visible, 1, 1);
   
   %-----------------------------------------------------------------------
   %
   %    If we are parcticing, randomise goal location
   %
   %-----------------------------------------------------------------------
   
   if ispractice
        
        for i = 1:size(gridworld,2)
            for j = 1:size(gridworld,1)
                if gridworld(j,i) == 2 
                    gridworld(j,i) = 0; %remove the old goal
                end
                
                if ~visible(j,i)
                    blackremains = blackremains+1;
                end
            end
        end
        
        whichone = floor(rand(1)*blackremains);
        setgoal = 0; 
        
        for i = 1:size(gridworld,2)
            for j = 1:size(gridworld,1)
               
                if ~visible(j,i)
                    
                    if whichone == 0
                        gridworld(j,i) = 2;
                        setgoal=1;
                        break;
                    end
                    
                    whichone = whichone-1;
                end
            end
            
            if whichone == 0 && setgoal
                break;
            end
        end
   end
   
   
   
end