function [ b ] = checkline(x1, y1, px, py, step, gridworld)
% boolean checkline(float x1, float y1, float px, float py, float step) {
    dx = (x1-px)/step;
    dy = (y1-py)/step;
    
    ww = size(gridworld,2); % x
    wh = size(gridworld,1); %
 
    fx = px+dx;
    fy = py+dy;
    x = floor(fx);
    y = floor(fy);

    b=0;
    onepass = 1;
    while (x ~= floor(x1) || y ~= floor(y1) || onepass ==1)  
       onepass = 0;
       if (x < 0 || y < 0 || x > ww || y > wh ) 
         fprintf('err: out of map at (%d,%d) while checking (%d, %d) fxfy: %d, %d\n', x,y,px,py,fx,fy);
         b=0;
         return;
       else 
         if (gridworld(y,x)==3) 
             b=0;
             return;
         else       
           fx =fx+dx; 
           fy =fy+dy;      
           x = floor(fx);  
           y = floor(fy);
         end
       end
    end 
    b=1;

end

