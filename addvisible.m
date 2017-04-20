% this implies that v is changed by the function
function [ v ] = addvisible(fromx, fromy, px, py, level, v, gridworld)

    %fprintf('addvisible (%d,%d) (%d,%d)', fromx, fromy, px, py);
    ww = size(gridworld,2); % x
    wh = size(gridworld,1); %
    
    if ((px < 1 || py < 1 || px > ww || py > wh ) || (fromx==px && fromy==py))
        %fprintf('out of range\n');
        return;
    else
        v(py, px) = 0;

        if (gridworld( py, px) == 3) 
            %fprintf('wall\n');
            return;
        else
            b = 1;
            if (level > 1 || (abs(fromx-px) + abs(fromy-py) > 1) ) 

              % Draw four lines connecting the corners of the current cell and the cell which visibility is being checked.
              % The cell (px,py) is visible from (xnow, ynow) only if all four lines do not intersect walls
              if (b==1) 
                  %top left corner to top corner
                  b = checkline(fromx+0.1, fromy+0.1, px+0.1, py+0.1, level*50.0, gridworld);
              end
              
              if (b==1) 
                  %bottom left corner to bottom left corner
                  b = checkline(fromx+0.9, fromy+0.1, px+0.9, py+0.1, level*50.0, gridworld);
              end
              
              if (b==1) 
                   %bottom right corner to bottom rigt corner
                  b = checkline(fromx+0.9, fromy+0.9, px+0.9, py+0.9, level*50.0, gridworld);
              end
              
              if (b==1) 
                  b = checkline(fromx+0.1, fromy+0.9, px+0.1, py+0.9, level*50.0, gridworld);
              end
            end

            if (b==1) 
                v(py, px) = 1;
                %fprintf('visible\n');
            else
                %fprintf('no\n');
            end
        end
    end
 end