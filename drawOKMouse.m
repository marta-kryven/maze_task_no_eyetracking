function ok = drawOKMouse(window, x, y)

   Screen('FillRect', window, 127.5);

   white = [255,255,255];
   green = [0,255,0];
   
   xok = [ 140 240];
   yok = [ 720 750];
   
   ok = 0;
   
   if (y > yok(1) && y < yok(2) && x > xok(1) && x < xok(2)) 
      ok = 1; %respond
   end 
        

   if ok
       Screen('FillRect', window, green, [xok(1) yok(1) xok(2) yok(2) ] );
   else
       Screen('FillRect', window, white, [xok(1) yok(1) xok(2) yok(2) ] );
   end
   
   textColour = [0,0,0];
   DrawFormattedText( window, 'OK', xok(1)+40, yok(1)+5, textColour);
   
   
   
end