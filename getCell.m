
% determine the cell in which the fixation falls based on the size of the
% world and it's offset

function [cellx, celly] = getCell(world_w, world_h, worldtopleft_x, worldtopleft_y, cellsize, eye_x, eye_y)

        cellx=0;
        for x=1:world_w
            if worldtopleft_x+(x-1)*cellsize < eye_x &&  worldtopleft_x+x*cellsize > eye_x
                cellx=x;
            end
        end

        celly=0;
        for y=1:world_h
            if worldtopleft_y+(y-1)*cellsize < eye_y &&  worldtopleft_y+y*cellsize > eye_y
                celly=y;
            end
        end

end
