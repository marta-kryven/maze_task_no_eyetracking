% agent vis model
function [ vis, ...
    numsquaresopen, ... % if an observation occurred, how many squares were opened? 0 otherwise
    squaretype, ... % N -- neutral, O - observation, D - Observation with more than 2 exits % G - goal is seen
    blackremains, ... % how many black squares remain unseen
    numexits ... % number of exits from this sqaure
    ] = updateVisible( gridworld, v, agent_x, agent_y )


% numsquaresopen, squaretype, blackremains
    numsquaresopen = 0;
    squaretype = 'N';
    blackremains = 0;

    vis = v; 
    vis(agent_y,agent_x)=1;
    ww = size(gridworld,2); % x
    wh = size(gridworld,1); %
    
    % problem: addvisible (1,1,2,6,5) is visible
   
    for level = 7:-1:1
        for px = max(agent_x-level, 1):1:min(agent_x+level,ww)
            
          if agent_y-level > 0
            v1 = addvisible(agent_x, agent_y, px, agent_y-level, level, v, gridworld); 
            vis(v1==1)=1;
          end
          
          if agent_y+level <= wh
            v2 = addvisible(agent_x, agent_y, px, agent_y+level, level, v, gridworld); 
            vis(v2==1)=1;
          end

        end
        
        for py = max(agent_y-level,1):1:min(agent_y+level,wh)
            
          if agent_x+level <=ww
            v3 = addvisible(agent_x, agent_y, agent_x+level, py, level, v, gridworld); 
            vis(v3==1)=1;
          end
          
          if  agent_x-level > 0
            v4 = addvisible(agent_x, agent_y, agent_x-level, py, level, v, gridworld); 
            vis(v4==1)=1;
          end
                    
        end
       
    end 
    
    
    % now count black squares and the difference between the old and new
    % visible area
    
    gsquare = 0;
    for i = 1:size(gridworld,2)
        for j = 1:size(gridworld,1)
            
            if ~vis(j,i)
                blackremains = blackremains+1;
            end
            
            if  ~(vis(j,i) == v(j,i))
                numsquaresopen = numsquaresopen+1;
                
                if  (vis(j,i) == 1 && gridworld(j,i) == 2)
                    gsquare = 1;
                end
            end
            
        end
    end
    
    if gsquare
        squaretype = 'G';
    elseif numsquaresopen > 1
        squaretype = 'O';
    end
         
    % calculate the number of exits
    numexits = 0;
    
    if (agent_x > 1)
        if gridworld(agent_y, agent_x-1) ~= 3
            numexits = numexits+1;
        end
    end
    
    if (agent_x < size(gridworld,2))
        if gridworld(agent_y, agent_x+1) ~= 3
            numexits = numexits+1;
        end
    end
    
    if (agent_y > 1)
        if gridworld(agent_y-1, agent_x) ~= 3
            numexits = numexits+1;
        end
    end
    
    if (agent_y < size(gridworld,1))
        if gridworld(agent_y+1, agent_x) ~= 3
            numexits = numexits+1;
        end
    end
    
    % if a square has > 2 exits it is likely a D square
    % if only 2 it is certainly an O
    % a number of squares with > 2 exits are actually 'O' squares
    % as for example entering a room which is empty and going right out,
    % in which case only one direction is meaningfull
    
    if numexits > 2 && squaretype=='O'
        squaretype='D';
    end

end  