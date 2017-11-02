% agent vis model
function [ vis ] = updateVisible( gridworld, v, x, y )

    vis = v; 
    vis(y,x)=1;
    ww = size(gridworld,2); % x
    wh = size(gridworld,1); %
    
    %problem: addvisible (1,1,2,6,5) is visible
   
    for level = 7:-1:1
        for px = max(x-level, 1):1:min(x+level,ww)
            
          if y-level > 0
            v1 = addvisible(x, y, px, y-level, level, v, gridworld); 
            vis(v1==1)=1;
          end
          
          if y+level <= wh
            v2 = addvisible(x, y, px, y+level, level, v, gridworld); 
            vis(v2==1)=1;
          end

        end
        
        for py = max(y-level,1):1:min(y+level,wh)
            
          if x+level <=ww
            v3 = addvisible(x, y, x+level, py, level, v, gridworld); 
            vis(v3==1)=1;
          end
          
          if  x-level > 0
            v4 = addvisible(x, y, x-level, py, level, v, gridworld); 
            vis(v4==1)=1;
          end
                    
        end
       
    end 

end  